-- 조별 휴가 신청판: Supabase SQL Editor에 붙여 넣고 Run 한 번.
-- 인원·신청·설정을 컬렉션/문서 모양 그대로 표 하나에 저장한다.

create table if not exists public.leave_docs (
  col        text        not null,               -- members / requests / settings
  id         text        not null,
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (col, id)
);

-- PRD 결정 11(보안 장치 없음)에 따라 링크를 아는 사람은 읽고 쓸 수 있다.
alter table public.leave_docs enable row level security;
drop policy if exists leave_docs_all on public.leave_docs;
create policy leave_docs_all on public.leave_docs
  for all to anon, authenticated using (true) with check (true);

-- 다른 사람의 신청이 바로 보이도록 실시간 알림을 켠다.
do $$ begin
  alter publication supabase_realtime add table public.leave_docs;
exception when duplicate_object then null; end $$;

-- 같은 조 신청을 한 줄로 세우는 짧은 잠금(선착순 보장).
create table if not exists public.leave_locks (
  key    text primary key,
  holder text not null,
  until  timestamptz not null
);
alter table public.leave_locks enable row level security;  -- 정책 없음: 아래 함수로만 접근

create or replace function public.leave_acquire(p_key text, p_holder text, p_ttl_ms int)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare ok boolean;
begin
  with r as (
    insert into leave_locks (key, holder, until)
    values (p_key, p_holder, now() + make_interval(secs => least(greatest(p_ttl_ms, 1000), 600000) / 1000.0))
    on conflict (key) do update
      set holder = excluded.holder, until = excluded.until
      where leave_locks.until < now() or leave_locks.holder = excluded.holder
    returning 1
  )
  select exists (select 1 from r) into ok;
  return ok;
end $$;

grant execute on function public.leave_acquire(text, text, int) to anon, authenticated;
