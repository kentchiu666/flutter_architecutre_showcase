# MVVM + Riverpod 新聞閱讀器

## 專案概述
這是一個使用 MVVM（Model-View-ViewModel）架構和 Riverpod 狀態管理與依賴注入框架開發的新聞閱讀器應用程式範例。旨在展示如何運用 Flutter 和 Riverpod 建構一個現代化、可擴充且可維護的行動應用程式。

## 架構特點
- **MVVM (Model-View-ViewModel)**
  - 清晰地分離資料模型（Model）、使用者介面（View）與業務邏輯/狀態（ViewModel，此處由 Riverpod Notifier 承擔）。
  - 提升程式碼的可讀性、可測試性與團隊協作效率。

- **Riverpod**
  - 一個功能強大、類型安全、編譯時安全的 Flutter 狀態管理和依賴注入解決方案。
  - 提供多種 Provider 類型以適應不同場景，實現響應式和宣告式的狀態管理。
  - 使依賴注入和狀態管理更加直觀和易於測試。

## Riverpod 核心概念

Riverpod 主要圍繞 Provider 的概念運作：

- **Provider**: 最基礎的 Provider，用於提供唯讀值或服務實例（例如 `NewsService`）。它會被快取，只有在需要時才創建實例。
- **StateProvider**: 提供一個簡單的可變狀態值（例如計數器、布林值）。不建議用於複雜狀態。
- **StateNotifier / StateNotifierProvider**: 用於管理更複雜、不可變的狀態物件。`StateNotifier` 是一個持有單一 `state` 屬性的類別，其狀態改變時會通知監聽者。`StateNotifierProvider` 用於創建和提供 `StateNotifier` 的實例。這是管理 ViewModel 狀態的常用方式。
- **FutureProvider**: 用於處理異步操作（如網路請求）並提供其結果 (`AsyncValue`)。它會自動處理加載、數據和錯誤狀態。
- **StreamProvider**: 類似 `FutureProvider`，但用於處理 Stream 的結果。
- **ConsumerWidget / ConsumerStatefulWidget**: Riverpod 提供的 Widget 類型，其 `build` 方法會接收一個 `WidgetRef` 物件。
- **WidgetRef**: 在 `ConsumerWidget` 或 `ConsumerStatefulWidget` 的 `build` 方法中可用，用於與 Provider 交互：
    - `ref.watch(provider)`: 監聽 Provider 的狀態變化。當狀態改變時，會觸發 Widget 重建。
    - `ref.read(provider)`: 只讀取 Provider 的當前值或實例，不進行監聽。通常用於按鈕回調等一次性讀取場景。
    - `ref.listen(provider, listener)`: 監聽 Provider 的狀態變化並執行副作用（如導航、顯示 SnackBar）。
- **ProviderScope**: 必須放置在應用程式根部的 Widget，用於儲存所有 Provider 的狀態。

## 主要功能
- 新聞列表展示
- 新聞詳細內容頁面
- 新增新聞功能（模擬）
- 使用 Riverpod 進行狀態管理和依賴注入

## 技術棧
- Flutter 框架
- Riverpod / flutter_riverpod (用於狀態管理和依賴注入)
- Dart 語言

## 專案結構
```
mvvm/riverpod/
└── lib/
    ├── main.dart           # 應用程式入口點，包含 ProviderScope
    ├── model/
    │   └── news.dart       # 資料模型 (News)
    ├── services/
    │   └── news_service.dart # 資料服務層 (獲取新聞)
    ├── viewmodel/          # ViewModel 層 (Notifier & State)
    │   ├── news_notifier.dart # StateNotifier 核心邏輯
    │   └── news_state.dart    # 狀態定義
    ├── providers.dart        # 定義 Riverpod Providers
    └── view/                 # UI 介面層
        ├── add_news_page.dart
        ├── news_detail_page.dart
        ├── news_list_page.dart
        └── news_reader_app.dart # 應用程式根 Widget
```

## 主要元件說明
- `News`: 定義新聞資料結構的資料模型。
- `NewsService`: 負責提供新聞資料的服務層（目前為模擬數據）。
- `NewsState`: 定義了新聞列表頁面的狀態（包含 `isLoading`, `newsList`, `errorMessage`）。
- `NewsNotifier`: 作為 ViewModel，繼承自 `StateNotifier<NewsState>`，負責調用 `NewsService` 並更新 `NewsState`。
- `newsServiceProvider`: 一個 `Provider`，用於創建和提供 `NewsService` 的單例。
- `newsNotifierProvider`: 一個 `StateNotifierProvider`，用於創建和提供 `NewsNotifier` 及其管理的 `NewsState`。
- `NewsReaderApp`: 應用程式的根 Widget (`MaterialApp`)。
- `NewsListPage`: 顯示新聞列表的頁面 (`ConsumerStatefulWidget`)，使用 `ref.watch` 監聽 `newsNotifierProvider` 的狀態。
- `NewsDetailPage`: 顯示單則新聞詳細內容的頁面 (`StatelessWidget`)。
- `AddNewsPage`: 用於新增新聞的頁面 (`ConsumerStatefulWidget`)，使用 `ref.read` 獲取 `NewsNotifier` 並調用 `addNews` 方法。

## 本專案中的 Riverpod 應用

在這個新聞閱讀器範例中，我們這樣應用 Riverpod：

1.  **定義 Provider (`providers.dart`)**:
    *   `newsServiceProvider = Provider<NewsService>((ref) => NewsService());`: 提供 `NewsService` 實例。
    *   `newsNotifierProvider = StateNotifierProvider<NewsNotifier, NewsState>((ref) { ... });`: 創建 `NewsNotifier`，並通過 `ref.watch(newsServiceProvider)` 將 `NewsService` 注入。

2.  **實現 Notifier 和 State (`news_notifier.dart`, `news_state.dart`)**:
    *   `NewsState` 是一個不可變類別，包含 `isLoading`, `newsList`, `errorMessage` 屬性，以及 `copyWith` 方法。
    *   `NewsNotifier` 繼承 `StateNotifier<NewsState>`，接收 `NewsService`。
    *   `loadNews` 方法：設置 `state` 為加載中 -> 調用 `_newsService.fetchNews()` -> 成功則更新 `state` 為包含新聞列表，失敗則更新 `state` 為包含錯誤訊息。
    *   `addNews` 方法：創建包含新新聞的列表，並更新 `state`。

3.  **提供 ProviderScope (`main.dart`)**:
    *   在 `runApp` 的最外層使用 `ProviderScope` 包裹 `NewsReaderApp`。

4.  **在 UI 中讀取/監聽 Provider (`NewsListPage`, `AddNewsPage`)**:
    *   將需要與 Riverpod 交互的 Widget 改為 `ConsumerWidget` 或 `ConsumerStatefulWidget`。
    *   `NewsListPage` (`ConsumerStatefulWidget`):
        *   在 `initState` 中使用 `ref.read(newsNotifierProvider.notifier).loadNews()` 觸發初始加載。
        *   在 `build` 方法中使用 `ref.watch(newsNotifierProvider)` 獲取 `NewsState` 並監聽變化。
        *   根據 `newsState.isLoading`, `newsState.errorMessage`, `newsState.newsList` 來渲染 UI。
    *   `AddNewsPage` (`ConsumerStatefulWidget`):
        *   在按鈕回調中使用 `ref.read(newsNotifierProvider.notifier).addNews(newNews)` 來調用 Notifier 的方法。

這種方式利用 Riverpod 同時處理了依賴注入（`NewsService` -> `NewsNotifier`）和狀態管理，並通過 `ref.watch` 和 `ref.read` 實現了 UI 與狀態的解耦和響應式更新。

## 如何運行專案
1.  確保已安裝 Flutter 開發環境。
2.  複製此專案儲存庫。
3.  進入 `mvvm/riverpod` 目錄：`cd mvvm/riverpod`
4.  獲取專案依賴：`flutter pub get`
5.  運行應用程式：`flutter run` (或使用 VS Code 的 "MVVM Riverpod" 運行配置)

## 測試
（注意：目前專案僅包含 Flutter 自動生成的基礎 Widget 測試 (`test/widget_test.dart`)。若要進行更完整的測試，可以使用 `riverpod` 提供的測試工具（如 `ProviderContainer`）和 `mocktail` 等工具模擬 Service 來進行 Notifier 的單元測試，並擴充 Widget 測試。）
- 執行現有測試：`flutter test`

## 學習目標
透過此範例，您可以學習：
- 如何在 Flutter 中實踐 MVVM 架構。
- 如何使用 Riverpod 進行狀態管理和依賴注入。
- 不同 Provider 類型的使用場景。
- Flutter 應用程式的架構設計原則。

## 貢獻
歡迎透過提交 Pull Requests 或 Issues 來協助改進這個範例專案！
