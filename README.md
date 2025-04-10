# Flutter 架構展示 (Flutter Architecture Showcase)

## 專案概述

本專案旨在展示 Flutter 中不同的架構模式和狀態管理技術。透過實現相同的功能，我們可以比較和對比各種架構和狀態管理方案的優缺點。

**關於此專案：**

*   **AI 協助開發**：本專案中的大部分範例程式碼主要由 AI (Cline) 協助生成。
*   **學習目的**：旨在幫助開發者（包括我自己）更深入地理解不同的 Flutter 架構模式（MVC, MVP, MVVM）以及主流狀態管理套件（BLoC, Riverpod, Provider, MobX）的實際應用和差異。
*   **工具範例**：同時，此專案也作為我個人開發其他程式碼解析或分析工具時的實際範例目標。
*   **未來計畫**：目前範例主要關注架構和狀態管理的核心實現，**未來計畫會逐步加入更完整的單元測試 (Unit Test) 和 Widget 測試 (Widget Test) 範例**。
*   **共同進步**：歡迎大家針對程式碼、架構、說明文件等提出建議或 Pull Request，一起學習和改進，希望能對 Flutter 社群有所幫助！

## 架構模式

本專案包含三種主要的架構模式，旨在探索不同的職責分離和組件交互方式：

1.  **MVC (Model-View-Controller) - 模型-視圖-控制器**
    *   **核心思想**: 將應用程式分為三個主要部分：模型（Model）負責數據和業務邏輯；視圖（View）負責展示使用者介面；控制器（Controller）負責處理使用者輸入，更新模型，並選擇要顯示的視圖。
    *   **交互方式**: 使用者與視圖互動 -> 視圖將請求轉發給控制器 -> 控制器操作模型 -> 模型更新後可能通知視圖（或控制器更新視圖）。視圖和模型之間通常是間接關聯的。
    *   **特點**: 歷史悠久，概念相對簡單。但在複雜 UI 中，控制器可能變得臃腫，視圖和控制器之間的耦合度可能較高。
    *   **示例應用**: 天氣應用 (`mvc/`) (待實現)

2.  **MVP (Model-View-Presenter) - 模型-視圖-主持人**
    *   **核心思想**: MVC 的演變，旨在進一步解耦視圖和模型。引入了主持人（Presenter）作為中介。
    *   **交互方式**: 使用者與視圖互動 -> 視圖將事件傳遞給主持人（通常透過介面）-> 主持人操作模型並處理業務邏輯 -> 主持人將處理結果更新回視圖（通常也透過介面）。視圖變得非常被動（Passive View），只負責展示數據和傳遞事件。模型和視圖完全分離。
    *   **特點**: 提高了可測試性（因為視圖邏輯移到了 Presenter 中，且視圖可以被 Mock）。Presenter 和 View 之間通常存在一對一的關係和雙向通訊（透過介面）。
    *   **示例應用**: 書籍管理系統 (`mvp/`)

3.  **MVVM (Model-View-ViewModel) - 模型-視圖-視圖模型**
    *   **核心思想**: MVP 的進一步演變，特別適用於具有數據綁定（Data Binding）能力的 UI 框架（如 Flutter）。引入了 ViewModel 作為中介。
    *   **交互方式**: 使用者與視圖互動 -> 視圖將事件（Commands）轉發給 ViewModel -> ViewModel 操作模型並處理業務邏輯 -> ViewModel 更新其持有的狀態（通常是可觀察的數據）-> 視圖透過數據綁定自動響應 ViewModel 狀態的變化並更新自身。
    *   **特點**: 利用數據綁定機制，大大減少了從 ViewModel 手動更新 View 的樣板程式碼。ViewModel 不直接持有 View 的引用，降低了耦合度。ViewModel 更易於測試。視圖邏輯（如何展示數據）保留在視圖層，而狀態和業務邏輯在 ViewModel 中。
    *   **示例應用**: 新聞閱讀器 (`mvvm/`)

## 狀態管理工具

每個架構模式都搭配四種不同的狀態管理工具進行實作：

1.  **BLoC (Business Logic Component)**
    *   使用事件流管理狀態。
    *   適合複雜的狀態管理場景。

2.  **Riverpod**
    *   使用狀態提供者（Provider）管理狀態。
    *   提供更簡潔和宣告式的狀態管理方式，並整合了依賴注入。

3.  **Provider**
    *   Flutter 官方推薦的狀態管理方案之一。
    *   使用 `ChangeNotifier` 和 `ChangeNotifierProvider` 等進行狀態管理和依賴注入。
    *   簡單易用，適合中小型專案。

4.  **MobX**
    *   使用可觀察物件（Observables）和響應式程式設計。
    *   需要搭配程式碼生成。
    *   提供高度可擴展的狀態管理方案。

## 專案結構

```
flutter_architecture_showcase/
├── mvvm/                 # MVVM 架構範例
│   ├── bloc/             #   - 使用 BLoC
│   ├── riverpod/         #   - 使用 Riverpod
│   ├── provider/         #   - 使用 Provider
│   └── mobx/             #   - 使用 MobX
├── mvc/                  # MVC 架構範例 (待實現)
│   ├── bloc/
│   ├── riverpod/
│   ├── provider/
│   └── mobx/
└── mvp/                  # MVP 架構範例
    ├── bloc/             #   - 使用 BLoC
    ├── riverpod/         #   - 使用 Riverpod
    ├── provider/         #   - 使用 Provider
    └── mobx/             #   - 使用 MobX
```

## 功能特點

（理想情況下）每個子專案和狀態管理實作都包含：
- 資料列表展示
- 詳細頁面
- 新增/編輯/刪除功能
- 依賴注入

## 如何運行

1.  複製本儲存庫。
2.  在專案根目錄執行 `flutter pub get`。
3.  根據 `.vscode/launch.json` 中的配置，選擇要運行的具體架構和狀態管理實作（例如 "MVVM BLoC", "MVVM MobX" 等）。
4.  或者使用命令列指定目標檔案，例如：`flutter run -t mvvm/bloc/lib/main.dart`。

## 學習目標

- 理解不同架構模式（MVC, MVP, MVVM）的原理、優缺點及適用場景。
- 比較各種狀態管理工具（BLoC, Riverpod, Provider, MobX）的使用方式和特性。
- 提升 Flutter 應用程式的架構設計能力。

## 貢獻

歡迎提交 Pull Requests 和 Issues，協助改進和擴展本專案！
