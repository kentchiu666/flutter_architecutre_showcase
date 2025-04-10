# MVP + BLoC 書籍管理系統

## 專案概述
這是一個使用 MVP（Model-View-Presenter）架構和 BLoC (Business Logic Component) 狀態管理模式開發的書籍管理應用程式範例。旨在展示如何運用 Flutter 和 BLoC 建構一個結構清晰、易於維護的行動應用程式。

## 架構特點
- **MVP (Model-View-Presenter)**
  - **Model**: 負責應用程式的資料和業務邏輯的核心部分 (`lib/models/`)。
  - **View**: 負責顯示資料（由 Presenter 提供）並將使用者操作傳遞給 Presenter (`lib/views/`)。View 通常是被動的，不包含業務邏輯。
  - **Presenter**: 作為 Model 和 View 之間的中介 (`lib/presenters/`)。它從 Model 獲取資料（透過 Service），處理資料使其適合顯示在 View 上，並響應 View 的使用者輸入事件來更新 Model（透過 Service）。在此範例中，BLoC 承擔了 Presenter 的大部分職責。
  - 提升程式碼的可讀性、可測試性與關注點分離。

- **BLoC (Business Logic Component)**
  - 一個可預測的狀態管理函式庫，透過事件 (Events) 觸發狀態 (States) 的轉變。
  - 將展示邏輯 (Presentation Logic) 從 UI (View) 中分離出來，提高可測試性。
  - 強調單向數據流，使狀態變化更易於追蹤和理解。

## BLoC 核心概念 (與 MVP 結合)

在此 MVP 架構中，BLoC 主要扮演 Presenter 的角色：

- **事件 (Events)**: 代表 View 觸發的動作（例如按鈕點擊、頁面加載）。事件被發送到 BLoC (Presenter) 進行處理。它們通常是繼承自一個基礎事件類別的簡單類別 (`BookEvent`)。
- **狀態 (States)**: 代表 View 在某個時間點應該呈現的狀況（例如載入中、書籍列表、錯誤訊息）。View 會根據不同的狀態來渲染對應的介面。狀態通常是不可變的 (immutable) 物件 (`BookState`)。
- **流 (Streams)**: BLoC 內部使用 Dart 的 Streams 來處理事件的傳入和狀態的傳出。`flutter_bloc` 套件封裝了這些細節。
- **Bloc 類別 (`BookBloc`)**: 作為 Presenter 的核心，它接收來自 View 的事件，執行展示邏輯（可能與 Service 交互以操作 Model），並根據結果發出 (emit) 新的狀態給 View。它繼承自 `Bloc<BookEvent, BookState>`。
- **BlocProvider**: `flutter_bloc` 提供的 Widget，用於在 Widget 樹中創建和提供 `BookBloc` 實例，使其子 Widget (Views) 可以訪問。
- **BlocBuilder / BlocListener / BlocConsumer**: `flutter_bloc` 提供的 Widgets，用於在 View 層響應 `BookBloc` 的狀態變化。`BlocBuilder` 根據狀態重建 UI，`BlocListener` 用於處理一次性的副作用（如導航、顯示 SnackBar），`BlocConsumer` 結合了兩者的功能。

## 主要功能
- 書籍列表展示
- 書籍詳細內容頁面
- 新增/編輯書籍功能
- 刪除書籍功能
- 使用 BLoC 作為 Presenter 進行狀態管理

## 技術棧
- Flutter 框架
- BLoC / flutter_bloc (用於狀態管理和 Presenter 邏輯)
- Equatable (用於簡化狀態和事件比較)
- uuid (用於生成唯一 ID)
- Dart 語言

## 專案結構
```
mvp/bloc/
├── lib/
│   ├── main.dart           # 應用程式入口點，初始化 Service 和 BlocProvider
│   ├── models/
│   │   └── book.dart       # 資料模型 (Book)
│   ├── services/
│   │   └── book_service.dart # 資料服務層 (操作書籍資料)
│   ├── presenters/         # Presenter 層 (BLoC)
│   │   ├── book_bloc.dart  # BLoC 核心邏輯 (Presenter)
│   │   ├── book_event.dart # BLoC 事件定義
│   │   └── book_state.dart # BLoC 狀態定義
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
- `BookEvent`: 定義了 View 可以觸發的事件，如 `LoadBooks`, `AddBook`, `UpdateBook`, `DeleteBook`, `SelectBook`。
- `BookState`: 定義了 View 可能呈現的不同狀態，如 `BookInitial`, `BookLoading`, `BookLoaded`, `BookSelected`, `BookOperationSuccess`, `BookError`。
- `BookBloc`: 作為 Presenter，接收 `BookEvent`，調用 `BookService`，並發出 `BookState` 來更新 View。
- `BookApp`: 應用程式的根 Widget，設置 `BlocProvider`。
- `BookListPage`: 顯示書籍列表的頁面 (View)，使用 `BlocConsumer` 監聽 `BookBloc` 的狀態並觸發事件。
- `BookDetailPage`: 顯示單本書籍詳細內容的頁面 (View)，使用 `BlocBuilder` 監聽 `BookBloc` 的狀態。
- `AddEditBookPage`: 用於新增或編輯書籍的頁面 (View)，透過 `context.read<BookBloc>().add()` 觸發 `AddBook` 或 `UpdateBook` 事件。

## 本專案中的 BLoC 應用 (作為 Presenter)

1.  **定義事件與狀態 (`book_event.dart`, `book_state.dart`)**:
    *   定義了基礎的 `BookEvent` 和 `BookState` 抽象類別，並使用 `Equatable` 簡化比較。
    *   具體的事件如 `LoadBooks`, `AddBook(title, author)`, `UpdateBook(book)`, `DeleteBook(id)`, `SelectBook(book)`。
    *   具體的狀態如 `BookInitial`, `BookLoading`, `BookLoaded(books)`, `BookSelected(selectedBook, allBooks)`, `BookOperationSuccess(books, message)`, `BookError(message)`。

2.  **實現 BLoC 邏輯 (`BookBloc`)**:
    *   `BookBloc` 繼承自 `Bloc<BookEvent, BookState>`。
    *   它接收 `BookService` 作為依賴 (透過建構子注入)。
    *   使用 `on<EventType>(_handler)` 註冊事件處理器。
    *   例如，`_onLoadBooks` 處理 `LoadBooks` 事件：發出 `BookLoading` -> 調用 `_bookService.getBooks()` -> 成功則發出 `BookLoaded`，失敗則發出 `BookError`。
    *   其他事件處理器 (`_onAddBook`, `_onUpdateBook`, `_onDeleteBook`) 同樣調用 `BookService` 的方法，並在操作後發出 `BookOperationSuccess` (包含更新後的列表) 或 `BookError` 狀態。
    *   `_onSelectBook` 處理 `SelectBook` 事件，發出 `BookSelected` 狀態。

3.  **提供 BLoC 實例 (`main.dart`, `book_app.dart`)**:
    *   在 `main.dart` 中使用 `RepositoryProvider` 提供 `BookService` 的實例。
    *   在 `BookApp` 中使用 `BlocProvider` 來創建 `BookBloc` 實例，並從 `context` 讀取 `BookService` 注入 (`RepositoryProvider.of<BookService>(context)`)。
    *   在創建 `BookBloc` 後，立即添加 `LoadBooks` 事件以觸發初始數據加載 (`..add(LoadBooks())`)。

4.  **在 View 中響應狀態 (`BookListPage`, `BookDetailPage`)**:
    *   `BookListPage` 使用 `BlocConsumer`：
        *   `listener` 根據 `BookOperationSuccess` 或 `BookError` 狀態顯示 SnackBar。
        *   `builder` 根據 `state` 的類型 (如 `BookLoading`, `BookLoaded`, `BookOperationSuccess`, `BookSelected`, `BookError`) 渲染不同的 UI (進度指示器、書籍列表、空狀態、錯誤訊息)。
        *   從 `BookLoaded`, `BookOperationSuccess`, `BookSelected` 狀態中獲取書籍列表 (`books` 或 `allBooks`) 來顯示。
    *   `BookDetailPage` 使用 `BlocBuilder` 根據 `BookSelected` 狀態顯示書籍詳情。

5.  **在 View 中觸發事件 (`BookListPage`, `AddEditBookPage`)**:
    *   `BookListPage` 中的新增按鈕導航到 `AddEditBookPage`。列表項的點擊觸發 `SelectBook` 事件並導航到 `BookDetailPage`。刪除按鈕觸發 `DeleteBook` 事件。
    *   `AddEditBookPage` 中的表單提交時，根據是新增還是編輯，觸發 `AddBook` 或 `UpdateBook` 事件。

這種方式確保了展示邏輯集中在 `BookBloc` (Presenter) 中，View 層保持被動，只負責渲染狀態和轉發使用者事件。

## 依賴注入
本專案使用 `flutter_bloc` 內建的 `RepositoryProvider` 和 `BlocProvider` 來實現依賴注入：
- `RepositoryProvider<BookService>` 在 `main.dart` 中提供 `BookService` 的單例。
- `BlocProvider<BookBloc>` 在 `BookApp` 中創建 `BookBloc`，並使用 `RepositoryProvider.of<BookService>(context)` 獲取 `BookService` 實例進行注入。
- 在需要使用 BLoC 的子 Widget 中，可以使用 `context.read<BookBloc>()` 或 `BlocProvider.of<BookBloc>(context)` 來獲取 BLoC 實例。
- 在導航到新頁面時，若需要共享同一個 BLoC 實例，可以使用 `BlocProvider.value`。

## 如何運行專案
1.  確保已安裝 Flutter 開發環境。
2.  複製此專案儲存庫。
3.  進入 `mvp/bloc` 目錄：`cd mvp/bloc`
4.  獲取專案依賴：`flutter pub get`
5.  運行應用程式：`flutter run` (或使用 VS Code 的 "MVP BLoC" 運行配置)

## 測試
（注意：目前專案未包含針對性的單元或 Widget 測試。若要進行測試，可以使用 `bloc_test` 套件編寫 BLoC 單元測試，並使用 `flutter_test` 編寫 Widget 測試。）
- 執行測試（如果添加了）：`flutter test`

## 學習目標
透過此範例，您可以學習：
- 如何在 Flutter 中實踐 MVP 架構。
- 如何使用 BLoC / flutter_bloc 作為 Presenter 進行狀態管理。
- MVP 中 View 和 Presenter (BLoC) 的職責劃分。
- 事件驅動的狀態管理模式。
- Flutter 應用程式的架構設計原則。

## 貢獻
歡迎透過提交 Pull Requests 或 Issues 來協助改進這個範例專案！
