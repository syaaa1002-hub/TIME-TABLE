// Vercel 서버 함수: 환경변수의 Supabase 주소와 anon 키를 페이지에 내려준다.
// anon 키는 브라우저에 공개되는 용도의 키라 내려줘도 된다. service_role 키는 쓰지 않는다.
module.exports = (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  res.setHeader('Content-Type', 'application/json; charset=utf-8');
  res.end(JSON.stringify({
    supabaseUrl: process.env.SUPABASE_URL || '',
    supabaseAnonKey: process.env.SUPABASE_ANON_KEY || '',
  }));
};
