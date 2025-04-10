# MVP (Model-View-Presenter) 架構

本子專案展示了使用不同狀態管理工具實現 MVP 架構的四種方式：

1. **BLoC (Business Logic Component)**
   - 使用事件流管理狀態
   - 主持人（Presenter）處理業務邏輯

2. **Riverpod**
   - 使用狀態提供者管理狀態
   - 提供更宣告式的狀態管理方式

3. **Provider**
   - 使用依賴注入和狀態管理
   - 簡化主持人層的實現

4. **MobX**
   - 使用可觀察物件和反應式程式設計
   - 增強主持人的狀態管理能力

## 專案結構

```
mvp/
├── bloc/
│   ├── models/
│   ├── views/
│   ├── presenters/
│   └── services/
├── riverpod/
│   ├── models/
│   ├── views/
│   ├── presenters/
│   └── services/
├── provider/
│   ├── models/
│   ├── views/
│   ├── presenters/
│   └── services/
└── mobx/
    ├── models/
    ├── views/
    ├── presenters/
    └── services/
```

## 範例應用：書籍管理系統

每個實現都包含：
- 書籍列表展示
- 書籍詳細資訊
- 新增/編輯/刪除書籍功能
