# FangYuan 方圆

[![Travis CI](https://travis-ci.org/HaloWang/FangYuan.svg?branch=master)](https://travis-ci.org/HaloWang/FangYuan)

『方圆』是一个容易使用，轻量级，高性能，纯代码的布局库。

『方圆』基于 `UIView.frame` 属性来进行布局，有 Swift 和 [Objective-C](https://github.com/HaloWang/FangYuanObjC) 两种实现

『方圆』提供一种简洁美观的方式操作 `UIView.frame` 属性

『方圆』提供一个比 [Masonry](https://github.com/SnapKit/Masonry)/[SnapKit](https://github.com/SnapKit/SnapKit) 更便于使用和调试的布局方案

## 你是否愿意使用方圆

- 如果你经常使用 Masonry/SnapKit 和 frame/frame-based-layout-util 进行布局，我非常推荐你了解一下『方圆』
- 如果你有一套自己的布局库，那我将非常乐意和你交流😁
- 如果你热衷使用 `xib/storyboard`，『方圆』可能并不是你想要的的

## 使用 CocoaPods 将方圆集成进你的工程中

在你的 `Podfile` 中键入以下语句

### Swift
``` ruby
platform :ios, '8.0'
use_frameworks!
target '<Your Target Name>' do
    pod 'FangYuan'
end
```
### Objective-C

如果你想在 ObjC 环境中使用方圆，你需要使用方圆的 ObjC 实现

``` ruby
target '<Your Target Name>' do
    pod 'FangYuanObjC'
end
```
## 使用方式

### 基本使用方式

设定一个 `UIView` 距离其父视图的边距为 `10`

``` swift
view
    .fy_top(10)
    .fy_left(10)
    .fy_right(10)
    .fy_bottom(10)
```
或者

``` swift
view.fy_edge(UIEdgeInsets(top: 10, left: 10, bottom: 10, right:10))
```
### 两个 UIView 间的关系

设定一个 `UIView` 的底部距离另一个 `UIView` 的顶部的距离为 20

``` swift
view
    .fy_top(10)
    .fy_left(10)
    .fy_right(10)
    .fy_bottom(anotherView.chainTop + 20)
```

### 你可以在 Demo 中查看更多的代码

## 方圆的特点

- 使用简单，和现有布局库没有命名和使用上的冲突（但是不可以混用）
- 基于 `UIView.frame` 布局，比 `NSAutoLayout` 有更高的性能
- 使用链式语法，代码美观简介
- 『方圆』在 Swift 和 ObjC 中的语法仅有两点不同，能让你在 ObjC/Swift 环境下近乎无缝的使用：
	- ObjC 中链式代码的结尾需要添加 `;` 
	- ObjC 中链式代码返回值类型为 `UIView` 而非 `instancetype`

### 猜测式依赖

`aView.fy_bottom()` 中只有传递 `anotherView.chainTop` 是有效的，传入其他的 `chainXXX` 值，是不会产生实际效果的

同理

方法		|	调用
---		|	---
fy_top		|	chainBottom
fy_bottom	|	chainTop
fy_left		|	chainRight
fy_right	|	chainLeft

## 要做的事情

- 更多，更完善的 `Demo/Test`
- 将字符串展示面积的计算方法融入『方圆』中，并且可以同时设定高度/宽度
- 添加 `fy_centerX/fy_centerY`
- 为逻辑部分添加充分的 Unit Test
- 优化性能

## 写在最后

- 欢迎随时联系我讨论问题
- 欢迎 PR & issue

Best wishes ~
