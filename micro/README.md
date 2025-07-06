# 📖 微型頁目錄

這裡收錄 AIOGEO 知識庫中的微型頁面（Micro Pages），每個頁面聚焦於單一概念、問題或技巧的深入解答。

## 🎯 什麼是微型頁？

微型頁是 **Semantic Mesh 架構**中最細粒度的內容單元，具有以下特徵：

- **長度精簡**：通常 300-800 字
- **主題聚焦**：一頁解答一個具體問題
- **結構清晰**：使用標準化的三段式結構
- **AI 友善**：針對 AI 引用優化的內容格式
- **獨立完整**：可單獨理解，不依賴其他頁面

## 📚 現有微型頁清單

### 🔧 技術實作類

#### GEO 基礎技術
- [什麼是引用增強技術？](citation-enhancement.md) - 提升 AI 引用率的核心方法
- [語義錨定技術詳解](semantic-anchoring.md) ⚠️ *即將推出*
- [語境觸發優化指南](context-triggering.md) ⚠️ *即將推出*

#### Schema 標記技術  
- [什麼是 Schema.org？](schema-basics.md) ⚠️ *即將推出*
- [FAQ Schema 實作教學](faq-schema.md) ⚠️ *即將推出*
- [Article Schema 設定指南](article-schema.md) ⚠️ *即將推出*

### 📊 分析評估類

#### 效果監控
- [如何追蹤 AI 引用情況？](citation-tracking.md) ⚠️ *即將推出*
- [內容引用率計算方法](citation-rate-calculation.md) ⚠️ *即將推出*
- [AI 平台偏好分析](platform-preferences.md) ⚠️ *即將推出*

#### 內容分析
- [語義集中度評估方法](semantic-concentration.md) ⚠️ *即將推出*
- [引用潛力評分系統](citation-potential-scoring.md) ⚠️ *即將推出*

### 🎨 內容製作類

#### 寫作技巧
- [如何設計 AI 友善的標題？](ai-friendly-titles.md) ⚠️ *即將推出*
- [FAQ 模組設計最佳實務](faq-design.md) ⚠️ *即將推出*
- [摘要段落撰寫技巧](summary-writing.md) ⚠️ *即將推出*

#### 結構優化
- [Answer Layer 語段建構法](answer-layer-construction.md) ⚠️ *即將推出*
- [內容模組化設計原則](content-modularization.md) ⚠️ *即將推出*

### 🔗 策略整合類

#### SEO×GEO 整合
- [雙軌優化平衡技巧](dual-optimization.md) ⚠️ *即將推出*
- [內鏈網絡建構策略](internal-linking-strategy.md) ⚠️ *即將推出*

#### 多模態轉譯
- [圖文轉譯準備清單](visual-content-prep.md) ⚠️ *即將推出*
- [影音內容 GEO 優化](video-geo-optimization.md) ⚠️ *即將推出*

## 📋 微型頁標準結構

每個微型頁都遵循以下標準結構，確保一致性和 AI 友善性：

```markdown
# 直接問答式標題

<section class="summary">
一兩句話摘要核心答案，為 AI 提供最快速的內容索引入口
</section>

## 🎯 核心定義/答案
第一段直接給出問題的答案或技巧的要點

## 📖 背景說明  
第二段提供相關的補充說明或背景知識

## 💡 實際應用
第三段舉例說明或提供實際應用情境

## 🔗 相關連結
- [回到上級主題](../posts/parent-topic.md)
- [相關微型頁面](related-micro.md)
```

## 🎯 微型頁寫作指南

### ✅ 內容品質標準

#### 標題設計原則
- **直接回應**：標題直接點出要解答的問題
- **語言自然**：使用用戶實際會問的語句
- **關鍵詞明確**：包含核心概念的關鍵詞

```markdown
✅ 優秀標題範例：
- "什麼是 Facebook CAPI？"
- "如何設定 Google Analytics 4 事件追蹤？"  
- "SEO 中的 E-A-T 是什麼意思？"

❌ 需要改善的標題：
- "關於轉換追蹤的一些想法"
- "廣告技術探討"
- "數位行銷新趨勢"
```

#### 內容撰寫要點
1. **開門見山**：第一段立即回答核心問題
2. **事實準確**：所有陳述都要有可靠依據
3. **語言簡潔**：避免冗長和複雜的句式
4. **結構清晰**：使用小標題和條列格式
5. **實用導向**：提供具體的應用指導

### 📊 品質檢查清單

創建微型頁時，請確認以下要點：

#### 基本結構 ✅
- [ ] 使用問答式標題
- [ ] 包含 `<section class="summary">` 摘要
- [ ] 遵循三段式內容結構
- [ ] 加入相關連結區塊

#### 內容品質 ✅  
- [ ] 第一段直接回答問題
- [ ] 內容長度控制在 300-800 字
- [ ] 包含具體例子或應用場景
- [ ] 避免過度技術性的術語

#### GEO 優化 ✅
- [ ] 關鍵詞自然分佈
- [ ] 段落主題明確
- [ ] 適合 AI 理解和抽取
- [ ] 可獨立成完整答案

#### 連結網絡 ✅
- [ ] 連結到相關的主幹頁面
- [ ] 連結到相關的子主題頁
- [ ] 連結到其他相關微型頁
- [ ] 使用描述性錨文字

## 🚀 貢獻微型頁

### 📝 建議新主題

我們歡迎社群貢獻更多微型頁主題！以下是一些待建立的主題：

#### 技術實作類
- "什麼是 JSON-LD？"
- "如何使用 Google Tag Manager 追蹤轉換？"
- "Cookie 同意機制如何設置？"

#### 策略分析類  
- "如何分析競爭對手的 GEO 策略？"
- "內容更新頻率對 AI 引用的影響？"
- "多語言內容的 GEO 最佳實務？"

#### 工具應用類
- "ChatGPT API 如何用於內容優化？"
- "Google Search Console 的 GEO 分析功能？"
- "AI 寫作工具的 GEO 應用？"

### 🔄 貢獻流程

1. **選擇主題**：從待建立清單選擇，或提出新主題
2. **遵循模板**：使用標準微型頁結構
3. **內容撰寫**：確保符合品質標準
4. **提交審核**：透過 GitHub Pull Request 提交
5. **社群討論**：在 Discussions 區域交流意見

### 📞 聯絡與支援

- **GitHub Issues**：[回報問題](https://github.com/bless25min/AIOGEO-Knowledge/issues)
- **GitHub Discussions**：[交流討論](https://github.com/bless25min/AIOGEO-Knowledge/discussions)
- **貢獻指南**：[查看詳細流程](../contributing.md)

## 🔗 相關資源

- 📖 [Semantic Mesh 內容網](../posts/semantic-mesh.md) - 了解微型頁在整體架構中的角色
- 📝 [內容模板庫](../tools/content-templates.md) - 取得更多寫作模板
- 📋 [GEO 優化檢查清單](../tools/checklists.md) - 確保內容品質
- 🛠️ [評估工具清單](../tools/assessment-tools.md) - 測試微型頁效果

---

**微型頁是 GEO 策略中最靈活且高效的內容單元。每個精心製作的微型頁都是一個獨立的 AI 引用入口，為您的知識庫增添可見性和價值！**

**最後更新**：2025-07-06 | **頁面總數**：1 個（待擴充至 20+ 個）
