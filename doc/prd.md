# **Aetherium：世界构建平台**

## **产品需求文档 (PRD)**

|     |     |
| --- | --- |
| **版本** | 1.1 |
| **状态** | 修订稿 |
| **作者** | 产品管理 |
| **日期** | 2025-09-07 |
| **保密级别** | 仅限内部使用 |

---

### **文档修订历史**

| 版本  | 日期  | 作者  | 变更内容 |
| --- | --- | --- | --- |
| 1.0 | 2025-09-07 | 产品管理 | 初始正式草案。 |
| 1.1 | 2025-09-07 | 产品管理 | 增加了“世界”作为顶级数据容器的概念；明确了 Directus \+ 前端的整体架构。 |

---

## **1.0 引言**

### **1.1 愿景声明**

打造一个直观、互联且支持协作的世界构建平台，赋能创作者构建鲜活、动态的世界，弥合功能复杂软件与通用笔记应用之间的鸿沟。

### **1.2 问题陈述**

创意作家、游戏主持人及世界构建者目前面临着一个碎片化的工具环境。他们被迫在以下选项中做出选择：

- **高复杂度平台** (如 World Anvil)：提供强大、专业的工具，但存在陡峭的学习曲线、僵化的模板和功能臃肿问题，常常扼杀创造力。1
- **高灵活性平台** (如 Notion, Obsidian)：提供卓越的知识管理能力，但并非为世界构建量身定制，需要用户投入大量精力来配置合适的工作流。4
- 世界设定集/维基工具与手稿写作工具之间缺乏无缝集成，导致数据孤岛和内容一致性错误。6

这导致了充满摩擦、认知负担过重且极易丧失创作动力的工作流程。Aetherium 旨在通过提供一个统一的环境来解决此问题，该环境将专业工具与灵活、直观、互联的框架相结合。

### **1.3 目标与目的**

- **产品目标：** 发布一款最小可行产品 (MVP)，验证以互联、流程为中心的世界构建体验的核心价值主张。
- **商业目标：** 在公开发布后的6个月内，实现5%的免费用户到付费用户的转化率。
- **用户目标：** 使新用户能够在15分钟的单次会话中，创建一个基础世界（≥1个世界，≥3个互联元素，1张地图），并理解产品的核心价值。

### **1.4 指导原则**

1. **流程优于功能 (Flow over Features)：** 优先保证无缝、直观的用户体验，最大限度减少操作摩擦，让创作者进入“心流”状态。我们将抵制导致核心工作流复杂化的功能蔓延。7
2. **创作者主权 (Creator Sovereignty)：** 用户100%拥有其数据的所有权。平台将通过强大、开放格式的导出功能确保数据的便携性，灵感源于 Obsidian 的本地优先理念。4
3. **互联涌现智能 (Intelligence through Interconnection)：** 平台的力量在于数据网络。我们将通过双向链接和块引用等机制，促进涌现式连接的发现，将世界设定集变成创作者的“第二大脑”。6

### **1.5 术语表**

| 术语  | 定义  |
| --- | --- |
| **世界 (World)** | 用户创作的顶级容器。每个“世界”都是一个独立的、自成体系的项目，容纳了与单个虚构宇宙相关的所有“元素”、地图、时间线及其他组件。 |
| **元素 (Element)** | Aetherium 中内容的基本原子单位，**隶属于一个特定的“世界”**。它是一个灵活的、类似数据库条目的对象，代表世界中的任何实体（角色、地点、事件等），由主内容区和一组可自定义的属性构成。 |
| **属性 (Property)** | 附加于“元素”的结构化数据字段（如：文本、数字、日期、关系）。 |
| **图谱 (Graph)** | Aetherium 的底层数据结构，所有“元素”都是其所属“世界”内部互联网络中的节点。 |
| **双向链接 (Bi-Directional Link)** | 两个“元素”之间的链接 (\[\[元素A\]\])，该链接会自动在源页面和目标页面上同时反映出来。 |
| **块引用 (Block Reference)** | 对“元素”内特定段落或内容块的引用，允许其被嵌入（transclusion）到其他位置。 |
| **嵌入 (Transclusion)** | 将一个“元素”中的块嵌入到另一个“元素”中的行为，源块的更改会实时反映在所有嵌入实例中。 |
| **视图 (View)** | 对一组“元素”集合进行可定制化的呈现方式（如：表格、画廊、看板、时间线）。 |
| **阿特拉斯引擎 (Atlas Engine)** | 用于创建和交互地图的核心功能模块。 |
| **柯罗诺斯引擎 (Chronos Engine)** | 用于创建和交互时间线的核心功能模块。 |
| **星宿织网者 (Constellation Weaver)** | 用于程序化生成和可视化关系图谱的核心功能模块。 |

---

## **2.0 用户分析**

### **2.1 目标受众**

主要市场由为叙事或互动娱乐创作虚构世界的个人和团队组成。

### **2.2 用户画像**

| 画像  | 描述  | 目标  | 痛点  |
| --- | --- | --- | --- |
| **P1: 小说架构师** (主要) | 规划和撰写小说或系列作品的作家。 | 为其小说系列构建一个独立的**世界**；在与世界设定集相连的环境中撰写手稿。 | 跨多个文档追踪细节；维持连续性；复杂软件的陡峭学习曲线。1 |
| **P2: 大师级叙事者** (主要) | 创作并主持桌面角色扮演游戏 (TTRPG) 的游戏主持人 (GM)。 | 为其战役创建一个沉浸式的**世界**；高效管理后勤；选择性地向玩家揭示信息。 | 游戏期间在多个应用间切换；意外泄露秘密；准备时间过长。 |
| **P3: 业余编年史家** (次要) | 将世界构建作为一种兴趣爱好。 | 拥有一个私密的**世界**空间进行创作；与其他创作者建立联系。 | 专业工具成本过高；其他平台免费版的隐私性不足 1；被复杂性劝退。 |

### **2.3 用户故事 (史诗级)**

- **作为一名小说架构师，** 我希望为我的奇幻系列创建一个新的**世界**，并在其中使用自定义模板来规范化我的角色和地点条目。
- **作为一名大师级叙事者，** 我希望在我的战役**世界**中，放置一张可交互的地图，其上的图钉能直接链接到地点的详细描述，以便在游戏过程中快速访问信息。
- **作为一名大师级叙事者，** 我希望在与玩家共享的**世界**文档中隐藏某些段落或图片，以便将我的GM笔记和秘密与玩家可见信息保存在同一处。8
- **作为一名业余编年史家，** 我希望有一个功能强大的免费版本，允许我创建一个私密的**世界**，以便我可以在没有压力或财务承诺的情况下进行创作。

---

## **3.0 系统架构与核心概念**

### **3.1 核心数据模型： “世界”与“元素”**

Aetherium 的数据结构具有清晰的层次关系。

- **3.1.1 世界 (World) 容器：** “世界”是最高层级的组织单位。每个用户可以创建一个或多个“世界”。每个“世界”都是一个完全独立的创作空间，包含了构建一个虚构宇宙所需的所有数据。
- **3.1.2 元素 (Element) 原子单位：** 在每个“世界”内部，所有内容都由**元素**构成。“元素”是一个颗粒化的、页面式的对象，包含两个组成部分：
  1. **内容主体：** 由 Aetherium 编辑器（见 FR-1.0）驱动的富文本区域。
  2. **属性：** 一组可自定义的键值对，提供结构化的元数据（例如，状态: 草稿, 阵营: 反抗军联盟, 出生日期: 46 BBY）。这结合了维基的自由形式与数据库的结构化能力。13

### **3.2 核心交互模型：互联图谱**

Aetherium 的架构是一个图状数据库，而非文件夹层级结构。连接是其一等公民。

- **双向链接：** 在元素B中创建 \[\[元素A\]\] 链接时，系统会自动在元素A上创建一个反向链接，显示来自元素B的引用。这包括“无链接提及”功能，系统会识别与元素名称匹配的文本并建议建立正式链接。6
- **块级嵌入 (Transclusion)：** 用户可以引用“元素”内的单个内容块（段落、图片等），使用 ((块ID)) 语法。该块可被嵌入到多个“元素”中。编辑源块会即时更新所有嵌入实例，解决了关键知识（如魔法定律或预言）的“单一事实来源”问题。6

### **3.3 核心呈现模型：“视图” (Views)**

**视图**是对一个“世界”中某组“元素”集合的动态可视化。同一份底层数据可以以多种格式显示而无需复制。此概念深受 Notion 和 Airtable 数据库视图的启发。19

- **支持的视图类型：** 表格、画廊、看板、时间线和列表。
- **功能：** 每个视图都将拥有独立的筛选、排序和分组设置。

### **3.4 技术架构概述**

Aetherium 将采用\*\* headless（无头）架构\*\*。

- **后端 (Backend):** 后端将由 **Directus** 驱动。Directus 将作为内容管理系统 (CMS)，负责处理所有数据模型（世界、元素、用户等）、权限管理，并通过 API 提供数据服务。
- **前端 (Frontend):** 整个用户界面 (UI) 和用户体验 (UX) 将通过一个**定制化的前端应用程序**（例如，使用 React 或 Vue.js 框架）来呈现。所有用户操作，包括内容编辑、可视化工具（地图、时间线、图谱）的交互以及实时协作功能，都将在前端实现。这种架构分离确保了后端数据管理的健壮性和可扩展性，同时赋予了前端在打造流畅、高度互动用户体验方面的最大灵活性。

---

## **4.0 功能需求 (FR)**

### **FR-0.5: 世界管理**

- **FR-0.5.1:** 用户应能够创建一个新的“世界”，并为其指定名称和可选的描述。
- **FR-0.5.2:** 用户的个人仪表盘应能展示其拥有或协作的所有“世界”列表。
- **FR-0.5.3:** “世界”的所有者应能够编辑其元数据（名称、描述、封面图片、公开/私密状态）。
- **FR-0.5.4:** “世界”的所有者应能够删除其“世界”及其包含的所有内容。
- **FR-0.5.5:** 所有内容创作（元素、地图、时间线等）都必须归属于一个特定的“世界”。

### **FR-1.0: Aetherium 编辑器**

- **FR-1.1:** 应为一个基于块的、所见即所得 (WYSIWYG) 的富文本编辑器。
- **FR-1.2:** 应支持标准的 Markdown 格式以保证便携性。4
- **FR-1.3:** 应实现 / 斜杠命令菜单，用于快速插入块和嵌入内容。22
- **FR-1.4:** 应实现 @ 提及命令，用于在**当前世界内**搜索并链接到其他“元素”，从而创建双向链接。23
- **FR-1.5:** 应实现 (( 命令，用于在**当前世界内**搜索并嵌入（transclude）来自其他“元素”的块。24

### **FR-2.0: 元素模板**

- **FR-2.1:** 用户应能够创建并保存在特定“世界”中使用的“元素”模板。
- **FR-2.2:** 平台应提供一套预置的默认模板，涵盖常见的世界构建概念。25
- **FR-2.3:** 用户应能够通过社区中心（见 FR-7.3）分享他们的自定义模板。

### **FR-3.0: 阿特拉斯引擎 (交互式地图)**

- **FR-3.1:** 用户应能够为其“世界”上传高达100MB的地图图片。12
- **FR-3.2:** 应支持图层系统，允许用户在单张地图上创建并切换多个图片图层的可见性。12
- **FR-3.3:** 用户应能够在地图上放置可自定义的图钉，每个图钉链接到一个“元素”。
- **FR-3.4:** 应支持嵌套地图，父地图上的图钉可以链接到另一个地图视图。29

### **FR-4.0: 柯罗诺斯引擎 (时间线)**

- **FR-4.1:** 用户应能够为其“世界”创建多个并列的时间线。21
- **FR-4.2:** 事件（本身也是一种“元素”）应可被放置在时间线上。
- **FR-4.3:** 应支持自定义历法和纪元定义。
- **FR-4.4:** 应提供一个“弧线视图”，可视化特定“元素”的属性在时间线过程中的变化。31

### **FR-5.0: 星宿织网者 (关系图谱)**

- **FR-5.1:** 系统应根据“元素”之间定义的“关系”属性，**程序化地生成**一个可视化的、可交互的、力导向的图谱。32
- **FR-5.2:** 用户应能够根据关系类型筛选图谱显示。
- **FR-5.3:** 图谱上的节点应是可交互的，允许用户点击以导航到对应的“元素”页面。

### **FR-6.0: 画布 (白板)**

- **FR-6.1:** 应提供一个无限、可缩放的画布，用于非结构化的头脑风暴。4
- **FR-6.2:** 用户应能够创建文本便签、添加图片，并从其“世界”中拖放代表“元素”的卡片。
- **FR-6.3:** 用户应能够通过绘制连接线来创建思维导图、流程图或情节图。

### **FR-7.0: 协作与社区**

- **FR-7.1: 实时协作**
  - **FR-7.1.1:** 所有编辑界面应支持实时、同步的多人协作，具有可见的多用户光标。36
- **FR-7.2: 访问控制与权限**
  - **FR-7.2.1:** 应在**世界**级别实施基于角色的权限系统：所有者、编辑者、评论者、查看者。39
  - **FR-7.2.2:** 应实现一个“秘密”系统，允许内容创建者将特定内容块标记为对“查看者”级别的用户隐藏。8
  - **FR-7.2.3:** 用户应能够为其“世界”生成一个公开的、只读的链接。
- **FR-7.3: 社区中心**
  - **FR-7.3.1:** 应设立一个**模板市场**，允许用户发布、分享和下载“元素”模板。25
  - **FR-7.3.2:** 应建立一个带有投票机制的**功能建议看板**。
  - **FR-7.3.3:** 应为高优先级的功能请求设立一个**悬赏计划**。42

### **FR-8.0: 用户引导与激活**

- **FR-8.1:** 引导流程应是交互式的，在要求用户注册前引导他们体验“啊哈！”时刻。45
- **FR-8.2:** 流程将询问用户目标以个性化初始工作区和模板建议。47
- **FR-8.3:** 将使用进度条和清单等游戏化元素引导用户完成初始设置。49

### **FR-9.0: 数据便携性**

- **FR-9.1:** 应提供一个强大的数据导入工具，支持 CSV 和 Markdown 格式。52
- **FR-9.2:** 用户必须能够随时导出其**世界**的全部数据。
- **FR-9.3:** 支持的导出格式应包括 Markdown、HTML 和 JSON，并打包成一个结构化的 ZIP 文件。54

### **FR-10.0: 版本控制**

- **FR-10.1:** 每个“元素”都应有完整、可访问的版本历史记录。
- **FR-10.2:** 版本历史界面应允许用户查看变更时间线，直观比较两个版本之间的差异，并能一键恢复任何以前的版本。56

---

## **5.0 非功能性需求 (NFR)**

| ID  | 类别  | 需求  |
| --- | --- | --- |
| **NFR-1.0** | **性能** |     |
| NFR-1.1 |     | 前端页面加载和编辑器内的交互响应时间必须在200毫秒以内。 |
| NFR-1.2 |     | “星宿织网者”图谱必须在多达10,000个节点的情况下保持渲染和交互性能。59 |
| **NFR-2.0** | **可扩展性** |     |
| NFR-2.1 |     | 后端架构必须支持100,000个并发实时协作用户。 |
| NFR-2.2 |     | 数据库必须被设计为可水平扩展，可能在 PostgreSQL 上使用分片多租户模型。60 |
| NFR-2.3 |     | 后端（Directus）必须经过优化配置，以高效处理“世界”与其大量关联“元素”之间的关系。 |
| **NFR-3.0** | **安全性** |     |
| NFR-3.1 |     | 所有用户数据在静止和传输过程中都必须加密。 |
| NFR-3.2 |     | 权限系统必须经过严格测试，以防止用户或“世界”之间的未经授权的数据访问。 |
| **NFR-4.0** | **可用性** |     |
| NFR-4.1 |     | 用户界面必须简洁、直观，并最大限度地减少认知负荷，遵循“流程优于功能”的原则。 |
| NFR-4.2 |     | 平台必须在现代桌面网页浏览器上具有响应性和功能性。移动端专用UI是MVP之后的目标。 |
| **NFR-5.0** | **数据完整性** |     |
| NFR-5.1 |     | 系统必须保证在并发实时协作会话期间不会丢失数据。 |
| NFR-5.2 |     | 平台的服务条款将明确声明，用户保留其创作的全部知识产权。61 |

---

## **6.0 商业化**

### **6.1 订阅层级**

将采用免费增值 (Freemium) 模型，以最大化用户获取并提供清晰的升级路径。64

| 功能  | 免费版 (业余爱好者) | 专业版 (小说架构师) | 工作室版 (大师级叙事者) |
| --- | --- | --- | --- |
| **价格** | 免费  | 约 $10/月 | 约 $25/用户/月 |
| **私密世界数量** | 1个  | 无限  | 无限  |
| **每个世界的“元素”数量** | 200个上限 | 无限  | 无限  |
| **存储空间** | 1 GB | 10 GB | 每用户 50 GB |
| **核心工具 (编辑器, 地图, 时间线等)** | ✅   | ✅   | ✅   |
| **实时协作** | ❌   | ❌   | ✅   |
| **每个世界的协作者** | 2名查看者 | 5名查看者 | 无限编辑者/查看者 |
| **高级权限与“秘密”功能** | ❌   | ✅   | ✅   |
| **版本历史** | 7天  | 30天 | 无限  |

### **6.2 创作者市场 (后MVP)**

一个旨在构建平台经济的长期愿景。

- **功能：** 专业版和工作室版用户可以将其“世界”的部分或全部内容设置为付费订阅。
- **收入模型：** Aetherium 将通过集成 Stripe 来处理支付，并从创作者的所有收入中抽取一定比例的交易费（例如，10%）。67

---

## **7.0 成功指标 (KPIs)**

- **激活：** 新用户在24小时内完成引导清单并创建其第一个**世界**和3个“元素”的百分比。
- **参与度：** 日活跃用户 (DAU) / 月活跃用户 (MAU) 比率。
- **留存率：** 第7天和第30天用户留存率。
- **转化率：** 免费到付费用户转化率。
- **满意度：** 通过应用内调查收集的净推荐值 (NPS)。

#### **Works cited**

1. World Anvil Review \[2025\]: Everything Need to Know \- Kindlepreneur, accessed September 7, 2025, [https://kindlepreneur.com/world-anvil/](https://kindlepreneur.com/world-anvil/)
2. LegendKeeper vs WorldAnvil : r/worldbuilding \- Reddit, accessed September 7, 2025, [https://www.reddit.com/r/worldbuilding/comments/l0t98o/legendkeeper\_vs\_worldanvil/](https://www.reddit.com/r/worldbuilding/comments/l0t98o/legendkeeper_vs_worldanvil/)
3. Campfire vs. World Anvil: Which is Best for You?, accessed September 7, 2025, [https://www.campfirewriting.com/learn/world-anvil-vs-campfire](https://www.campfirewriting.com/learn/world-anvil-vs-campfire)
4. Worldbuilding with Obsidian \- organisation tips and plugins \- TJ Trewin, accessed September 7, 2025, [https://www.tjtrewin.com/blog/worldbuilding-with-obsidian](https://www.tjtrewin.com/blog/worldbuilding-with-obsidian)
5. Best app for Worldbuilding? \- Reddit, accessed September 7, 2025, [https://www.reddit.com/r/worldbuilding/comments/13h8p6o/best\_app\_for\_worldbuilding/](https://www.reddit.com/r/worldbuilding/comments/13h8p6o/best_app_for_worldbuilding/)
6. Master Obsidian Worldbuilding in 30 Days: Complete Guide, accessed September 7, 2025, [https://obsidiantavern.com/obsidian-worldbuilding/](https://obsidiantavern.com/obsidian-worldbuilding/)
7. FAQ \- Best Worldbuilding App for GMs \- LegendKeeper, accessed September 7, 2025, [https://www.legendkeeper.com/faq/](https://www.legendkeeper.com/faq/)
8. LegendKeeper \- Worldbuilding tool and campaign manager for tabletop RPGs, accessed September 7, 2025, [https://www.legendkeeper.com/](https://www.legendkeeper.com/)
9. Obsidian \- Sharpen your thinking, accessed September 7, 2025, [https://obsidian.md/](https://obsidian.md/)
10. Roam Research – A note taking tool for networked thought., accessed September 7, 2025, [https://roamresearch.com/](https://roamresearch.com/)
11. Campfire Pro vs World Anvil? \- Steam Community, accessed September 7, 2025, [https://steamcommunity.com/app/965480/discussions/0/1648791520851441879/](https://steamcommunity.com/app/965480/discussions/0/1648791520851441879/)
12. Features \- Best Worldbuilding App for GMs | LegendKeeper, accessed September 7, 2025, [https://www.legendkeeper.com/features/](https://www.legendkeeper.com/features/)
13. Guild Membership Pricing \- World Anvil, accessed September 7, 2025, [https://www.worldanvil.com/pricing](https://www.worldanvil.com/pricing)
14. Notion Pricing Plans: Free, Plus, Business, Enterprise, & AI., accessed September 7, 2025, [https://www.notion.com/pricing](https://www.notion.com/pricing)
15. A Beginner's Guide to Roam Research — SitePoint, accessed September 7, 2025, [https://www.sitepoint.com/roam-research-beginners-guide/](https://www.sitepoint.com/roam-research-beginners-guide/)
16. A Thorough Beginner's Guide to Roam Research \- The Sweet Setup, accessed September 7, 2025, [https://thesweetsetup.com/a-thorough-beginners-guide-to-roam-research/](https://thesweetsetup.com/a-thorough-beginners-guide-to-roam-research/)
17. Roaming through contexts with Roam: How I use it \- strategic structures, accessed September 7, 2025, [https://www.strategicstructures.com/?p=2357](https://www.strategicstructures.com/?p=2357)
18. Full, complete Transclusion in block-level referencing \- Feature archive \- Obsidian Forum, accessed September 7, 2025, [https://forum.obsidian.md/t/full-complete-transclusion-in-block-level-referencing/15300](https://forum.obsidian.md/t/full-complete-transclusion-in-block-level-referencing/15300)
19. Notion Database Views: Everything You Need To Know (2024) \- Landmark Labs, accessed September 7, 2025, [https://www.landmarklabs.co/insights/notion-database-views](https://www.landmarklabs.co/insights/notion-database-views)
20. Getting started with Airtable form views, accessed September 7, 2025, [https://support.airtable.com/v1/docs/getting-started-with-airtable-form-views](https://support.airtable.com/v1/docs/getting-started-with-airtable-form-views)
21. What are the differences between legendkeeper vs World anvil ? : r/WorldAnvil \- Reddit, accessed September 7, 2025, [https://www.reddit.com/r/WorldAnvil/comments/13i1a1g/what\_are\_the\_differences\_between\_legendkeeper\_vs/](https://www.reddit.com/r/WorldAnvil/comments/13i1a1g/what_are_the_differences_between_legendkeeper_vs/)
22. Intro to databases – Notion Help Center, accessed September 7, 2025, [https://www.notion.com/help/intro-to-databases](https://www.notion.com/help/intro-to-databases)
23. How to link articles on World Anvil \- YouTube, accessed September 7, 2025, [https://www.youtube.com/watch?v=h1rb8jF09b0](https://www.youtube.com/watch?v=h1rb8jF09b0)
24. A beginner's guide to Roam Research: gettings started in 5 easy steps \- Ness Labs, accessed September 7, 2025, [https://nesslabs.com/roam-research-beginner-guide](https://nesslabs.com/roam-research-beginner-guide)
25. Worldbuilding | Free Craft Template \- Craft Docs, accessed September 7, 2025, [https://www.craft.do/templates/worldbuilding](https://www.craft.do/templates/worldbuilding)
26. Worldbuilding Template: 101 Prompts to Build an Immersive World \- Kindlepreneur, accessed September 7, 2025, [https://kindlepreneur.com/worldbuilding-template/](https://kindlepreneur.com/worldbuilding-template/)
27. World Building Template \- BuildIn.Ai, accessed September 7, 2025, [https://buildin.ai/templates/world-building-template](https://buildin.ai/templates/world-building-template)
28. Legendkeeper vs World Anvil: which worldbuilding tool should you choose?, accessed September 7, 2025, [https://www.legendkeeper.com/world-anvil-alternative/](https://www.legendkeeper.com/world-anvil-alternative/)
29. LegendKeeper or WorldAnvil? Which is best? : r/worldbuilding \- Reddit, accessed September 7, 2025, [https://www.reddit.com/r/worldbuilding/comments/i1yd2g/legendkeeper\_or\_worldanvil\_which\_is\_best/](https://www.reddit.com/r/worldbuilding/comments/i1yd2g/legendkeeper_or_worldanvil_which_is_best/)
30. Custom Book Writing Software for Science Fiction Authors \- Campfire, accessed September 7, 2025, [https://www.campfirewriting.com/write/sci-fi](https://www.campfirewriting.com/write/sci-fi)
31. Campfire: Read, Write, and Publish Books & Bonus Content, accessed September 7, 2025, [https://www.campfirewriting.com/write](https://www.campfirewriting.com/write)
32. Optimizing Performance \- React, accessed September 7, 2025, [https://legacy.reactjs.org/docs/optimizing-performance.html](https://legacy.reactjs.org/docs/optimizing-performance.html)
33. Performance \- React Flow, accessed September 7, 2025, [https://reactflow.dev/learn/advanced-use/performance](https://reactflow.dev/learn/advanced-use/performance)
34. Overview \- React Flow, accessed September 7, 2025, [https://reactflow.dev/learn/layouting/layouting](https://reactflow.dev/learn/layouting/layouting)
35. Obsidian, Genuinely the Best Free Program for WorldBuilding and How to Use it\! \- Reddit, accessed September 7, 2025, [https://www.reddit.com/r/worldbuilding/comments/zwe7gc/obsidian\_genuinely\_the\_best\_free\_program\_for/](https://www.reddit.com/r/worldbuilding/comments/zwe7gc/obsidian_genuinely_the_best_free_program_for/)
36. Real-Time Document Collaboration—System Architecture and Design \- MDPI, accessed September 7, 2025, [https://www.mdpi.com/2076-3417/14/18/8356](https://www.mdpi.com/2076-3417/14/18/8356)
37. javascript \- Real time collaborative editing \- how does it work? \- Stack Overflow, accessed September 7, 2025, [https://stackoverflow.com/questions/5086699/real-time-collaborative-editing-how-does-it-work](https://stackoverflow.com/questions/5086699/real-time-collaborative-editing-how-does-it-work)
38. Real-time Collaboration: architecture – Make WordPress Core, accessed September 7, 2025, [https://make.wordpress.org/core/2023/07/13/real-time-collaboration-architecture/](https://make.wordpress.org/core/2023/07/13/real-time-collaboration-architecture/)
39. Guide to sharing and permissions – Figma Learn \- Help Center, accessed September 7, 2025, [https://help.figma.com/hc/en-us/articles/1500007609322-Guide-to-sharing-and-permissions](https://help.figma.com/hc/en-us/articles/1500007609322-Guide-to-sharing-and-permissions)
40. Sharing & permissions – Notion Help Center, accessed September 7, 2025, [https://www.notion.com/help/sharing-and-permissions](https://www.notion.com/help/sharing-and-permissions)
41. Worldbuilding Template \- Etsy, accessed September 7, 2025, [https://www.etsy.com/market/worldbuilding\_template](https://www.etsy.com/market/worldbuilding_template)
42. Open-source bounty \- Wikipedia, accessed September 7, 2025, [https://en.wikipedia.org/wiki/Open-source\_bounty](https://en.wikipedia.org/wiki/Open-source_bounty)
43. Opire \- the bounty platform for software developers, accessed September 7, 2025, [https://opire.dev/](https://opire.dev/)
44. Contributors Guide \- Hummingbot, accessed September 7, 2025, [https://hummingbot.org/bounties/contributors/](https://hummingbot.org/bounties/contributors/)
45. How Duolingo uses gamification to improve user retention (+ 5 winning tactics) \- StriveCloud, accessed September 7, 2025, [https://strivecloud.io/blog/gamification-examples-boost-user-retention-duolingo/](https://strivecloud.io/blog/gamification-examples-boost-user-retention-duolingo/)
46. How Does Duolingo Onboard Users? \- YouTube, accessed September 7, 2025, [https://www.youtube.com/watch?v=YlxKIi2QgtE](https://www.youtube.com/watch?v=YlxKIi2QgtE)
47. 6 user onboarding best practices \[with examples and video\] \- Appcues, accessed September 7, 2025, [https://www.appcues.com/blog/user-onboarding-best-practices](https://www.appcues.com/blog/user-onboarding-best-practices)
48. User Onboarding Best Practices, Examples, Metrics & Tools \- Userpilot, accessed September 7, 2025, [https://userpilot.com/blog/user-onboarding/](https://userpilot.com/blog/user-onboarding/)
49. 10 Onboarding gamification tools to engage your new hires \- SC Training, accessed September 7, 2025, [https://training.safetyculture.com/blog/onboarding-gamification/](https://training.safetyculture.com/blog/onboarding-gamification/)
50. 11 Onboarding Gamification Examples to Engage & Retain Users, accessed September 7, 2025, [https://userpilot.com/blog/onboarding-gamification/](https://userpilot.com/blog/onboarding-gamification/)
51. UX Gamification for SaaS: How to Boost User Engagement \- Userpilot, accessed September 7, 2025, [https://userpilot.com/blog/gamification-ux/](https://userpilot.com/blog/gamification-ux/)
52. What are the best practices for high volume data import? \- Oracle Help Center, accessed September 7, 2025, [https://docs.oracle.com/en/cloud/saas/sales/fasqa/best-practices-for-high-volume-data-import.html](https://docs.oracle.com/en/cloud/saas/sales/fasqa/best-practices-for-high-volume-data-import.html)
53. 5 Best Practices for Building a CSV Uploader \- OneSchema, accessed September 7, 2025, [https://www.oneschema.co/blog/building-a-csv-uploader](https://www.oneschema.co/blog/building-a-csv-uploader)
54. Community Suggestion: Print out or export of articles \- World Anvil, accessed September 7, 2025, [https://www.worldanvil.com/community/voting/suggestion/20e8c78e-c171-4280-8556-356052d48a35/view](https://www.worldanvil.com/community/voting/suggestion/20e8c78e-c171-4280-8556-356052d48a35/view)
55. Are we moving away from portability? How much is Obsidian locking our notes in?, accessed September 7, 2025, [https://forum.obsidian.md/t/are-we-moving-away-from-portability-how-much-is-obsidian-locking-our-notes-in/19329](https://forum.obsidian.md/t/are-we-moving-away-from-portability-how-much-is-obsidian-locking-our-notes-in/19329)
56. How to use Google Docs Version History \- ZDNET, accessed September 7, 2025, [https://www.zdnet.com/home-and-office/work-life/how-to-use-google-docs-version-history/](https://www.zdnet.com/home-and-office/work-life/how-to-use-google-docs-version-history/)
57. DiffDog Diff/Merge Tool \- Altova, accessed September 7, 2025, [https://www.altova.com/diffdog](https://www.altova.com/diffdog)
58. Compare Files with 'Diff Doc' \- Softinterface, accessed September 7, 2025, [https://www.softinterface.com/MD/Document-Comparison-Software.htm](https://www.softinterface.com/MD/Document-Comparison-Software.htm)
59. Legend Keeper 2022 Overview \[OC\] : r/worldbuilding \- Reddit, accessed September 7, 2025, [https://www.reddit.com/r/worldbuilding/comments/vzxby1/legend\_keeper\_2022\_overview\_oc/](https://www.reddit.com/r/worldbuilding/comments/vzxby1/legend_keeper_2022_overview_oc/)
60. Campfire Writing Review: The 17 Modules Explained \- selfpublishing.com, accessed September 7, 2025, [https://selfpublishing.com/campfire-writing-review/](https://selfpublishing.com/campfire-writing-review/)
61. Copyright | World Anvil, accessed September 7, 2025, [https://www.worldanvil.com/copyright](https://www.worldanvil.com/copyright)
62. Does Medium Own Your Content? \- Stopping Internet Marketing Scams, accessed September 7, 2025, [https://stoppingscams.com/does-medium-own-your-content/](https://stoppingscams.com/does-medium-own-your-content/)
63. Clarifying Medium's new Terms of Service | by Medium | The Medium Blog, accessed September 7, 2025, [https://medium.com/blog/clarifying-mediums-new-terms-of-service-bad566e3f7da](https://medium.com/blog/clarifying-mediums-new-terms-of-service-bad566e3f7da)
64. How to Set Up a SaaS Freemium Model \- PayPro Global, accessed September 7, 2025, [https://payproglobal.com/how-to/set-up-saas-freemium/](https://payproglobal.com/how-to/set-up-saas-freemium/)
65. Freemium: Definition, Best Practices, Benefits and Examples \- Zuora, accessed September 7, 2025, [https://www.zuora.com/glossary/freemium-business-model/](https://www.zuora.com/glossary/freemium-business-model/)
66. Freemium Business Model: benefits, drawbacks, and best practices \- Fincome, accessed September 7, 2025, [https://www.fincome.co/blog/freemium-business-model-benefits-drawbacks-best-practices](https://www.fincome.co/blog/freemium-business-model-benefits-drawbacks-best-practices)
67. Transaction Fee Models \- Meegle, accessed September 7, 2025, [https://www.meegle.com/en\_us/topics/monetization-models/transaction-fee-models](https://www.meegle.com/en_us/topics/monetization-models/transaction-fee-models)
68. Understanding Transaction Fees in Online Marketplaces \- Edge Payments, accessed September 7, 2025, [https://www.tryedge.io/blog/transaction-fees-online-marketplaces](https://www.tryedge.io/blog/transaction-fees-online-marketplaces)
69. Marketplace Fees 2025: Amazon, eBay, Etsy, Walmart Charges Explained \- Webgility, accessed September 7, 2025, [https://www.webgility.com/blog/marketplace-fees-amazon-ebay-etsy-walmart](https://www.webgility.com/blog/marketplace-fees-amazon-ebay-etsy-walmart)

---

## 相关设计与工程文档

- 文档索引：`doc/README.md`
- 用户故事与验收标准：`doc/product/user-stories.md`
- 用户流程与信息架构：`doc/design/flows.md`
- 线框稿目录：`doc/design/wireframes/`
- 高层架构（HLD）：`doc/architecture/hld.md`
- 数据模型/ERD：`doc/architecture/erd.md`
- API 契约（OpenAPI）：`doc/api/openapi.yaml`
- 测试计划：`doc/quality/test-plan.md`
- 测试用例：`doc/quality/test-cases.md`
- CI/CD：`doc/devops/cicd.md`
- 部署运行手册：`doc/devops/deploy-runbook.md`
- 可观测性方案：`doc/devops/observability.md`
- 威胁建模：`doc/security/threat-model.md`
- 隐私与合规：`doc/security/privacy.md`
- 路线图：`doc/project/roadmap.md`
- 风险登记册：`doc/project/risk-register.md`
- RACI：`doc/project/raci.md`
