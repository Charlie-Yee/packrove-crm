# Supabase 配置状态

V9.5 已写入以下云端项目配置：

- Project URL: https://tqsxaggkspkaodutlrcd.supabase.co
- 使用 Publishable Key
- REQUIRE_LOGIN: true

注意：Supabase Client 需要项目根地址，因此未使用 `/rest/v1/` 后缀。

上线前仍需在 Supabase SQL Editor 中确认已经执行：

1. `supabase/01_schema.sql`
2. `supabase/02_rls_authenticated.sql`

如果现有数据库已经有客户，不要重复执行 `03_seed_customers.sql`。
