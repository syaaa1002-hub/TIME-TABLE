# 조별 휴가 신청판

5개 조 근무표(주간 → 야간 → 휴무 3일)에 맞춰 휴가 자리를 확인하고, 신청·승인하고, 월별 결재표를 뽑는 웹페이지입니다. 요구사항은 [PRD](PRD%20—%20조별%20휴가%20신청판.md)에 있습니다.

| 파일 | 하는 일 |
| --- | --- |
| `leave-board.html` | 페이지 본체. claude.ai 아티팩트와 GitHub Pages가 같은 파일을 씁니다. |
| `index.html` | GitHub Pages 입구. `leave-board.html`과 `config.js`를 불러옵니다. |
| `config.js` | Supabase 주소와 anon 키 (GitHub Pages용) |
| `api/config.js` | Vercel 환경변수의 Supabase 주소와 anon 키를 페이지에 내려주는 함수 |
| `vercel.json` | Vercel 설정 |
| `supabase-setup.sql` | Supabase 표와 잠금 함수 만들기 |

페이지는 열린 곳에 따라 저장소를 고릅니다. claude.ai에서 열면 claude.ai 공유 저장소를, GitHub 주소에서 열면 Supabase를 씁니다. 두 저장소의 데이터는 서로 이어지지 않습니다.

## Vercel로 여는 방법 (권장)

1. **Supabase 프로젝트 만들기**: https://supabase.com 에서 새 프로젝트를 만듭니다. 지역은 Northeast Asia (Seoul), 무료 플랜이면 됩니다.
2. **표 만들기**: SQL Editor에 `supabase-setup.sql` 내용을 붙여 넣고 **Run**을 누릅니다.
3. **Vercel에 가져오기**: https://vercel.com 에 GitHub 계정으로 로그인 → **Add New… → Project** → `TIME-TABLE` 저장소 **Import**. Framework Preset은 **Other**, 빌드 설정은 비워 둡니다.
4. **환경변수 넣기**: 같은 화면의 Environment Variables에 두 개를 넣고 **Deploy**를 누릅니다.
   - `SUPABASE_URL`: Supabase → Project Settings → API의 Project URL
   - `SUPABASE_ANON_KEY`: 같은 화면의 anon public 키 (`service_role` 키는 넣지 마세요)
5. **관리자 비밀번호 정하기**: 배포 주소(`https://….vercel.app`)가 열리면 바로 "관리" 탭에서 관리자 비밀번호를 정하세요.

이후 `main`에 푸시할 때마다 Vercel이 자동으로 다시 배포합니다. 환경변수를 나중에 넣거나 바꿨다면 Vercel의 Deployments에서 **Redeploy**를 한 번 누르세요.

## GitHub Pages로 여는 방법

1. **Supabase 프로젝트 만들기**: https://supabase.com 에서 새 프로젝트를 만듭니다. 지역은 Northeast Asia (Seoul), 무료 플랜이면 됩니다.
2. **표 만들기**: SQL Editor에 `supabase-setup.sql` 내용을 붙여 넣고 **Run**을 누릅니다.
3. **키 넣기**: Project Settings → API에서 **Project URL**과 **anon public** 키를 복사해 `config.js`에 넣고 커밋합니다. `service_role` 키는 절대 넣지 마세요.
4. **Pages 켜기**: GitHub 저장소 → Settings → Pages → Source를 **Deploy from a branch**, Branch를 `main` / `/ (root)`로 정하고 Save를 누릅니다. 1~2분 뒤 https://syaaa1002-hub.github.io/TIME-TABLE/ 에서 열립니다.
5. **관리자 비밀번호 정하기**: 주소가 열리면 바로 "관리" 탭에서 관리자 비밀번호를 정하세요. 비밀번호가 없을 때는 처음 연 사람이 정할 수 있습니다.

## 주의

- 주소를 아는 사람은 누구나 열고 데이터를 읽고 쓸 수 있습니다(PRD 결정 11). 이름·계급·조·휴가 일정이 인터넷의 Supabase 서버에 저장되므로, 부대 보안 규정상 외부 서비스에 올려도 되는지 먼저 확인하세요.
- 사무실 PC에서 `github.io`와 `supabase.co`에 접속할 수 있어야 합니다.
