# 部署说明

## Supabase
依次执行 `01_schema.sql`、`02_rls_authenticated.sql`、`03_seed_customers.sql`。在 Authentication 中创建登录账号。

## 前端
编辑 `js/config.js`，填写 `SUPABASE_URL` 和 `SUPABASE_PUBLISHABLE_KEY`。只可使用浏览器安全的 Publishable/Anon Key。

## Vercel
把项目根目录上传 GitHub，在 Vercel 导入仓库，Framework 选择 Other，Build Command 留空，Output Directory 留空。
