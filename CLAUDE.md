# AI Rule: Flutter Material 3 UI Implementation

## Goal
使用 Flutter 构建 Material 3 风格 UI，要求结构清晰、主题统一、组件可复用，并支持（或预留）动态取色能力。

---

## 1) App 结构规则（必须）
1. 使用 `MaterialApp` 作为根。
2. 全局启用 Material 3：
   - `theme: ThemeData(useMaterial3: true, ...)`
   - `darkTheme` 同步配置。
3. 使用页面级 `Scaffold` 搭建：
   - 顶部：`AppBar`
   - 内容：`SafeArea` + `ListView/CustomScrollView`
   - 底部导航（如需要）：`NavigationBar`（优先于旧 `BottomNavigationBar`）。
4. 页面拆分：
   - 每个页面单独文件（`*_page.dart`）
   - 可复用区块单独组件（`*_section.dart` / `*_card.dart`）
   - 禁止在 `main.dart` 堆积复杂 UI 逻辑。

---

## 2) 主题系统规则（必须）
1. 颜色统一从 `ColorScheme` 读取，禁止硬编码魔法色值。
2. 默认使用：
   - `ColorScheme.fromSeed(seedColor: ...)` 生成基础主题。
3. 文本统一走 `TextTheme`，间距统一走常量（如 `Insets` / `Spacing`）。
4. 组件样式统一在 Theme 层配置：
   - `ElevatedButtonThemeData`
   - `FilledButtonThemeData`
   - `OutlinedButtonThemeData`
   - `CardThemeData`
   - `InputDecorationTheme`
5. 禁止在业务页面大量写 `copyWith` 覆盖；如需覆写，先提取为局部主题方法。

---

## 3) 动态取色规则（推荐）
1. 优先接入 `dynamic_color`。
2. 根组件使用 `DynamicColorBuilder`：
   - 若系统提供 dynamic light/dark scheme，则直接采用；
   - 否则回退到 `ColorScheme.fromSeed(...)`。
3. 动态色与深色模式同时支持：
   - light/dark 均要有 scheme；
   - 跟随系统主题切换（`ThemeMode.system`）。
4. 所有组件必须从 `Theme.of(context).colorScheme` 取色，确保动态色能全局生效。

---

## 4) 页面实现模式（必须遵守）
1. 页面模板：
   - `Scaffold`
   - `AppBar(title: ...)`
   - `body: ListView(children: [HeaderSection, ComponentDemoSection, ...])`
2. 每个 Section 职责单一：
   - 展示一种组件或一类交互状态（enabled/disabled/error/selected）。
3. 组件示例需覆盖状态：
   - normal / hover / focused / disabled / error（可模拟）
4. 保持可访问性：
   - 触控区域 >= 48
   - 文本对比度符合 Material 指导
   - 图标按钮加 `tooltip`。

---

## 5) 代码风格规则
1. 单个 build 方法超过 120 行必须拆分。
2. 重复 UI 片段超过 2 次必须提取 Widget。
3. 常量前置：
   - `const` 优先
   - 文案统一放常量或本地化资源。
4. 命名规则：
   - 页面：`XxxPage`
   - 区块：`XxxSection`
   - 卡片：`XxxCard`
5. 禁止：
   - 业务逻辑直接塞进 UI build 树
   - 深层匿名函数导致可读性下降。

---

## 6) 目录建议
```text
lib/
  main.dart
  app/
    app.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_text_theme.dart
  features/
    home/
      home_page.dart
      widgets/
        home_header_section.dart
        component_entry_card.dart
    components_demo/
      components_demo_page.dart
      widgets/
        buttons_section.dart
        cards_section.dart
        inputs_section.dart
```

---

## 7) 生成代码时的 AI 执行指令
当你（AI）生成 Flutter UI 代码时，必须：
1. 默认输出 Material 3 版本组件；
2. 默认包含 `theme` + `darkTheme`；
3. 若用户提到"动态取色"，自动加入 `dynamic_color` 方案与 fallback；
4. 新增页面时同时给出：
   - 页面文件
   - 复用组件文件
   - 路由接入点；
5. 输出代码必须可直接运行，不留伪代码占位。

---

## 8) 验收清单（Checklist）
- [ ] `useMaterial3: true`
- [ ] `ColorScheme` 统一供色
- [ ] 支持 dark mode
- [ ] （可选）支持 dynamic color + fallback
- [ ] 页面已组件化拆分
- [ ] 无大段重复 UI
- [ ] 关键组件状态覆盖完整
- [ ] 代码可直接运行

---

## 9) 最小参考骨架（示例）
```dart
MaterialApp(
  themeMode: ThemeMode.system,
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  ),
  darkTheme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    ),
  ),
  home: const HomePage(),
);
```
