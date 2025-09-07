# 版本矩阵与固定策略

- 知识截止：2024-10（我的训练知识到该时间点）。
- 原则：固定到在 2024-10 之前已稳定/广泛使用的主线版本；尽量使用“主线/LTS 的主次版本”标签，避免意外破坏；首个成功拉起后再通过镜像 digest 进行强固定。

## 建议版本（我可明确支持）
- Docker Compose：v2（Docker Desktop 自带的 Compose v2 即可）
- PowerShell：7.4+
- Node.js：20.x LTS（用于前端/网关，若需要）
- PostgreSQL：15.x（稳定且企业常用）
- Directus：10.x（Directus 10 系列）
- MinIO：2024 年中发布的 RELEASE 系列（日期型版本）
- y-websocket（Yjs 协作服务）：1.5.x 系列
- 可选：Redis 7.x（速率限制/缓存/队列等）

## Compose 标签建议
- postgres：`postgres:15-alpine`（已在 `dev/docker-compose.yml` 使用）
- directus：`directus/directus:10`（建议从 `latest` 改为 `10` 主线）
- minio：使用具体 `RELEASE.YYYY-MM-DDThh-mm-ssZ` 标签或先用 `latest`，首个成功启动后改为镜像 digest 固定
- yjs-websocket：若存在稳定主线标签（如 `1` 或 `1.5`）则用之；否则临时 `latest`，随后以 digest 固定

## 固定到镜像 digest（推荐）
1. 首次在本地拉起成功后执行：
   - `docker compose images` 查看各镜像版本
   - `docker images --digests <image>` 获取对应 digest（`@sha256:...`）
2. 将 `dev/docker-compose.yml` 中的镜像改为带 digest 的形式（示例）：
   - `directus/directus@sha256:<digest>`
   - `minio/minio@sha256:<digest>`

## 为什么不直接写死具体补丁号/日期版
- MinIO 使用日期版本，且更新频繁；Directus 与 yjs-websocket 也有多次修补；在无联网的前提下很难准确给出当时“最新 patch 号”。
- 采用“主线标签 + digest 固定”的两步法，既保证兼容易用，又能在可联网时确保完全可重现。

## 下一步
- 若你同意，我可以：
  1) 将 `directus` 镜像从 `latest` 固定为 `10` 主线；
  2) 视 yjs 镜像是否存在 `1` 主线标签进行同样处理；
  3) 在 `doc/devops/local-dev.md` 中加入 digest 固定的操作清单（已在此文档给出）。
