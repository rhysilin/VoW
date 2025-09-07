# 数据模型 / ERD（PostgreSQL）

> 覆盖核心实体、字段、索引与约束；含迁移与数据保留策略。

## 1. 实体与字段
- world
  - id (uuid, pk)
  - name (text, not null)
  - description (text)
  - visibility (enum: private|public, default private)
  - owner_id (uuid, not null)
  - created_at (timestamptz, default now())
  - updated_at (timestamptz)
  - deleted_at (timestamptz, nullable) — 软删除

- element
  - id (uuid, pk)
  - world_id (uuid, fk→world.id, on delete cascade)
  - title (text, not null)
  - content_json (jsonb, not null) — ProseMirror 文档
  - content_md (text) — 导出派生，便于可视化/全文检索
  - properties (jsonb) — 自定义属性表
  - created_at (timestamptz, default now())
  - updated_at (timestamptz)

- relation
  - id (uuid, pk)
  - world_id (uuid, fk→world.id, on delete cascade)
  - from_element (uuid, fk→element.id, on delete cascade)
  - to_element (uuid, fk→element.id, on delete cascade)
  - type (text) — 关系类型（如：knows, located_in...）
  - created_at (timestamptz, default now())

- block_ref
  - id (uuid, pk)
  - element_id (uuid, fk→element.id, on delete cascade)
  - block_id (text, not null, unique within element) — 稳定块ID
  - plaintext (text) — 便于搜索/预览

- map
  - id (uuid, pk)
  - world_id (uuid, fk→world.id, on delete cascade)
  - name (text)
  - image_url (text, not null)
  - image_size_mb (numeric)
  - created_at (timestamptz, default now())

- map_pin
  - id (uuid, pk)
  - map_id (uuid, fk→map.id, on delete cascade)
  - element_id (uuid, fk→element.id)
  - x (numeric) — 归一化 0..1
  - y (numeric) — 归一化 0..1
  - label (text)

- export_job
  - id (uuid, pk)
  - world_id (uuid, fk→world.id)
  - status (enum: pending|running|done|failed)
  - result_url (text)
  - created_at (timestamptz, default now())
  - updated_at (timestamptz)
  - dedup_key (text, unique) — 幂等键

## 2. 索引与唯一性
- element (world_id, title) — 索引
- relation (world_id, from_element, to_element, type) — 唯一约束（去重）
- block_ref (element_id, block_id) — 唯一索引
- map_pin (map_id) — 索引；(map_id, element_id) — 组合索引

## 3. 权限与租户边界
- 世界级隔离：所有 element/relation/map 均以 world_id 隔离。
- 公开只读链接：world.public_token（可选，单向，只读）→ 放在 world 表或独立 share_link 表。

## 4. 迁移与演进
- 采用顺序化 SQL 迁移，命名：VYYYYMMDDHHMM__desc.sql；提供回滚脚本。
- 初始化（V0）：world/element/relation/map/map_pin/export_job；预置枚举与扩展（uuid/pgcrypto）。
- 数据字典与视图：只读视图（eg. v_element_flat）便于 BI/导出。

## 5. 数据保留与匿名化
- 软删除保留周期（例如 30 天）后硬删除；导出包遵守隐私策略。
- 匿名化：示例数据使用假名；日志/追踪中脱敏字段。
