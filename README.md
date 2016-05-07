# 方圆

⚠️

[![Travis CI](https://travis-ci.org/HaloWang/FangYuan.svg?branch=master)](https://travis-ci.org/HaloWang/FangYuan)

『方圆』是一个容易使用，轻量级，高性能，纯代码的布局库。

『方圆』基于 `UIView.frame` 属性来进行布局，有 Swift 和 Objective-C 两种实现

『方圆』提供一种简洁美观的方式操作 `UIView.frame` 属性

『方圆』提供一个比 [Masonry](https://github.com/SnapKit/Masonry)/[SnapKit](https://github.com/SnapKit/SnapKit) 更便于使用和调试的布局方案

## 你是否愿意使用方圆

- 如果你经常使用 Masonry/SnapKit 和 frame 进行布局，我非常推荐你使用『方圆』
- 如果你有一套自己的布局库，那我将非常乐意和你交流😁
- 如果你热衷使用 `xib/storyboard`，『方圆』可能并不是你想要的的

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
## 使用方式

你可以在 demo 中直接浏览相关代码

### UIViewController

⚠️

### UITableViewCell / UICollecionViewCell

⚠️

ObjC 环境下的方圆也使用了上述代码，规则完全一样

## 方圆的优势

- 使用简单
- 和现有布局库没有命名冲突
- 基于 `UIView.frame` 布局，比 `NSAutoLayout` 有更高的性能
- 使用链式语法，代码美观简介
- 『方圆』在 Swift 和 ObjC 中的语法仅有两点不同，转换思维成本底：
	- ObjC 中链式代码的结尾需要添加 `;` 分号
	- ObjC 中链式代码返回值类型为 `UIView` 而非 `instancetype`

## 方圆的劣势

- 猜测式依赖 ⚠️
- 暂时不支持宽度、高度自适应

## 要做的事情

- 更多的 demo
- 将字符串展示面积的计算方法融入『方圆』中
- 将高度和宽度同样作为依赖
- 『方圆』大量使用了 `map`, `filter` 等函数，这里面可能有需要性能优化的地方
- 和其他布局库作对比的 demo
- 为逻辑部分添加充分的 Unit Test
- 将 ObjC 和 Swift 版本的方圆放到一个库中，并尽量重用代码

## 写在最后

- 欢迎随时联系我讨论问题
- 欢迎 PR & issue

Best wishes ~
