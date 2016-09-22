//
//  Ruler.swift
//  FangYuan
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
        case a
        case b
        case c
    }

    /// 最后一次设定的约束
    var last: Ruler.Section?
    
    /// 约束是否定义完全
    var full: Bool {
        return (a != nil && b != nil) || (a != nil && c != nil) || (b != nil && c != nil)
    }

    /// 第一段
    ///
    /// 对应 X 轴的 x 或 Y 轴的 y
    var a: CGFloat! {
        didSet {
            guard a != nil else {
                return
            }
            if let last = last {
                if last == .b {
                    c = nil
                } else if last == .c {
                    b = nil
                }
            }
            last = .a
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
                if last == .a {
                    c = nil
                } else if last == .c {
                    a = nil
                }
            }
            last = .b
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
                if last == .b {
                    a = nil
                } else if last == .a {
                    b = nil
                }
            }
            last = .c
        }
    }
}

// MARK: - CustomStringConvertible

extension Ruler: CustomStringConvertible {
    var description: String {
        return "\(a ?? nil) | \(b ?? nil) | \(c ?? nil)"
    }
}
