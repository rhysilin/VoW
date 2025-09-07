# Worldloom 技术栈概览

## 1. 最终技术栈
- **后端**：Directus + PostgreSQL，自托管的开源组合，承担数据建模、权限管理与 API 服务。
- **前端**：Next.js（React）构建的 SPA/SSR 应用，负责界面交互与路由。
- **实时协作**：Directus Realtime(WebSocket) 提供多人同步编辑能力。
- **文件存储**：Directus Files 配合 MinIO 等 S3 兼容开源方案。
- **地图**：Leaflet 搭配 OpenStreetMap 瓦片数据。
- **关系图谱**：Cytoscape.js 渲染元素之间的关联网络。
- **时间线**：Vis.js 展示历史事件与时间轴。
- **开发工具链**：Node.js、pnpm、ESLint、Prettier 等开源工具。

## 2. 数据结构与模块
| 实体 | 描述 |
| ---- | ---- |
| `elements` | 世界构建的原子单元，包含标题、内容、类型等字段。|
| `properties` | 元素的自定义属性，支持多种字段类型。|
| `relationships` | 元素间的双向关联。|
| `maps` / `pins` | 地图与坐标点，实现阿特拉斯功能。|
| `timelines` / `events` | 时间线与事件记录。|

## 3. 部署与运维
- 使用 Docker Compose 管理 Directus、PostgreSQL 与前端服务。
- 前端静态资源由 Nginx 等开源 Web 服务器托管。
- 通过 Directus CLI 管理 schema 迁移与初始数据。

## 4. 开发流程建议
1. 在 Directus 中建立核心集合与关系。
2. 搭建前端鉴权与基础布局，接入 Directus REST/GraphQL API。
3. 迭代实现地图、时间线、关系网等可视化模块。
4. 引入实时协作、版本控制与导入导出等高级功能。
