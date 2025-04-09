# MVVM + BLoC 新聞閱讀器

## 專案概述
這是一個使用 MVVM（Model-View-ViewModel）架構和 BLoC (Business Logic Component) 狀態管理模式開發的新聞閱讀器應用程式範例。旨在展示如何運用 Flutter 和 BLoC 建構一個具備可擴充性與可維護性的行動應用程式。

## 架構特點
- **MVVM (Model-View-ViewModel)**
  - 清晰地分離資料模型（Model）、使用者介面（View）與業務邏輯/狀態（ViewModel，此處由 BLoC 承擔）。
  - 提升程式碼的可讀性、可測試性與團隊協作效率。

- **BLoC (Business Logic Component)**
  - 一個可預測的狀態管理函式庫，透過事件 (Events) 觸發狀態 (States) 的轉變。
  - 將業務邏輯從 UI 中分離出來，提高可測試性。
  - 強調單向數據流，使狀態變化更易於追蹤和理解。

## BLoC 核心概念

BLoC 模式主要包含以下幾個核心概念：

- **事件 (Events)**: 代表使用者互動或應用程式內部觸發的動作（例如按鈕點擊、頁面加載）。事件被發送到 BLoC 進行處理。它們通常是繼承自一個基礎事件類別的簡單類別。
- **狀態 (States)**: 代表應用程式在某個時間點的狀況（例如載入中、載入成功、載入失敗）。UI 會根據不同的狀態來渲染對應的介面。狀態通常是不可變的 (immutable) 物件。
- **流 (Streams)**: BLoC 內部使用 Dart 的 Streams 來處理事件的傳入和狀態的傳出。`flutter_bloc` 套件封裝了這些細節。
- **Bloc 類別**: 這是核心元件，它接收事件，執行業務邏輯（可能與 Service 交互），並根據結果發出 (emit) 新的狀態。它通常繼承自 `Bloc<Event, State>`。
- **BlocProvider**: `flutter_bloc` 提供的 Widget，用於在 Widget 樹中創建和提供 BLoC 實例，使其子 Widget 可以訪問。
- **BlocBuilder / BlocListener / BlocConsumer**: `flutter_bloc` 提供的 Widgets，用於在 UI 層響應 BLoC 的狀態變化。`BlocBuilder` 根據狀態重建 UI，`BlocListener` 用於處理一次性的副作用（如導航、顯示 SnackBar），`BlocConsumer` 結合了兩者的功能。

## 主要功能
- 新聞列表展示
- 新聞詳細內容頁面
- 新增新聞功能（模擬）
- 使用 BLoC 進行狀態管理
- 使用 GetIt 進行依賴注入

## 技術棧
- Flutter 框架
- BLoC / flutter_bloc (用於狀態管理)
- Equatable (用於簡化狀態和事件比較)
- GetIt (用於依賴注入)
- Dart 語言

## 專案結構
```
mvvm/bloc/
└── lib/
    ├── main.dart           # 應用程式入口點，初始化依賴和 BlocProvider
    ├── model/
    │   └── news.dart       # 資料模型 (News)
    ├── services/           # 注意: 目錄名是 services (複數)
    │   └── news_service.dart # 資料服務層 (獲取新聞)
    ├── viewmodel/          # ViewModel 層 (BLoC)
    │   ├── news_bloc.dart  # BLoC 核心邏輯
    │   ├── news_event.dart # BLoC 事件定義
    │   └── news_state.dart # BLoC 狀態定義
    └── view/                 # UI 介面層
        ├── add_news_page.dart
        ├── news_detail_page.dart
        ├── news_list_page.dart
        └── news_reader_app.dart # 應用程式根 Widget
```

## 主要元件說明
- `News`: 定義新聞資料結構的資料模型。
- `NewsService`: 負責提供新聞資料的服務層（目前為模擬數據）。
- `NewsEvent`: 定義了觸發狀態改變的事件，如 `LoadNewsEvent`, `AddNewsEvent`。
- `NewsState`: 定義了 UI 可能呈現的不同狀態，如 `NewsInitial`, `NewsLoading`, `NewsLoaded`, `NewsError`。
- `NewsBloc`: 作為 ViewModel，接收 `NewsEvent`，調用 `NewsService`，並發出 `NewsState`。
- `NewsReaderApp`: 應用程式的根 Widget。
- `NewsListPage`: 顯示新聞列表的頁面，使用 `BlocBuilder` 監聽 `NewsBloc` 的狀態。
- `NewsDetailPage`: 顯示單則新聞詳細內容的頁面。
- `AddNewsPage`: 用於新增新聞的頁面，透過 `context.read<NewsBloc>().add()` 觸發 `AddNewsEvent`。

## 本專案中的 BLoC 應用

在這個新聞閱讀器範例中，我們這樣應用 BLoC 模式：

1.  **定義事件與狀態 (`news_event.dart`, `news_state.dart`)**:
    *   定義了基礎的 `NewsEvent` 和 `NewsState` 抽象類別，並使用 `Equatable` 簡化比較。
    *   具體的事件如 `LoadNewsEvent` 和 `AddNewsEvent(news)`。
    *   具體的狀態如 `NewsInitial`, `NewsLoading`, `NewsLoaded(newsList)`, `NewsError(message)`。

2.  **實現 BLoC 邏輯 (`NewsBloc`)**:
    *   `NewsBloc` 繼承自 `Bloc<NewsEvent, NewsState>`。
    *   它接收 `NewsService` 作為依賴。
    *   使用 `on<EventType>(_handler)` 註冊事件處理器。
    *   `_onLoadNews` 處理 `LoadNewsEvent`：發出 `NewsLoading` -> 調用 `_newsService.fetchNews()` -> 成功則發出 `NewsLoaded`，失敗則發出 `NewsError`。
    *   `_onAddNews` 處理 `AddNewsEvent`：更新內部新聞列表，並發出包含新列表的 `NewsLoaded` 狀態。

3.  **提供 BLoC 實例 (`main.dart`)**:
    *   在 `runApp` 的外層使用 `BlocProvider` 來創建 `NewsBloc` 實例 (同時注入 `NewsService`)。
    *   在創建 `NewsBloc` 後，立即添加 `LoadNewsEvent` 以觸發初始數據加載 (`..add(LoadNewsEvent())`)。

4.  **在 UI 中響應狀態 (`NewsListPage`)**:
    *   使用 `BlocBuilder<NewsBloc, NewsState>` 包裹需要根據狀態變化的 UI 部分。
    *   `builder` 回調接收 `context` 和 `state`。
    *   根據 `state` 的具體類型 (使用 `is` 判斷，如 `state is NewsLoading`) 來渲染不同的 Widget (如 `CircularProgressIndicator`, `ListView`, 錯誤訊息)。
    *   從 `NewsLoaded` 狀態中獲取 `newsList` 來顯示列表。

5.  **在 UI 中觸發事件 (`NewsListPage`, `AddNewsPage`)**:
    *   在 `NewsListPage` 的 `initState` 中，使用 `context.read<NewsBloc>().add(LoadNewsEvent())` 觸發初始加載。
    *   在 `AddNewsPage` 的按鈕回調中，使用 `context.read<NewsBloc>().add(AddNewsEvent(newNews))` 將新新聞添加到 BLoC。

這種方式確保了業務邏輯集中在 `NewsBloc` 中，UI 層只負責響應狀態和發送事件。

## 依賴注入
本專案使用 `get_it` 套件進行簡單的服務定位 (Service Locator) 模式實現依賴注入：
- 在 `main.dart` 中註冊 `NewsService` 的單例。
- 在創建 `NewsBloc` 時，使用 `getIt<NewsService>()` 來獲取 `NewsService` 的實例並注入。
- 這有助於解耦 `NewsBloc` 和 `NewsService` 的直接依賴。

## 如何運行專案
1.  確保已安裝 Flutter 開發環境。
2.  複製此專案儲存庫。
3.  進入 `mvvm/bloc` 目錄：`cd mvvm/bloc`
4.  獲取專案依賴：`flutter pub get`
5.  運行應用程式：`flutter run` (或使用 VS Code 的 "MVVM BLoC" 運行配置)

## 測試
（目前專案包含基礎的 Widget 測試，可以使用 `bloc_test` 套件編寫更詳細的 BLoC 單元測試）
- 執行測試：`flutter test`

## 學習目標
透過此範例，您可以學習：
- 如何在 Flutter 中實踐 MVVM 架構。
- 如何使用 BLoC / flutter_bloc 進行狀態管理。
- 事件驅動的狀態管理模式。
- Flutter 應用程式的架構設計原則。

## 貢獻
歡迎透過提交 Pull Requests 或 Issues 來協助改進這個範例專案！
