# ---------- 前端构建 ----------
FROM node:20-alpine AS fe
WORKDIR /build
COPY frontend/package.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# ---------- 运行时 ----------
FROM python:3.10-slim
RUN pip install --no-cache-dir fastapi "uvicorn[standard]" httpx
WORKDIR /app
COPY backend/ ./backend/
COPY run.py ./
COPY --from=fe /build/dist ./frontend/dist
ENV PYTHONUNBUFFERED=1 AISBENCH_UI_DATA=/app/data AISBENCH_UI_PORT=8001
RUN useradd -m ui && mkdir -p /app/data && chown -R ui /app
USER ui
VOLUME /app/data
EXPOSE 8001
CMD ["python", "run.py"]
