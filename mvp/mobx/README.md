# MVP + MobX 書籍管理系統

## 專案概述
這是一個使用 MVP（Model-View-Presenter）架構和 MobX 狀態管理技術開發的書籍管理應用程式範例。旨在展示如何運用 Flutter 和 MobX 建構一個結構清晰、易於維護的行動應用程式。

## 架構特點
- **MVP (Model-View-Presenter)**
  - **Model**: 負責應用程式的資料和業務邏輯的核心部分 (`lib/models/`)。
  - **View**: 負責顯示資料（由 Presenter 提供）並將使用者操作傳遞給 Presenter (`lib/views/`)。View 通常是被動的，使用 `Observer` Widget 來響應狀態變化。
  - **Presenter (MobX Store)**: 作為 Model 和 View 之間的中介 (`lib/presenters/`)。它從 Model 獲取資料（透過 Service），處理資料，管理 UI 相關狀態（使用 MobX Observables），並提供 Action 方法供 View 呼叫以響應使用者輸入。
  - 提升程式碼的可讀性、可測試性與關注點分離。

- **MobX**
  - 一個強大且易於使用的響應式狀態管理函式庫。
  - 利用可觀察物件（Observables）、動作（Actions）和響應（Reactions）實現狀態的自動追蹤與更新。
  - 簡化狀態管理邏輯，使開發者能更專注於業務需求。

## MobX 核心概念 (與 MVP 結合)

在此 MVP 架構中，MobX Store 主要扮演 Presenter 的角色：

- **可觀察狀態 (Observable State)**: 使用 `@observable` 標記您希望 MobX 追蹤的變數（例如 `BookStore` 中的 `books`, `selectedBook`, `loadingStatus`）。當這些變數的值發生變化時，依賴它們的 `Observer` Widget 會自動重建。
- **動作 (Actions)**: 使用 `@action` 標記會修改可觀察狀態的方法（例如 `BookStore` 中的 `loadBooks`, `addBook`, `deleteBook`）。將狀態修改邏輯封裝在 Action 中有助於組織程式碼，並且 MobX 可以更有效地批次處理狀態更新。
- **計算值 (Computed Values)**: 使用 `@computed` 標記可以從現有可觀察狀態派生出的新值。計算值會被快取，只有當其依賴的可觀察狀態改變時才會重新計算。(注意：本專案範例未直接使用 `@computed`)
- **響應 (Reactions)**: 在 Flutter 中，最常用的 Reaction 是 `Observer` Widget (來自 `flutter_mobx`)，它可以自動監聽其 `build` 方法中使用的可觀察狀態，並在狀態變化時自動重建 Widget (View)。

## 主要功能
- 書籍列表展示
- 書籍詳細內容頁面
- 新增/編輯書籍功能
- 刪除書籍功能
- 使用 MobX Store 作為 Presenter 進行狀態管理

## 技術棧
- Flutter 框架
- MobX / flutter_mobx (用於狀態管理和 Presenter 邏輯)
- Provider (用於依賴注入 Store)
- uuid (用於生成唯一 ID)
- `mobx_codegen` / `build_runner` (用於程式碼生成)
- Dart 語言

## 專案結構
```
mvp/mobx/
├── lib/
│   ├── main.dart           # 應用程式入口點，初始化 Service 和 Store Provider
│   ├── models/
│   │   └── book.dart       # 資料模型 (Book)
│   ├── services/
│   │   └── book_service.dart # 資料服務層 (操作書籍資料)
│   ├── presenters/         # Presenter 層 (MobX Store)
│   │   ├── book_store.dart   # MobX Store 核心邏輯 (Presenter)
│   │   └── book_store.g.dart # MobX 自動生成的程式碼
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
- `BookStore`: 作為 Presenter，使用 MobX 管理應用程式的狀態與業務邏輯。包含 `@observable` 狀態和 `@action` 方法。
- `BookApp`: 應用程式的根 Widget，設置 `Provider` 來提供 `BookStore`。
- `BookListPage`: 顯示書籍列表的頁面 (View)，使用 `Observer` 監聽 `BookStore` 的狀態。
- `BookDetailPage`: 顯示單本書籍詳細內容的頁面 (View)，使用 `Observer` 監聽 `BookStore` 的狀態。
- `AddEditBookPage`: 用於新增或編輯書籍的頁面 (View)，透過 `context.read<BookStore>().actionMethod()` 觸發 Store 中的 Action。

## 本專案中的 MobX 應用 (作為 Presenter)

1.  **定義可觀察狀態 (`BookStore`)**:
    *   `@observable ObservableList<Book> books = ObservableList<Book>();`: 標記書籍列表為可觀察。
    *   `@observable Book? selectedBook;`: 標記選中的書籍為可觀察。
    *   `@observable LoadingStatus loadingStatus = LoadingStatus.idle;`: 標記載入狀態為可觀察。
    *   `@observable String? errorMessage;`: 標記錯誤訊息為可觀察。

2.  **定義修改狀態的動作 (`BookStore`)**:
    *   `@action Future<void> loadBooks() async { ... }`: 異步 Action，負責載入書籍，並更新 `loadingStatus`, `books`, `errorMessage`。
    *   `@action Future<void> addBook(String title, String author) async { ... }`: 異步 Action，負責新增書籍，並更新 `loadingStatus`, `books`, `errorMessage`。
    *   `@action Future<void> updateBook(Book book) async { ... }`: 異步 Action，負責更新書籍，並更新相關狀態。
    *   `@action Future<void> deleteBook(String id) async { ... }`: 異步 Action，負責刪除書籍，並更新相關狀態。
    *   `@action void selectBookAction(Book? book) { ... }`: 同步 Action，負責更新 `selectedBook` 狀態。

3.  **在 UI 中響應狀態變化 (`BookListPage`, `BookDetailPage`, `AddEditBookPage`)**:
    *   所有需要根據 `BookStore` 狀態更新的 Widget 都被 `Observer` Widget 包裹。
    *   在 `Observer` 的 `builder` 回調中，直接讀取 Store 的可觀察屬性 (例如 `store.books`, `store.loadingStatus`)。
    *   當 Store 中的 Action 修改了這些可觀察屬性時，`Observer` 會自動觸發其 `builder` 重新執行，更新 UI。

4.  **在 UI 中觸發動作 (`BookListPage`, `AddEditBookPage`)**:
    *   透過 `context.read<BookStore>()` 獲取 Store 實例。
    *   在按鈕點擊等事件回調中，呼叫 Store 的 Action 方法 (例如 `store.deleteBook(id)`, `store.addBook(title, author)`)。

這種方式實現了 View 和 Presenter (Store) 之間清晰的單向數據流和響應式更新。

## 程式碼生成
為了簡化 MobX 的使用，專案利用了程式碼生成工具：
- `build_runner`: Dart 的建構工具。
- `mobx_codegen`: MobX 的程式碼生成器。
- 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 可以自動生成必要的樣板程式碼（`book_store.g.dart`），減少手動編寫的重複工作。

## 依賴注入
本專案使用 `provider` 套件進行依賴注入：
- 在 `main.dart` 中創建 `BookService` 實例並透過 `Provider<BookService>` 提供。
- 在 `BookApp` 中創建 `BookStore` 實例（注入 `BookService`），並透過 `Provider<BookStore>` 提供給下層 Widget。
- 在 View 中使用 `context.read<BookStore>()` 來獲取 Store 實例以呼叫 Action，或使用 `context.watch<BookStore>()` (通常在 `Observer` 內) 來讀取狀態。

## 如何運行專案
1.  確保已安裝 Flutter 開發環境。
2.  複製此專案儲存庫。
3.  進入 `mvp/mobx` 目錄：`cd mvp/mobx`
4.  獲取專案依賴：`flutter pub get`
5.  執行程式碼生成：`flutter pub run build_runner build --delete-conflicting-outputs`
6.  運行應用程式：`flutter run` (或使用 VS Code 的 "MVP MobX" 運行配置)

## 測試
（注意：目前專案未包含針對性的單元或 Widget 測試。若要進行測試，可以使用 `mockito` 等工具模擬 Service 來進行 Store 的單元測試，並使用 `flutter_test` 編寫 Widget 測試。）
- 執行測試（如果添加了）：`flutter test`

## 學習目標
透過此範例，您可以學習：
- 如何在 Flutter 中實踐 MVP 架構。
- 如何使用 MobX 作為 Presenter 進行狀態管理。
- MobX 的核心概念：Observables, Actions, Reactions (Observer)。
- Flutter 應用程式的架構設計原則。

## 貢獻
歡迎透過提交 Pull Requests 或 Issues 來協助改進這個範例專案！
