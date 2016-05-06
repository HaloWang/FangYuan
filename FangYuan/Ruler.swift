//
//  Ruler.swift
//  Halo
//
//  Created by 王策 on 15/11/12.
//  Copyright © 2015年 WangCe. All rights reserved.
//

//  该文件构建了一个 FIFO 的 `Ruler`

import CoreGraphics

/// 尺
///
/// 作为 X 轴或 Y 轴的约束
class Ruler {

    /// 段
    ///
    /// 每个 Ruler 有 A, B, C, 三段
    enum Section {
        case A
        case B
        case C
    }

    /// 最后一次设定的约束
    var last: Ruler.Section?

    /// 第一段
    ///
    /// 对应 X 轴的 x 或 Y 轴的 y
    var a: CGFloat! {
        didSet {
            guard a != nil else {
                return
            }
            if let last = last {
                if last == .B {
                    c = nil
                } else if last == .C {
                    b = nil
                }
            }
            last = .A
        }
    }

    /// 第二段
    ///
    /// 对应 X 轴的 width 或 Y 轴的 height
    var b: CGFloat! {
        didSet {
            guard b != nil else {
                return
            }
            if let last = last {
                if last == .A {
                    c = nil
                } else if last == .C {
                    a = nil
                }
            }
            last = .B
        }
    }

    /// 第三段
    ///
    /// 对应 X 轴的 right 或 Y 轴的 bottom
    var c: CGFloat! {
        didSet {
            guard c != nil else {
                return
            }
            if let last = last {
                if last == .B {
                    a = nil
                } else if last == .A {
                    b = nil
                }
            }
            last = .C
        }
    }
}

// MARK: - CustomStringConvertible
extension Ruler : CustomStringConvertible {
    var description: String {
        return "\(a ?? nil) | \(b ?? nil) | \(c ?? nil)"
    }
}
