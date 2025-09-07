# 0002 内容存储策略（JSON + Markdown 派生）

## 背景
需支持块引用（稳定块ID）与导出为 Markdown/HTML/JSON，多通道消费。

## 决策
- 主存：content_json（ProseMirror JSON）
- 投影：content_md（派生 Markdown，用于导出/阅读/搜索索引）

## 备选方案
- 仅 Markdown：实现块ID困难，协作合并复杂；
- 仅 JSON：不便于外部消费与版本对比。

## 理由
- JSON 结构化利于块级操作与协作；Markdown 派生满足可携带与生态兼容。

## 影响
- 需要派生流水线（保存后生成 MD）；搜索与导出使用派生内容。
- 版本对比可基于 MD 或基于 JSON 的结构 diff（后续）。

## 后续事项
- 定义派生一致性与重建策略；失败回退与告警。
