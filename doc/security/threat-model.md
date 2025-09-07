# 威胁建模（STRIDE/数据流图）

## 1. 范围与资产
- 用户账号、访问令牌（JWT、公开只读 Token）
- 世界/元素/关系/块引用数据，导出 ZIP 包
- 地图资源（大图）与图钉数据

## 2. 数据流与信任边界（DFD 描述）
- Client(SPA) → API（Gateway/Directus）→ DB/对象存储
- 协作：Client ↔ y-websocket（文档增量）
- 公开只读：匿名 Client → API（Share Token）→ 只读投影

信任边界：浏览器/互联网、API、服务间通信、公开匿名访问

## 3. STRIDE 分析与缓解
- 伪造（Spoofing）
  - Bearer JWT 验证、短时效 + 刷新；y-websocket 鉴权；公开链接独立 Token
- 篡改（Tampering）
  - 服务端权限二次校验；乐观并发控制（ETag/版本号）；审计日志
- 抗抵赖（Repudiation）
  - 变更审计（谁/何时/何物）；导出任务留档；请求 request_id 贯通日志
- 信息泄露（Information Disclosure）
  - 世界级 RBAC；“秘密”块在只读/低权限路径剔除；导出脱敏与清单
- 拒绝服务（DoS）
  - 速率限制/配额；上传大小/类型限制；协作通道限并发/心跳踢出
- 权限提升（Elevation of Privilege）
  - 后端基于世界与角色的精确校验；公有分享仅暴露只读投影；最小权限访问令牌

## 4. 公有分享与秘密块
- 分享链接：world.public_token（或 share_link 表），权限=只读，可撤销/轮换
- 秘密块：块级可见性标记，后端渲染/筛选时剔除；索引与导出需同时过滤

## 5. 密钥与配置
- 秘钥管理：分环境隔离，定期轮换；只读链接 Token 长度≥128-bit 熵
- 供应链安全：依赖锁定、SCA 扫描、构建产物签名（可选）

## 6. 合规与数据保留
- 数据最小化；保留与删除与 `doc/security/privacy.md` 对齐
- 导出包生命周期与访问控制（限时下载、一次性链接）
