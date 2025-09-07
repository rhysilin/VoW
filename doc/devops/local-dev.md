# 本地开发环境指南

本指南帮助你在本地一键拉起 Aetherium 的最小可运行环境：Directus、PostgreSQL、MinIO（S3 兼容）与 yjs-websocket。

## 先决条件
- Docker Desktop（含 Docker Compose v2）
- PowerShell 7+（Windows/macOS/Linux 均可）

## 快速开始
1) 初始化并启动
```
pwsh dev/up.ps1
```
首次会自动从 `.env.example` 生成 `.env`。

2) 访问服务
- Directus Admin: `http://localhost:8055`（使用 `.env` 中的 `DIRECTUS_ADMIN_EMAIL`/`DIRECTUS_ADMIN_PASSWORD` 登录）
- MinIO Console: `http://localhost:9001`（Root 用户为 `MINIO_ROOT_USER`/`MINIO_ROOT_PASSWORD`）
- S3 Endpoint: `http://localhost:9000`
- Yjs WebSocket: `ws://localhost:1234`（默认端口，可在 `.env` 中改 `YJS_PORT`）

3) 创建对象存储桶（首次）
- 登录 MinIO Console → Buckets → 新建名为 `.env` 中 `MINIO_BUCKET` 的桶（默认 `aetherium`）
- 权限建议：Private（私有）；Directus 将使用凭据访问

4) Directus 健康检查
- `GET http://localhost:8055/server/health` 应返回 200

## 常用脚本
- 启动：`pwsh dev/up.ps1`
- 停止：`pwsh dev/down.ps1`
- 重置（清理容器与卷）：`pwsh dev/reset.ps1`（加入 `-Yes` 跳过确认）

## 环境变量说明（节选）
- PostgreSQL：`POSTGRES_DB/USER/PASSWORD`
- MinIO：`MINIO_ROOT_USER/MINIO_ROOT_PASSWORD/MINIO_BUCKET`
- Directus：`DIRECTUS_KEY/SECRET`（请改为强随机值）、`ADMIN_EMAIL/PASSWORD`
- Yjs：`YJS_PORT`（默认 1234）

## 目录与端口
- Compose 文件：`dev/docker-compose.yml`
- 暴露端口：Postgres 5432、Directus 8055、MinIO 9000/9001、Yjs 1234

## 常见问题
- 端口被占用：修改 `.env` 中的端口或调整 `docker-compose.yml` 的映射
- Directus 上传报错：检查是否已在 MinIO 创建桶名为 `MINIO_BUCKET` 的 bucket
- 连接失败：确认 Docker 运行中，`pwsh dev/down.ps1` 后再 `pwsh dev/up.ps1` 重试

## 版本固定与可复现
- 已固定主线标签：Directus 使用 `directus/directus:10`，yjs 使用 `ghcr.io/yjs/y-websocket:1`，Postgres 使用 `postgres:15-alpine`。
- MinIO 采用频繁发布的日期版，首次成功启动后建议按 `doc/devops/version-matrix.md` 的步骤使用镜像 digest 进行强固定。
- 详情见：`doc/devops/version-matrix.md`
