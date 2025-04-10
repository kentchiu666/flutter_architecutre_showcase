# MVVM (Model-View-ViewModel) 架構

本子專案展示了使用不同狀態管理工具實現 MVVM 架構的四種方式：

1. **BLoC (Business Logic Component)**
   - 使用事件流管理狀態
   - 適合複雜的狀態管理場景

2. **Riverpod**
   - 使用狀態提供者管理狀態
   - 提供更簡潔和宣告式的狀態管理方式

3. **Provider**
   - 使用依賴注入和狀態管理
   - 簡單易用，適合中小型專案

4. **MobX**
   - 使用可觀察物件和反應式程式設計
   - 高度可擴展的狀態管理方案

## 專案結構

```
mvvm/
├── bloc/
│   ├── models/
│   ├── views/
│   ├── viewmodels/
│   └── services/
├── riverpod/
│   ├── models/
│   ├── views/
│   ├── viewmodels/
│   └── services/
├── provider/
│   ├── models/
│   ├── views/
│   ├── viewmodels/
│   └── services/
└── mobx/
    ├── models/
    ├── views/
    ├── viewmodels/
    └── services/
```

## 範例應用：新聞閱讀器

每個實現都包含：
- 新聞列表展示
- 新聞詳情頁面
- 新增/編輯新聞功能
