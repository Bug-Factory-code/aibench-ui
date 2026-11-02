# 第三方开源组件声明

本仓库不重新分发任何第三方代码；以下组件按其原始许可证使用。

| 组件 | 用途 | 许可证 | 说明 |
|---|---|---|---|
| [AISBench benchmark](https://github.com/AISBench/benchmark) | 被桥接的评测框架（容器/CLI 方式调用） | MIT | 运行时依赖，不随本仓库分发 |
| aisbench_auto_tools_prefix | Prefix 专项测试工具（可选挂载） | MIT | 运行时挂载，不随本仓库分发 |
| plotly.js | 原生图表本地化资源（启动后按需下载至 `data/static/`） | MIT | 运行时获取 |
| Vue 3 / Pinia / vue-router | 前端框架 | MIT | npm 依赖 |
| Element Plus / @element-plus/icons-vue | UI 组件库 | MIT | npm 依赖 |
| ECharts | 对比图表 | Apache-2.0 | npm 依赖 |
| Vite / @vitejs/plugin-vue | 构建工具 | MIT | devDependencies |
| FastAPI / Pydantic | 后端框架 | MIT | pip 依赖 |
| Uvicorn | ASGI 服务器 | BSD-3-Clause | pip 依赖 |
| httpx | 服务探活 | BSD-3-Clause | pip 依赖 |
