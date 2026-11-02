# 贡献指南

## 本地开发

```bash
# 后端（自带热重载可换 uvicorn --reload）
pip install -r backend/requirements.txt
AISBENCH_WORK_PATH=/path/to/benchmark PREFIX_TOOL_DIR=/path/to/prefix_tools python3 run.py

# 前端（Vite 代理 /api 到 localhost:8001）
cd frontend && npm install && npm run dev
```

## 提交规范

- 提交信息用祈使句中文或英文均可，如 `feat: 合成数据集支持 tokenid 模式`
- 改动后请跑通：`python3 -m py_compile backend/app/*.py` 与 `cd frontend && npm run build`
- 新增后端参数必须同时维护 `runner.py` 的 argv 白名单与 `formSchema.js`（两处是安全边界）

## Issue 反馈

请附上首页「环境自检」各条目的状态与详情，以及任务 `work_dir` 下的 `task.log` 尾部。
