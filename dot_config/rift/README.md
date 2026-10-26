# Rift

`config.toml` 由 chezmoi 管理，对应 `~/.config/rift/config.toml`。
修改源文件后执行：

```sh
chezmoi apply ~/.config/rift/config.toml
rift-cli execute config reload
```

## 沿用的 skhd 快捷键

- Hyper = Ctrl + Alt + Shift + Command；Meh = Ctrl + Alt + Shift。
- Hyper + H/J/K/L：向左/下/上/右聚焦。
- Hyper + M：将当前窗口提升到主区域（Master-stack 布局）。
- Hyper + C：切换当前列居中（Scrolling 布局）。
- Hyper + W：循环切换当前列的预设宽度（Scrolling 布局）。
- 默认布局为 Master-stack：主区域在左，占 60%，保留一个主窗口。
- Hyper + U/I/O/P/5–9：切换工作区 1–9。
- Hyper + `;`：返回上个工作区；Hyper + `[` / `]`：上/下一个工作区（包括空工作区）。
- Ctrl + Shift + H/J/K/L：移动窗口节点。
- Alt + Shift + U/I/O/P/5–9：移动窗口到工作区，并跟随。
- Ctrl + Shift + B/F/S/M：当前工作区使用 BSP/浮动/Scrolling/Master-stack 布局。
- Meh + H/L：水平缩小/放大；Meh + K/J：垂直缩小/放大。
- Hyper + Enter：切换窗口占满平铺区域，保留四周外边距和 SketchyBar 栏位。
- Alt + Space：切换窗口浮动。
- Command + Shift + C：创建虚拟工作区。
- Alt + 鼠标左键拖动：移动窗口，拖到其他窗口中央时交换。

额外保留 Rift 的 Alt + Z（切换当前 macOS Space 的平铺管理），新增 Hyper + R（重载配置）。

## 与 yabai 的区别

- 工作区是 Rift 虚拟工作区，不是 macOS Space；配置中的索引从 0 开始。
- 方向聚焦不附带原 skhd 中跨工作区/显示器的 fallback。
- 移动使用 `move_node`，不等同于 yabai 的严格方向交换，也不在边缘自动跨工作区。
- 缩放步长约 5%，不是固定 100 像素。
- 布局切换快捷键仅作用于当前工作区，不改变默认布局。
- 窗口内间距 10，外间距通常为 8。顶栏默认预留 40pt（顶部偏移 4 + 栏高 30 + 栏下 6）；内屏已排除 32pt，顶部外间距为 8pt，使内外屏的窗口均距栏底 6pt。SketchyBar 启动、显示器变化、唤醒及每 10 秒读取各屏幕实际区域，通过 Rift 的 `gaps.per_display` 运行时配置同步间距；底栏对应顶部 8、底部 40。
- SketchyBar 按每块屏幕的实际刘海情况绘制背景：刘海屏左右分段，无刘海屏为完整圆角长条。检测助手由系统 clang 编译到 `~/.cache/sketchybar/display-info`，不把生成的二进制纳入 chezmoi。
- 迁移了常用应用的工作区分配和部分浮动规则，不是全部 yabai 规则。
- 未映射：最近显示器操作、镜像、窗口层级、平衡布局、间距切换、父节点放大、浮动窗口网格定位，以及删除工作区。当前版本没有直接等价的内置命令，不用其他含义的动作冒充。
- SketchyBar 已使用 `items.left.rift`：展示虚拟工作区与当前工作区窗口，支持点击切换/聚焦。原 yabai 模块保留但不加载。
- Rift 启动时订阅工作区、窗口列表、焦点事件并触发 `rift_update`；SketchyBar 每 30 秒额外同步一次，启动与唤醒时也会刷新。
- 右侧上下栏切换按钮同步调整 Rift 默认边距及显示器覆盖值；重载后再次按各屏幕实际预留修正，不再调用 yabai。

## 与 skhd 共存

相同快捷键不能同时交给 skhd 和 Rift。首次应用时已卸载当前登录会话的 skhd 服务，但保留原配置和 LaunchAgent；重新登录后 skhd 可能再次启动。继续使用 Rift 时不要同时启动 skhd。

切回 skhd 时，先停止 Rift，再启动 skhd：

```sh
rift service stop
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist"
```

如需同时恢复 yabai，另行启动其服务。
