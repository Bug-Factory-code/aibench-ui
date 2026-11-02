#!/usr/bin/env bash
# AISBench UI 一键安装/管理脚本（离线）
# 用法:
#   bash install.sh        # 完整安装并启动（默认：加载镜像 → 装依赖 → 启动 → 打印 Token）
#   bash install.sh image  # 仅加载内置 docker 镜像
#   bash install.sh deps   # 仅安装后端依赖
#   bash install.sh start  # 启动服务
#   bash install.sh stop   # 停止服务
#   bash install.sh token  # 打印访问 Token
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
mkdir -p data
PY=${AISBENCH_UI_PYTHON:-python3}

load_image() {
  local TAR
  TAR=$(ls "$DIR"/docker/aisbench-image-*.tar.gz 2>/dev/null | head -1 || true)
  [ -n "$TAR" ] || { echo "!! 未找到 docker/aisbench-image-*.tar.gz"; return 1; }
  case "$TAR" in *aarch64*) [ "$(uname -m)" = "aarch64" ] || echo "!! 警告: aarch64 镜像用于 $(uname -m) 机器";; esac
  if docker images | grep -q aisbench_benchmark; then echo "镜像已存在，跳过"; return 0; fi
  docker load -i "$TAR"
}

install_deps() {
  python3 -m pip install -q -r backend/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
}

start() {
  if ss -ltn 2>/dev/null | grep -q ":8001"; then echo "!! 8001 已被占用（服务可能已在运行）"; return 0; fi
  nohup $PY run.py > data/server.log 2>&1 &
  sleep 4
  local IP TOKEN
  IP=$(hostname -I 2>/dev/null | awk '{print $1}')
  TOKEN=$(cat data/token.txt 2>/dev/null || true)
  echo "=========================================="
  echo "✅ 服务已启动"
  echo "   浏览器: http://${IP:-127.0.0.1}:8001"
  [ -n "$TOKEN" ] && echo "   Token:  $TOKEN"
  echo "   日志:   data/server.log"
  echo "=========================================="
}

case "${1:-install}" in
  image) load_image ;;
  deps)  install_deps ;;
  start) start ;;
  stop)  pkill -f "run\.py" 2>/dev/null && echo "已停止" || echo "服务未在运行" ;;
  token) cat data/token.txt 2>/dev/null || echo "尚未生成（先 start）" ;;
  install|"")
    echo "== [1/3] 加载内置镜像 =="
    load_image || echo "（跳过镜像加载，docker 模式将不可用）"
    echo "== [2/3] 安装后端依赖 =="
    install_deps
    echo "== [3/3] 就绪检查与启动 =="
    [ -f frontend/dist/index.html ] && echo "前端产物 ✓"
    [ -d aisbench/benchmark/ais_bench ] && echo "aisbench 源码 ✓"
    [ -f datasets/gsm8k/test.jsonl ] && echo "gsm8k 数据集 ✓"
    [ -f backend/static/plotly.min.js ] && echo "plotly.js ✓"
    start
    ;;
  *) echo "未知命令: $1（支持: image/deps/start/stop/token，默认完整安装）"; exit 1 ;;
esac
