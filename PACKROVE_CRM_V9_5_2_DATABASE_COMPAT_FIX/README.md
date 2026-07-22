# PACKROVE CRM V9.5 — Follow-up Engine Final

这是一个可实际操作的单页 CRM。未配置 Supabase 时自动使用浏览器 LocalStorage，并载入旧版提取的 9 个真实客户；配置后切换为云端模式。

## 已落地功能

- Dashboard 今日任务：首次开发、二触、三触、已建联待跟、报价跟进
- 客户 CRUD、搜索、筛选、未建联/已建联双客户池
- 客户 360：画像、需求、顾虑、下一步、时间轴
- 跟进引擎：一触 +3天、二触 +5天、三触 +7天
- 客户回复后一键转入已建联池
- 报价 → PI → 订单 → 发货基础闭环
- Excel/JSON/CSV 导入，JSON/CSV 导出备份
- Supabase 邮箱密码登录与云端 CRUD
- 9 个历史客户 seed SQL 和本地初始化数据

## 直接试用

运行 `start-local.bat`，浏览器打开 `http://localhost:8080`。未配置 Supabase 时显示“本地演示模式”。

## 云端启用

1. 创建 Supabase 项目。
2. SQL Editor 依次执行：`supabase/01_schema.sql`、`02_rls_authenticated.sql`、`03_seed_customers.sql`。
3. 在 Supabase Auth 创建用户或启用邮箱注册。
4. 修改 `js/config.js`：填写 Project URL 与 Publishable Key。不要把 Secret/Service Role Key 放进前端。
5. 上传 GitHub，再导入 Vercel；本项目是纯静态项目，无需构建命令。


## V9.5.1 浏览器后退修复

- 页面切换会写入浏览器历史记录。
- 从“今日待跟”等页面点击浏览器后退，会返回“概览”。
- 支持在概览、客户池、报价、PI、订单、发货、统计和设置之间前进/后退。
- 页面地址会显示 `#dashboard`、`#tasks` 等视图标记。


## V9.5.2 旧数据库兼容修复

当前线上数据库若来自 PACKROVE CRM V2，请先在 Supabase SQL Editor 完整执行：

`supabase/00_V2_TO_V95_MIGRATION.sql`

它会保留旧客户并补齐新版需要的：
- timeline
- quotations
- pi_documents
- orders 新字段
- shipments 新字段
- customers 新字段和RLS策略

前端也已修改：即使报价、PI等可选表暂时缺失，客户列表仍然能够加载。
