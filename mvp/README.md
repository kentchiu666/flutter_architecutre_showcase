# MVP (Model-View-Presenter) Architecture

本子项目展示了使用不同状态管理工具实现MVP架构的四种方式：

1. **BLoC (Business Logic Component)**
   - 使用事件流管理状态
   - 主持者（Presenter）处理业务逻辑

2. **Riverpod**
   - 使用状态提供者管理状态
   - 提供更声明式的状态管理方式

3. **Provider**
   - 使用依赖注入和状态管理
   - 简化主持者层的实现

4. **MobX**
   - 使用可观察对象和反应式编程
   - 增强主持者的状态管理能力

## 项目结构

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

## 示例应用：书籍管理系统

每个实现都包含：
- 书籍列表展示
- 书籍详细信息
- 添加/编辑/删除书籍功能
