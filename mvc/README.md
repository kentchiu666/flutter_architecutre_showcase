# MVC (Model-View-Controller) Architecture

本子项目展示了使用不同状态管理工具实现MVC架构的四种方式：

1. **BLoC (Business Logic Component)**
   - 使用事件流管理状态
   - 控制器层处理业务逻辑

2. **Riverpod**
   - 使用状态提供者管理状态
   - 提供更声明式的状态管理方式

3. **Provider**
   - 使用依赖注入和状态管理
   - 简化控制器层的实现

4. **MobX**
   - 使用可观察对象和反应式编程
   - 增强控制器的状态管理能力

## 项目结构

```
mvc/
├── bloc/
│   ├── models/
│   ├── views/
│   ├── controllers/
│   └── services/
├── riverpod/
│   ├── models/
│   ├── views/
│   ├── controllers/
│   └── services/
├── provider/
│   ├── models/
│   ├── views/
│   ├── controllers/
│   └── services/
└── mobx/
    ├── models/
    ├── views/
    ├── controllers/
    └── services/
```

## 示例应用：天气应用

每个实现都包含：
- 天气数据展示
- 城市天气详情
- 添加/管理城市功能
