# MVP + Provider 書籍管理系統

## 專案概述
這是一個使用 MVP（Model-View-Presenter）架構和 Provider 套件進行狀態管理與依賴注入的書籍管理應用程式範例。旨在展示如何運用 Flutter 和 Provider 建構一個結構清晰、易於維護的行動應用程式。

## 架構特點
- **MVP (Model-View-Presenter)**
  - **Model**: 負責應用程式的資料和業務邏輯的核心部分 (`lib/models/`)。
  - **View**: 負責顯示資料（由 Presenter 提供）並將使用者操作傳遞給 Presenter (`lib/views/`)。View 通常是被動的，使用 `Consumer` 或 `context.watch` 來響應狀態變化。
  - **Presenter (`ChangeNotifier`)**: 作為 Model 和 View 之間的中介 (`lib/presenters/`)。它繼承 `ChangeNotifier`，從 Model 獲取資料（透過 Service），處理資料，管理 UI 相關狀態，並透過 `notifyListeners()` 通知 View 更新。
  - 提升程式碼的可讀性、可測試性與關注點分離。

- **Provider**
  - Flutter 社群推薦的狀態管理和依賴注入解決方案。
  - 提供多種 Provider 類型 (`Provider`, `ChangeNotifierProvider`, `FutureProvider`, `StreamProvider` 等) 來管理不同類型的狀態和依賴。
  - 易於學習和使用，適合各種規模的專案。

## Provider 核心概念 (與 MVP 結合)

在此 MVP 架構中，`ChangeNotifierProvider` 和 `ChangeNotifier` 主要用於實現 Presenter：

- **`ChangeNotifier` (`BookPresenter`)**: Presenter 類別繼承 `ChangeNotifier`。它包含需要被 View 監聽的狀態（例如書籍列表、載入狀態）和修改這些狀態的方法（業務邏輯）。當狀態改變時，呼叫 `notifyListeners()`。
- **`ChangeNotifierProvider`**: 在 Widget 樹的上層創建和提供 `BookPresenter` 的實例。子 Widget 可以透過 `context` 訪問這個實例。
- **`Consumer<T>` / `context.watch<T>()`**: 在 View 中使用，用於監聽 `BookPresenter` 的變化。當 `notifyListeners()` 被呼叫時，使用這些方式監聽的 Widget 會自動重建以反映最新的狀態。
- **`context.read<T>()`**: 在 View 中使用，用於獲取 `BookPresenter` 的實例以呼叫其方法（例如，在按鈕點擊時呼叫 `presenter.addBook()`）。它不會導致 Widget 在狀態變化時重建。
- **`Provider<T>`**: 除了 `ChangeNotifierProvider`，我們也使用基礎的 `Provider` 來提供像 `BookService` 這樣本身不需通知變化的服務實例。

## 主要功能
- 書籍列表展示
- 書籍詳細內容頁面
- 新增/編輯書籍功能
- 刪除書籍功能
- 使用 Provider (`ChangeNotifier`) 作為 Presenter 進行狀態管理

## 技術棧
- Flutter 框架
- Provider (用於狀態管理和依賴注入)
- uuid (用於生成唯一 ID)
- Dart 語言

## 專案結構
```
mvp/provider/
├── lib/
│   ├── main.dart           # 應用程式入口點，初始化 Service 和 Presenter Provider
│   ├── models/
│   │   └── book.dart       # 資料模型 (Book)
│   ├── services/
│   │   └── book_service.dart # 資料服務層 (操作書籍資料)
│   ├── presenters/         # Presenter 層 (ChangeNotifier)
│   │   └── book_presenter.dart # Presenter 核心邏輯
│   └── views/              # UI 介面層 (View)
│       ├── add_edit_book_page.dart
│       ├── book_app.dart   # 應用程式根 Widget
│       ├── book_detail_page.dart
│       └── book_list_page.dart
├── pubspec.yaml            # 專案依賴設定
└── README.md               # 本文件
```

## 主要元件說明
- `Book`: 定義書籍資料結構的資料模型。
- `BookService`: 負責提供和操作書籍資料的服務層（目前為模擬數據）。
- `BookPresenter`: 作為 Presenter，繼承 `ChangeNotifier`，管理應用程式的狀態與業務邏輯，並透過 `notifyListeners()` 通知 View。
- `BookApp`: 應用程式的根 Widget，設置 `ChangeNotifierProvider` 來提供 `BookPresenter`。
- `BookListPage`: 顯示書籍列表的頁面 (View)，使用 `Consumer` 監聽 `BookPresenter` 的狀態。
- `BookDetailPage`: 顯示單本書籍詳細內容的頁面 (View)，使用 `context.watch` 監聽 `BookPresenter` 的狀態。
- `AddEditBookPage`: 用於新增或編輯書籍的頁面 (View)，透過 `context.read<BookPresenter>().actionMethod()` 觸發 Presenter 中的方法。

## 本專案中的 Provider 應用 (作為 Presenter)

1.  **實現 Presenter (`BookPresenter`)**:
    *   `BookPresenter` 繼承 `ChangeNotifier`。
    *   包含狀態變數（例如 `_books`, `_selectedBook`, `_loadingStatus`）。
    *   提供公開的 getter 來訪問狀態（例如 `books`, `selectedBook`）。
    *   包含修改狀態和執行業務邏輯的方法（例如 `loadBooks`, `addBook`, `deleteBook`）。
    *   在狀態變數被修改後，呼叫 `notifyListeners()` 來通知監聽者。

2.  **提供 Presenter 和 Service (`main.dart`, `book_app.dart`)**:
    *   在 `main.dart` 中使用 `Provider<BookService>` 提供 `BookService` 實例。
    *   在 `BookApp` 中使用 `ChangeNotifierProvider<BookPresenter>` 創建 `BookPresenter` 實例，並透過 `context.read<BookService>()` 注入 `BookService`。

3.  **在 View 中響應狀態變化 (`BookListPage`, `BookDetailPage`)**:
    *   `BookListPage` 使用 `Consumer<BookPresenter>` Widget 包裹需要根據狀態重建的部分。`builder` 回調接收 `presenter` 實例，可以直接讀取其狀態屬性（例如 `presenter.books`, `presenter.loadingStatus`）。
    *   `BookDetailPage` 使用 `context.watch<BookPresenter>().selectedBook` 來獲取並監聽選中的書籍。
    *   當 `BookPresenter` 呼叫 `notifyListeners()` 時，`Consumer` 和 `context.watch` 會觸發相關的 View 部分重建。

4.  **在 View 中觸發動作 (`BookListPage`, `AddEditBookPage`)**:
    *   使用 `context.read<BookPresenter>()` 獲取 `BookPresenter` 實例（注意是 `.read`，因為觸發動作通常不需要重建 Widget）。
    *   在按鈕點擊等事件回調中，呼叫 Presenter 的方法（例如 `context.read<BookPresenter>().deleteBook(id)`）。

這種方式利用 Provider 的機制實現了 View 和 Presenter 之間的狀態同步和事件傳遞。

## 依賴注入
本專案使用 `provider` 套件進行依賴注入：
- 在 `main.dart` 中使用 `Provider<BookService>` 提供 `BookService`。
- 在 `BookApp` 中使用 `ChangeNotifierProvider<BookPresenter>` 創建 Presenter，並透過 `context.read<BookService>()` 注入 Service。
- 在 View 中使用 `context.read<BookPresenter>()` 或 `context.watch<BookPresenter>()` 來訪問 Presenter。

## 如何運行專案
1.  確保已安裝 Flutter 開發環境。
2.  複製此專案儲存庫。
3.  進入 `mvp/provider` 目錄：`cd mvp/provider`
4.  獲取專案依賴：`flutter pub get`
5.  運行應用程式：`flutter run` (或使用 VS Code 的 "MVP Provider" 運行配置)

## 測試
（注意：目前專案未包含針對性的單元或 Widget 測試。若要進行測試，可以使用 `mockito` 或 `mocktail` 等工具模擬 Service 來進行 Presenter 的單元測試，並使用 `flutter_test` 編寫 Widget 測試。）
- 執行測試（如果添加了）：`flutter test`

## 學習目標
透過此範例，您可以學習：
- 如何在 Flutter 中實踐 MVP 架構。
- 如何使用 Provider (`ChangeNotifier`) 作為 Presenter 進行狀態管理。
- Provider 的基本用法 (`Provider`, `ChangeNotifierProvider`, `Consumer`, `watch`, `read`)。
- Flutter 應用程式的架構設計原則。

## 貢獻
歡迎透過提交 Pull Requests 或 Issues 來協助改進這個範例專案！
