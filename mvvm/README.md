# MVVM (Model-View-ViewModel) Architecture

本子项目展示了使用不同状态管理工具实现MVVM架构的四种方式：

1. **BLoC (Business Logic Component)**
   - 使用事件流管理状态
   - 适合复杂的状态管理场景

2. **Riverpod**
   - 使用状态提供者管理状态
   - 提供更简洁和声明式的状态管理方式

3. **Provider**
   - 使用依赖注入和状态管理
   - 简单易用，适合中小型项目

4. **MobX**
   - 使用可观察对象和反应式编程
   - 高度可扩展的状态管理方案

## 项目结构

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

## 示例应用：新闻阅读器

每个实现都包含：
- 新闻列表展示
- 新闻详情页面
- 添加/编辑新闻功能
