# PACKROVE CRM V2 云端版

## 已包含
- 客户CRM与A/B/C分类
- 今日待跟、逾期和3天内提醒
- 完整跟进时间轴
- 报价、PI、订单、发货、样品管理
- 数据统计与销售漏斗
- 手机端和深色模式
- Excel导出、JSON一键备份/恢复
- 本地规则AI分析与英文跟进话术
- Supabase邮箱注册/登录与云端同步

## 第一步：升级数据库
进入 Supabase → SQL Editor → New query，复制 `supabase_v2.sql` 全部内容并点击 Run。

## 第二步：本地预览
不要直接双击 index.html（浏览器模块和路由可能受限制）。
在本目录打开终端运行：
`python -m http.server 8080`
然后访问：
`http://localhost:8080`

## 第三步：部署到 Vercel
1. 把本文件夹上传到 GitHub 新仓库。
2. Vercel → Add New → Project → Import Git Repository。
3. Framework Preset 选择 Other。
4. Build Command 留空，Output Directory 留空。
5. 点击 Deploy。
6. 部署后，将 Supabase → Authentication → URL Configuration：
   - Site URL 改为你的 Vercel 正式网址
   - Redirect URLs 加入 `https://你的域名/**`

## 首次使用
1. 打开网站注册邮箱账户。
2. 邮箱确认后登录。
3. 数据管理 → 导入现有9位客户。

## 安全
网页仅使用 Publishable Key；不要把 Secret Key 或 service_role Key 放进任何前端文件。
RLS策略确保登录用户只能访问自己的数据。

## AI功能说明
当前“AI助手”为本地规则版，不会上传聊天内容。
真正的大模型自动分析需要额外建立Vercel Serverless Function，并通过环境变量保存API密钥。
