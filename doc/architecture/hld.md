# 高层架构设计（HLD）

## 1. 目标与范围
- 明确系统边界、模块划分、数据流、关键非功能目标（性能/可用性/扩展性）。
- 对齐 PRD 的核心能力（编辑器、双向链接、地图、图谱、权限、导出）。

## 2. 架构总览（逻辑）
- 前端（Web SPA）
  - 技术建议：React + TipTap（ProseMirror）编辑器；协作采用 Yjs（CRDT）。
  - 即时协作通道：WebSocket（y-websocket provider）。
  - 富交互：地图（canvas/WebGL）、图谱（force graph）。
- 后端
  - 数据层：Headless CMS（Directus）承载核心实体（World/Element/Relation/Map/Timeline）。
  - 网关服务（自研，可选）：补足业务编排（导出打包、预签名上传、图谱聚合、权限裁剪）。
  - 协作服务：y-websocket（状态轻量）或复用网关统一接入层。
- 存储与基础设施
  - 数据库：PostgreSQL（关系+JSONB 属性）。
  - 对象存储：地图大图、导出 ZIP（S3 兼容）。
  - 缓存：Redis（会话/速率限制/短期文档快照）。
  - 可选：搜索（OpenSearch/Meilisearch）用于元素全文检索。

信任边界
- 浏览器 ↔ API 网关（HTTPS, Bearer JWT）
- API 网关 ↔ Directus（服务间信任 + 细粒度令牌）
- 外链公开访问（只读 Token）

## 3. 关键模块与职责
- 身份与权限
  - 鉴权：Bearer JWT（来自 Directus/OIDC）。
  - 世界级 RBAC：Owner/Editor/Commenter/Viewer；字段/块级可见性（“秘密”标记）。
- 编辑器与链接
  - 内容模型：ProseMirror JSON（持久化）+ 派生 Markdown（导出用）。
  - 链接：@ 提及生成元素间双向链接；(( 块引用基于稳定块ID。
  - 协作：Yjs 文档分片（按元素），冲突自动合并；离线后重连同步。
- 地图（Atlas）
  - 上传：前端直传对象存储（预签名 URL）；限制大小/格式。
  - 图钉：与元素关联；支持嵌套地图（后续迭代）。
- 关系图谱（Constellation）
  - 由 Relation 表生成力导向图；筛选关系类型；节点可导航。
- 导出
  - 触发异步任务；打包 Markdown/HTML/JSON + README；大包生成回调或轮询下载。

## 4. 典型时序（示例）
创建世界
1) 前端 POST /worlds → 网关校验权限 → Directus 插入 → 返回 World
2) 前端更新仪表盘列表

在 A 中 @ 提及 B
1) 输入“@”→ 前端查询 GET /elements?world_id=...&q=...
2) 保存时：编辑器内容（JSON）与链接关系一起提交
3) 后端写 Element 与 Relation；同步触发图谱缓存失效

导出世界
1) POST /worlds/{id}/export → 202 Accepted 返回 job_id
2) 后端生成 ZIP（含 Markdown/HTML/JSON）→ 完成后可下载

## 5. 数据流、缓存与幂等
- 幂等：创建接口支持幂等键（Idempotency-Key）；导出任务使用去重键合并并发请求。
- 缓存：列表与只读详情可短缓存；编辑相关禁缓存或加 ETag。
- 错误码：统一错误响应结构（error.code/message/details/request_id）。

## 6. 非功能需求（NFR）
- 性能：P95 API < 200ms（读），< 500ms（写）；导出大世界 < 2 分钟。
- 可用性：协作与编辑核心 SLO 99.9%；错误预算结合告警。
- 容量：单世界元素 1e5 级；链接密度支撑图谱渲染（前端虚拟化）。
- 安全：世界/字段级权限校验；公开只读链接 Token 化与吊销；速率限制。

## 7. 可部署性与配置
- 环境配置：数据库/对象存储/第三方登录/邮件/队列。
- 特性开关：块引用、公开链接、导出异步任务等按阶段灰度。
- 迁移策略：SQL 迁移脚本与回滚；数据字典与版本号。

## 8. 取舍与替代方案（要点）
- 编辑器底层：ProseMirror（强生态）vs Slate（更轻但插件少）→ 建议 ProseMirror。
- 协作：Yjs（CRDT）vs OT → 建议 Yjs，离线更友好。
- 内容持久化：仅 Markdown vs JSON+Markdown → 选 JSON 主存，导出派生 Markdown。

## 9. 风险与缓解
- 大图/大图谱性能：前端虚拟化、切片/懒加载、服务器端聚合；预研基准。
- 协作冲突与权限穿透：服务端二次校验 + 变更审计；敏感块屏蔽策略。
- Directus 定制边界：超出建模处由网关服务承接，避免核心逻辑散落。

## 10. 待定问题（Open）
- 跨世界引用的策略与治理
- 搜索方案（内置 vs 外部引擎）的里程碑与成本评估
