# MVP + Riverpod 書籍管理系統

## 專案概述
這是一個使用 MVP（Model-View-Presenter）架構和 Riverpod 套件進行狀態管理與依賴注入的書籍管理應用程式範例。旨在展示如何運用 Flutter 和 Riverpod 建構一個結構清晰、可測試且易於維護的行動應用程式。

## 架構特點
- **MVP (Model-View-Presenter)**
  - **Model**: 負責應用程式的資料和業務邏輯的核心部分 (`lib/models/`)。
  - **View**: 負責顯示資料（由 Presenter 提供）並將使用者操作傳遞給 Presenter (`lib/views/`)。View 通常是 `ConsumerWidget` 或 `ConsumerStatefulWidget`，使用 `ref.watch` 來響應狀態變化。
  - **Presenter (`StateNotifier`)**: 作為 Model 和 View 之間的中介 (`lib/presenters/`)。它繼承 `StateNotifier`，管理一個不可變的狀態物件 (`BookState`)，從 Model 獲取資料（透過 Service），處理資料，並更新狀態以通知 View。
  - 提升程式碼的可讀性、可測試性與關注點分離。

- **Riverpod**
  - 一個強大且類型安全的狀態管理和依賴注入解決方案。
  - 編譯時安全，易於測試，不依賴 Flutter Widget 樹。
  - 提供多種 Provider 類型 (`Provider`, `StateProvider`, `StateNotifierProvider`, `FutureProvider`, `StreamProvider` 等)。

## Riverpod 核心概念 (與 MVP 結合)

在此 MVP 架構中，`StateNotifierProvider` 和 `StateNotifier` 主要用於實現 Presenter：

- **`StateNotifier` (`BookPresenter`)**: Presenter 類別繼承 `StateNotifier<S>`，其中 `S` 是狀態類別 (例如 `BookState`)。它包含修改狀態和執行業務邏輯的方法。狀態 `state` 屬性是不可變的，每次更新都需要創建一個新的狀態實例。
- **`StateNotifierProvider`**: 在 `providers.dart` 中定義，用於創建和提供 `BookPresenter` 的實例。它可以依賴其他 Provider (例如 `bookServiceProvider`) 來獲取依賴項。
- **`Provider`**: 用於提供唯讀的依賴項，例如 `BookService`。
- **`WidgetRef`**: 在 `ConsumerWidget` 或 `ConsumerStatefulWidget` 的 `build` 方法中可用，用於與 Provider 互動。
- **`ref.watch(provider)`**: 在 View 的 `build` 方法中使用，用於監聽 Provider 的狀態變化。當 Provider 的狀態更新時，會觸發 Widget 重建。
- **`ref.read(provider)`**: 用於讀取 Provider 的當前值，通常在事件回調中使用，不會觸發 Widget 重建。
- **`ref.read(provider.notifier)`**: 用於獲取 `StateNotifierProvider` 的 `StateNotifier` 實例 (即 `BookPresenter`)，以便呼叫其方法。

## 主要功能
- 書籍列表展示
- 書籍詳細內容頁面
- 新增/編輯書籍功能
- 刪除書籍功能
- 使用 Riverpod (`StateNotifier`) 作為 Presenter 進行狀態管理

## 技術棧
- Flutter 框架
- Riverpod / flutter_riverpod (用於狀態管理和依賴注入)
- Freezed / freezed_annotation (推薦用於生成不可變狀態類別)
- uuid (用於生成唯一 ID)
- Dart 語言

## 專案結構
```
mvp/riverpod/
├── lib/
│   ├── main.dart           # 應用程式入口點，設置 ProviderScope
│   ├── models/
│   │   └── book.dart       # 資料模型 (Book)
│   ├── services/
│   │   └── book_service.dart # 資料服務層 (操作書籍資料)
│   ├── presenters/         # Presenter 層 (StateNotifier)
│   │   ├── book_presenter.dart # Presenter 核心邏輯
│   │   └── book_state.dart     # Presenter 管理的狀態類別 (使用 Freezed)
│   ├── providers.dart        # 定義 Riverpod Providers
│   └── views/              # UI 介面層 (View - ConsumerWidgets)
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
- `BookState`: 使用 Freezed 定義的不可變狀態類別，包含書籍列表、載入狀態、錯誤訊息和選中的書籍。
- `BookPresenter`: 作為 Presenter，繼承 `StateNotifier<BookState>`，管理 `BookState`，並提供修改狀態的方法。
- `bookServiceProvider`: 提供 `BookService` 實例的 `Provider`。
- `bookPresenterProvider`: 提供 `BookPresenter` 實例的 `StateNotifierProvider`。
- `BookApp`: 應用程式的根 Widget。
- `BookListPage`: 顯示書籍列表的頁面 (View)，繼承 `ConsumerWidget`，使用 `ref.watch` 監聽 `bookPresenterProvider` 的狀態。
- `BookDetailPage`: 顯示單本書籍詳細內容的頁面 (View)，繼承 `ConsumerWidget`，使用 `ref.watch` 監聽 `bookPresenterProvider` 的狀態。
- `AddEditBookPage`: 用於新增或編輯書籍的頁面 (View)，繼承 `ConsumerStatefulWidget`，透過 `ref.read(bookPresenterProvider.notifier)` 觸發 Presenter 中的方法。

## 本專案中的 Riverpod 應用 (作為 Presenter)

1.  **定義狀態 (`book_state.dart`)**:
    *   使用 `@freezed` 定義 `BookState`，包含 `books`, `status`, `selectedBook`, `errorMessage` 等屬性。Freezed 自動生成 `copyWith`、`==`、`hashCode` 等方法。

2.  **實現 Presenter (`BookPresenter`)**:
    *   `BookPresenter` 繼承 `StateNotifier<BookState>`。
    *   接收 `BookService` 作為依賴。
    *   方法（例如 `loadBooks`, `addBook`）執行業務邏輯，並透過更新 `state` 屬性來改變狀態 (例如 `state = state.copyWith(status: BookListStatus.loading)` 或 `state = state.copyWith(books: newBooks, status: BookListStatus.success)`)。

3.  **定義 Providers (`providers.dart`)**:
    *   `bookServiceProvider = Provider(...)`：創建並提供 `BookService`。
    *   `bookPresenterProvider = StateNotifierProvider(...)`：創建 `BookPresenter`，並使用 `ref.watch(bookServiceProvider)` 注入 `BookService`。

4.  **設置根節點 (`main.dart`)**:
    *   使用 `ProviderScope` 包裹 `BookApp`，使整個應用程式可以訪問定義的 Provider。

5.  **在 View 中響應狀態變化 (`BookListPage`, `BookDetailPage`)**:
    *   Widget 繼承 `ConsumerWidget` 或 `ConsumerStatefulWidget`。
    *   在 `build` 方法中，使用 `ref.watch(bookPresenterProvider)` 來獲取 `BookState`。
    *   根據 `state` 的屬性（例如 `state.status`, `state.books`）來渲染不同的 UI。當狀態改變時，`ref.watch` 會自動觸發重建。
    *   可以使用 `ref.watch(bookPresenterProvider.select((s) => s.selectedBook))` 來僅監聽狀態的特定部分。

6.  **在 View 中觸發動作 (`BookListPage`, `AddEditBookPage`)**:
    *   使用 `ref.read(bookPresenterProvider.notifier)` 來獲取 `BookPresenter` 的實例。
    *   在按鈕點擊等事件回調中，呼叫 Presenter 的方法（例如 `ref.read(bookPresenterProvider.notifier).deleteBook(id)`）。

這種方式利用 Riverpod 的特性，實現了類型安全、可測試且解耦的狀態管理和依賴注入。

## 程式碼生成
如果使用 Freezed 來定義狀態類別：
- `build_runner`: Dart 的建構工具。
- `freezed`: Freezed 的程式碼生成器。
- 執行 `flutter pub run build_runner build --delete-conflicting-outputs` 可以自動生成必要的樣板程式碼（如 `*.freezed.dart` 檔案）。

## 依賴注入
Riverpod 本身就是一個依賴注入框架：
- 使用 `Provider` 定義和提供服務 (`BookService`)。
- 使用 `StateNotifierProvider` 定義和提供 Presenter (`BookPresenter`)，並在創建時注入其依賴 (`BookService`)。
- 在需要的地方使用 `ref` (來自 `ConsumerWidget` 等) 來讀取 (`ref.read`) 或監聽 (`ref.watch`) 這些 Provider。

## 如何運行專案
1.  確保已安裝 Flutter 開發環境。
2.  複製此專案儲存庫。
3.  進入 `mvp/riverpod` 目錄：`cd mvp/riverpod`
4.  獲取專案依賴：`flutter pub get`
5.  (如果使用了 Freezed) 執行程式碼生成：`flutter pub run build_runner build --delete-conflicting-outputs`
6.  運行應用程式：`flutter run` (或使用 VS Code 的 "MVP Riverpod" 運行配置)

## 測試
（注意：目前專案未包含針對性的單元或 Widget 測試。若要進行測試，可以使用 `riverpod` 提供的測試工具（如 `ProviderContainer`）和 `mocktail` 等工具模擬 Service 來進行 Notifier 的單元測試，並使用 `flutter_test` 編寫 Widget 測試。）
- 執行測試（如果添加了）：`flutter test`

## 學習目標
透過此範例，您可以學習：
- 如何在 Flutter 中實踐 MVP 架構。
- 如何使用 Riverpod (`StateNotifierProvider`) 作為 Presenter 進行狀態管理。
- Riverpod 的核心概念和用法 (`ProviderScope`, `Provider`, `StateNotifierProvider`, `ref`, `watch`, `read`, `notifier`)。
- Flutter 應用程式的架構設計原則。

## 貢獻
歡迎透過提交 Pull Requests 或 Issues 來協助改進這個範例專案！
