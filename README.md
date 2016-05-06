# 方圆

⚠️

[![Travis CI](https://travis-ci.org/HaloWang/FangYuan.svg?branch=master)](https://travis-ci.org/HaloWang/FangYuan)

『方圆』是一个容易使用，轻量级，高性能，纯代码的布局库。

『方圆』基于 `UIView.frame` 属性来进行布局，有 Swift 和 Objective-C 两种实现

## 方圆想做什么

* 提供一种简洁美观的方式操作 `UIView.frame` 属性
* 提供一个比 [Masonry](https://github.com/SnapKit/Masonry)/[SnapKit](https://github.com/SnapKit/SnapKit) 更便于使用和调试的布局方案

## 使用 CocoaPods 将方圆集成进你的工程中

在你的 `Podfile` 中键入以下语句

### Swift
```
use_frameworks!
pod 'FangYuan'
```
### Objective-C

如果你想在 ObjC 环境中使用方圆，你需要使用方圆的 ObjC 实现

```
pod 'FangYuanObjC'
```

然后在终端中

```
$ cd <#Your Project Folder#> && pod install
```

## 使用方式

你可以在 demo 中直接浏览相关代码

### UIViewController

⚠️

### UITableViewCell / UICollecionViewCell

⚠️

ObjC 环境下的方圆也使用了上述代码，规则完全一样

## 方圆的优势

- 使用简单
- 没有命名冲突
- 基于 `UIView.frame` 布局，比 `AutoLayout` 有更高的性能
- 使用链式语法，代码美观简介
- 『方圆』在 Swift 和 ObjC 中的语法是基本完全一样的，仅有两点不同：
	- ObjC 中链式代码的结尾需要添加 `;` 分号
	- ObjC 中链式代码返回值类型为 `UIView` 而非 `instancetype`

## 方圆的劣势

- 猜测式依赖 ⚠️

## 可能要做的事情

- 将 ObjC 和 Swift 版本的方圆放到一个库中，并尽量重用代码
- 和其他布局库作对比：Masonry, SnapKit, eg.
- 将字符串展示面积的计算方法融入方圆中
- 为逻辑部分添加充分的 Unit Test
- 为 `UIView` 和 `CALayer` 提供 `FangYuanAble`，并予以实现

## 写在最后

- 欢迎随时联系我讨论问题
- 欢迎 PR & issue

Best wishes ~
