# 可观测性方案

## 日志
- 结构化日志：字段包含 `ts, level, msg, request_id, user_id?, world_id?`
- 敏感信息脱敏（PII/Token）；关键写路径设置审计日志类目

## 指标（业务 + 系统）
- 业务：
  - world_created_total, element_created_total
  - link_created_total{type=mention|embed}
  - export_duration_seconds_bucket（直方图）
- 系统：
  - http_request_duration_seconds（按 path/method/2xx/4xx/5xx）
  - yjs_ws_connections{state=open|closed}
  - db_query_duration_seconds, object_storage_errors_total

## 追踪
- Trace 关键链路：创建世界、保存元素、触发导出
- Span 约定：网关、Directus、DB、对象存储；propagate request_id

## 告警与仪表盘（示例）
- 告警：
  - 5xx 比例 > 1% 持续 5 分钟
  - 导出任务失败率 > 5%
  - 协作 WS 异常断开激增
- 仪表盘：
  - 核心 API 延迟/错误、创建/链接/导出趋势、WS 连接数

## 埋点映射
- 参考 `doc/product/metrics.md` 的事件定义，将事件→指标/日志/追踪映射清单化
