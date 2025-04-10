# MVVM + Provider 新聞閱讀器

## 專案概述
這是一個使用 MVVM（Model-View-ViewModel）架構和 Provider 狀態管理框架開發的新聞閱讀器應用程式範例。旨在展示如何運用 Flutter 和 Provider 建構一個可擴充、可維護的行動應用程式。

## 架構特點
- **MVVM (Model-View-ViewModel)**
  - 清晰地分離資料模型（Model）、使用者介面（View）與業務邏輯/狀態（ViewModel）。
  - 提升程式碼的可讀性、可測試性與團隊協作效率。

- **Provider**
  - Flutter 官方推薦的狀態管理解決方案之一，易於學習和使用。
  - 利用 `ChangeNotifier` 和 `ChangeNotifierProvider` 實現狀態的監聽與更新。
  - 也提供了依賴注入的功能（雖然本專案使用 GetIt 輔助）。

## Provider 核心概念

Provider 套件主要圍繞以下幾個核心概念運作：

- **ChangeNotifier**: 一個簡單的類別，混入 (mixin) 到你的狀態管理類別（ViewModel）中。當狀態改變時，調用 `notifyListeners()` 方法來通知所有監聽者。
- **ChangeNotifierProvider**: 一個 Provider Widget，用於創建和提供 `ChangeNotifier` 的實例（例如 `NewsViewModel`）給其子 Widget。當 Widget 不再需要時，它會自動調用 `ChangeNotifier` 的 `dispose()` 方法。
- **Provider**: 最基礎的 Provider Widget，用於提供任何類型的唯讀值或服務實例。
- **MultiProvider**: 一個方便的 Widget，用於同時提供多個 Provider。
- **Consumer**: 一個 Widget，用於在其子樹中獲取 Provider 提供的值並根據變化重建 UI，避免不必要的父 Widget 重建。
- **context.watch<T>()**: 在 `build` 方法中獲取類型為 `T` 的 Provider 提供的值，並**監聽**其變化。當值改變時，會觸發使用 `watch` 的 Widget 重建。
- **context.read<T>()**: 獲取類型為 `T` 的 Provider 提供的值，但**不監聽**其變化。通常用於按鈕回調等只需要讀取一次值的場景。
- **context.select<T, R>(R Function(T value))**: 監聽 Provider `T` 的一部分 `R`。只有當選定的值 `R` 改變時，才會觸發 Widget 重建，用於更精細的效能優化。

## 主要功能
- 新聞列表展示
- 新聞詳細內容頁面
- 新增新聞功能（模擬）
- 使用 Provider 進行狀態管理
- 使用 GetIt 進行服務的依賴注入

## 技術棧
- Flutter 框架
- Provider (用於狀態管理)
- GetIt (用於服務定位/依賴注入)
- Dart 語言

## 專案結構
```
mvvm/provider/
└── lib/
    ├── main.dart           # 應用程式入口點，初始化 GetIt
    ├── model/
    │   └── news.dart       # 資料模型 (News)
    ├── services/
    │   └── news_service.dart # 資料服務層 (獲取新聞)
    ├── viewmodel/          # ViewModel 層
    │   └── news_view_model.dart # ChangeNotifier ViewModel
    └── view/                 # UI 介面層
        ├── add_news_page.dart
        ├── news_detail_page.dart
        ├── news_list_page.dart   # 使用 ChangeNotifierProvider 提供 ViewModel
        └── news_reader_app.dart  # 應用程式根 Widget
```

## 主要元件說明
- `News`: 定義新聞資料結構的資料模型。
- `NewsService`: 負責提供新聞資料的服務層（目前為模擬數據）。
- `NewsViewModel`: 作為 ViewModel，混入 `ChangeNotifier`，負責管理 UI 狀態（`isLoading`, `newsList`, `errorMessage`）並調用 `NewsService`。
- `NewsReaderApp`: 應用程式的根 Widget (`MaterialApp`)。
- `NewsListPage`: 顯示新聞列表的頁面 (`StatelessWidget`)，內部使用 `ChangeNotifierProvider` 創建 `NewsViewModel`，並使用 `Consumer` 或 `context.watch` 監聽狀態。
- `NewsDetailPage`: 顯示單則新聞詳細內容的頁面 (`StatelessWidget`)。
- `AddNewsPage`: 用於新增新聞的頁面 (`StatefulWidget`)，使用 `context.read` 獲取 `NewsViewModel` 並調用 `addNews` 方法。

## 本專案中的 Provider 應用

在這個新聞閱讀器範例中，我們這樣應用 Provider 模式：

1.  **實現 ViewModel (`news_view_model.dart`)**:
    *   `NewsViewModel` 混入 `ChangeNotifier`。
    *   定義私有狀態變數 (`_isLoading`, `_newsList`, `_errorMessage`) 和公開的 getter。
    *   `loadNews` 方法：更新 `_isLoading`，調用 `notifyListeners()`；調用 `_newsService.fetchNews()`；更新 `_newsList` 或 `_errorMessage`；更新 `_isLoading`，再次調用 `notifyListeners()`。
    *   `addNews` 方法：修改 `_newsList`，調用 `notifyListeners()`。

2.  **提供 ViewModel (`NewsListPage`)**:
    *   在 `NewsListPage` 的 `build` 方法中，使用 `ChangeNotifierProvider` 包裹 `Scaffold`。
    *   `create` 回調函數創建 `NewsViewModel` 實例，並從 `GetIt` 獲取 `NewsService` 注入。
    *   在創建 ViewModel 後立即調用 `loadNews()` (`..loadNews()`) 以觸發初始數據加載。

3.  **在 UI 中響應狀態 (`NewsListPage`)**:
    *   在 `ChangeNotifierProvider` 的子 Widget 中，使用 `Consumer<NewsViewModel>` 或 `context.watch<NewsViewModel>()` 來獲取 `viewModel` 實例並監聽狀態變化。
    *   根據 `viewModel.isLoading`, `viewModel.errorMessage`, `viewModel.newsList` 來渲染不同的 UI。

4.  **在 UI 中觸發動作 (`AddNewsPage`)**:
    *   在 `AddNewsPage` 的按鈕回調中，使用 `context.read<NewsViewModel>().addNews(newNews)` 來調用 ViewModel 的方法。這裡使用 `read` 是因為我們只需要觸發動作，不需要監聽狀態變化。
    *   **注意**: 為了讓 `AddNewsPage` 能訪問到 `NewsListPage` 創建的 `NewsViewModel`，`ChangeNotifierProvider` 需要放在它們共同的父級 Widget 上（例如 `NewsReaderApp` 或 `main.dart` 中的 `MultiProvider`）。目前的實作（Provider 在 `NewsListPage`）會導致 `AddNewsPage` 無法直接 `read` 到同一個 ViewModel 實例。更常見的做法是在 `main.dart` 中使用 `MultiProvider` 提供共享的 ViewModel。但為了保持範例簡單，我們暫時維持現狀，並在 `AddNewsPage` 的註解中說明了這個問題。

## 依賴注入
本專案使用 `get_it` 套件進行服務的依賴注入：
- 在 `main.dart` 中定義 `setupLocator` 函數，使用 `getIt.registerSingleton<NewsService>(NewsService())` 註冊 `NewsService`。
- 在 `main` 函數中調用 `setupLocator()`。
- 在創建 `NewsViewModel` 時，使用 `GetIt.instance<NewsService>()` 或 `getIt<NewsService>()` 來獲取 `NewsService` 的實例。

## 如何運行專案
1.  確保已安裝 Flutter 開發環境。
2.  複製此專案儲存庫。
3.  進入 `mvvm/provider` 目錄：`cd mvvm/provider`
4.  獲取專案依賴：`flutter pub get`
5.  運行應用程式：`flutter run` (或使用 VS Code 的 "MVVM Provider" 運行配置)

## 測試
（注意：目前專案僅包含 Flutter 自動生成的基礎 Widget 測試 (`test/widget_test.dart`)。若要進行更完整的測試，可以使用 `mockito` 或 `mocktail` 等工具模擬 Service 來進行 ViewModel 的單元測試，並擴充 Widget 測試。）
- 執行現有測試：`flutter test`

## 學習目標
透過此範例，您可以學習：
- 如何在 Flutter 中實踐 MVVM 架構。
- 如何使用 Provider 和 `ChangeNotifier` 進行狀態管理。
- 如何結合 GetIt 或 Provider 進行依賴注入。
- Flutter 應用程式的架構設計原則。

## 貢獻
歡迎透過提交 Pull Requests 或 Issues 來協助改進這個範例專案！
