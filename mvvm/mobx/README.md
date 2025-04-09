# MVVM + MobX 新聞閱讀器

## 專案概述
這是一個使用 MVVM（Model-View-ViewModel）架構和 MobX 狀態管理技術開發的新聞閱讀器應用程式範例。旨在展示如何運用 Flutter 和 MobX 建構一個具備可擴充性與可維護性的行動應用程式。

## 架構特點
- **MVVM (Model-View-ViewModel)**
  - 清晰地分離資料模型（Model）、使用者介面（View）與業務邏輯/狀態（ViewModel）。
  - 提升程式碼的可讀性、可測試性與團隊協作效率。

- **MobX**
  - 一個強大且易於使用的響應式狀態管理函式庫。
  - 利用可觀察物件（Observables）、動作（Actions）和響應（Reactions）實現狀態的自動追蹤與更新。
  - 簡化狀態管理邏輯，使開發者能更專注於業務需求。

## MobX 核心概念

MobX 主要圍繞以下幾個核心概念運作：

- **可觀察狀態 (Observable State)**: 使用 `@observable` 標記您希望 MobX 追蹤的變數（例如類別屬性）。當這些變數的值發生變化時，MobX 會知道。
- **動作 (Actions)**: 使用 `@action` 標記會修改可觀察狀態的方法。將狀態修改邏輯封裝在 Action 中有助於組織程式碼，並且 MobX 可以更有效地批次處理狀態更新。
- **計算值 (Computed Values)**: 使用 `@computed` 標記可以從現有可觀察狀態派生出的新值。計算值會被快取，只有當其依賴的可觀察狀態改變時才會重新計算，有助於效能優化。 (注意：本專案範例未直接使用 `@computed`)
- **響應 (Reactions)**: 這是狀態變化與副作用（例如更新 UI）之間的橋樑。在 Flutter 中，最常用的 Reaction 是 `Observer` Widget，它可以自動監聽其 `build` 方法中使用的可觀察狀態，並在狀態變化時自動重建 Widget。

## 主要功能
- 新聞列表展示
- 新聞詳細內容頁面
- 新增新聞功能（模擬）
- 使用 MobX 進行狀態管理
- 簡單的依賴注入實現

## 技術棧
- Flutter 框架
- MobX (用於狀態管理)
- `mobx_codegen` / `build_runner` (用於程式碼生成)
- Dart 語言

## 專案結構
```
mvvm/mobx/
└── lib/
    ├── main.dart           # 應用程式入口點，初始化依賴
    ├── model/
    │   └── news.dart       # 資料模型 (News)
    ├── service/
    │   └── news_service.dart # 資料服務層 (獲取新聞)
    ├── store/
    │   ├── news_store.dart   # ViewModel/Store (狀態管理)
    │   └── news_store.g.dart # MobX 自動生成的程式碼
    └── view/                 # UI 介面層
        ├── add_news_page.dart
        ├── news_detail_page.dart
        ├── news_list_page.dart
        └── news_reader_app.dart # 應用程式根 Widget
```

## 主要元件說明
- `News`: 定義新聞資料結構的資料模型。
- `NewsService`: 負責提供新聞資料的服務層（目前為模擬數據）。
- `NewsStore`: 作為 ViewModel，使用 MobX 管理應用程式的狀態與業務邏輯。
- `NewsReaderApp`: 應用程式的根 Widget。
- `NewsListPage`: 顯示新聞列表的頁面。
- `NewsDetailPage`: 顯示單則新聞詳細內容的頁面。
- `AddNewsPage`: 用於新增新聞的頁面（目前為模擬操作）。

## 本專案中的 MobX 應用

在這個新聞閱讀器範例中，我們主要在 `NewsStore` (扮演 ViewModel 的角色) 和 `NewsListPage` (View) 中應用了 MobX：

1.  **定義可觀察狀態 (`NewsStore`)**:
    *   `@observable ObservableList<News> newsList = ObservableList<News>();`: 使用 `@observable` 將 `newsList` 標記為可觀察的列表。當列表內容（新增、刪除、修改元素）發生變化時，依賴它的 `Observer` Widget 會收到通知。
    *   `@observable bool isLoading = false;`: 同樣使用 `@observable` 標記 `isLoading` 布林值。當其值從 `false` 變為 `true` 或反之，UI 會相應更新。

2.  **定義修改狀態的動作 (`NewsStore`)**:
    *   `@action Future<void> loadNews() async { ... }`: 這個異步方法被標記為 `@action`。它負責從 `NewsService` 獲取新聞數據，並在過程中修改 `isLoading` 和 `newsList` 這兩個可觀察狀態。將異步操作和狀態修改放在 Action 中是標準做法。
    *   `@action void addNews(News news) { ... }`: 這個同步方法同樣標記為 `@action`，負責將新的新聞添加到 `newsList` 中。

3.  **在 UI 中響應狀態變化 (`NewsListPage`)**:
    *   `NewsListPage` 繼承自 `StatefulObserverWidget` (或在 `build` 方法中使用 `Observer` Widget)。
    *   在其 `build` 方法中，它直接讀取 `widget.newsStore.isLoading` 和 `widget.newsStore.newsList`。
    *   由於 `Observer` 的存在，當 `isLoading` 或 `newsList` 的值（或內容）被 `NewsStore` 中的 `@action` 修改時，`NewsListPage` 的 `build` 方法會自動被觸發，從而更新 UI（例如顯示/隱藏載入指示器，或更新新聞列表）。

這種方式實現了 View 和 ViewModel 之間清晰的單向數據流和響應式更新，使得狀態管理邏輯集中在 Store 中，而 View 只負責展示狀態和觸發動作。

## 程式碼生成
為了簡化 MobX 的使用，專案利用了程式碼生成工具：
- `build_runner`: Dart 的建構工具。
- `mobx_codegen`: MobX 的程式碼生成器。
- 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 可以自動生成必要的樣板程式碼（如 `*.g.dart` 檔案），減少手動編寫的重複工作。

## 依賴注入
採用簡單的構造函數注入方式：
- 在 `main.dart` 中創建 `NewsService` 實例。
- 將 `NewsService` 實例注入到 `NewsStore` 的構造函數中。
- 將 `NewsStore` 實例傳遞給需要它的 Widget（如 `NewsReaderApp`）。
- 這種方式有助於解耦元件，並方便進行單元測試（可以注入模擬的 Service）。

## 如何運行專案
1.  確保已安裝 Flutter 開發環境。
2.  複製此專案儲存庫。
3.  進入 `mvvm/mobx` 目錄：`cd mvvm/mobx`
4.  獲取專案依賴：`flutter pub get`
5.  執行程式碼生成：`flutter pub run build_runner build --delete-conflicting-outputs`
6.  運行應用程式：`flutter run`

## 測試
（目前專案包含基礎的 Widget 測試）
- 執行測試：`flutter test`

## 學習目標
透過此範例，您可以學習：
- 如何在 Flutter 中實踐 MVVM 架構。
- 如何使用 MobX 進行狀態管理。
- 響應式程式設計的基本概念。
- Flutter 應用程式的架構設計原則。

## 貢獻
歡迎透過提交 Pull Requests 或 Issues 來協助改進這個範例專案！
