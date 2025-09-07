# 成功指标与埋点需求

## 目标 KPI（与 PRD 对齐）
- 转化：公开发布后 6 个月内，免费→付费转化率 ≥ 5%
- 激活：新用户单次 15 分钟内完成“创建世界 + 创建 ≥3 个互联元素 + 1 张地图”占比 ≥ X%
- 留存：D7 ≥ Y%，D30 ≥ Z%（待定）

## 北极星与子指标
- 北极星：每位活跃创作者的“有效互联元素数/周”
- 子指标：
  - 编辑器活跃（会话、块编辑次数、/ 与 @ 使用率）
  - 链接密度（每元素入/出链路数）
  - 地图使用（上传成功率、图钉创建率）
  - 导出使用（导出成功率、平均打包耗时）

## 关键事件与属性（埋点）
- world_created {world_id}
- element_created {world_id, element_id, template_id?}
- link_created {world_id, from_id, to_id, type:mention|embed}
- slash_menu_used {command}
- map_uploaded {world_id, size_mb, success}
- pin_created {world_id, element_id}
- graph_viewed {world_id, node_count}
- export_triggered {world_id, format, async}
- onboarding_step_completed {step_id}

## 数据质量与隐私
- 事件 schema 版本化；字段字典；客户端/服务端一致性校验
- PII 最小化；用户同意与退出机制；数据保留与删除策略对齐 `doc/security/privacy.md`
