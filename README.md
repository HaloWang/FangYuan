# 方圆

[![Travis CI](https://travis-ci.org/HaloWang/FangYuan.svg?branch=master)](https://travis-ci.org/HaloWang/FangYuan)

『方圆』是一个容易使用，轻量级，高性能的布局库。

『方圆』基于 UIView.frame 属性来进行布局，有 Swift 和 Objective-C 两种实现

## 方圆想做什么

* 提供一种简洁美观的方式操作 UIView.frame 属性
* 提供一个比 [Masonry](https://github.com/SnapKit/Masonry)/[SnapKit](https://github.com/SnapKit/SnapKit) 更便于使用和调试的布局方案

## 使用 CocoaPods 将方圆集成进你的工程中

在你的 Podfile 中键入以下语句

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

⚠️UnFinish

### UITableViewCell / UICollecionViewCell

⚠️UnFinish

ObjC 环境下的方圆也使用了上述代码，规则完全一样

## 方圆的原理

## 方圆的优势

- 使用简单
- 没有命名冲突
- 基于 frame 布局，比 AutoLayout 有更高的性能
- 使用链式语法，代码美观

## 方圆的劣势

### 规约式编程

⚠️UnFinish

### 需要在 layoutSubview 中实现

⚠️UnFinish

### 不能实现 UIView 的 sizeToFit

⚠️UnFinish

## 将要做的事情

- 接触规约式编程的限制？
- 去掉需要在 layoutSubview 中进行布局的限制
- 集成的字符串展示面积的计算方法

## ⚠️UnFinish
