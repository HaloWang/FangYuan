//
//  FangYuanTests.swift
//  FangYuanTests
//
//  Created by 王策 on 16/4/11.
//  Copyright © 2016年 王策. All rights reserved.
//

import XCTest
import FangYuan

class FangYuanTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     测试基本布局
     */
    func test_top_left_right_bottom() {
        
        let expectedResult = CGRect(x: 10, y: 10, width: 980, height: 980)
        
        let result = CreateEnvironment { (superview, view) in
            view
                .fy_top(10)
                .fy_left(10)
                .fy_right(10)
                .fy_bottom(10)
        }
        
        XCTAssertEqual(result, expectedResult)
    }
    
    /**
     测试约束的先进先出属性
     */
    func test_FIFO() {
        
        let expectedResult = CGRect(x: 10, y: 10, width: 980, height: 980)
        let result = CreateEnvironment { (superview, view) in
            
            view
                .fy_left(RandomCGFloat())
                .fy_right(RandomCGFloat())
                .fy_top(RandomCGFloat())
                .fy_bottom(RandomCGFloat())
                .fy_height(RandomCGFloat())
                .fy_width(RandomCGFloat())
                .fy_edge(UIEdgeInsets(top: RandomCGFloat(), left: RandomCGFloat(), bottom: RandomCGFloat(), right: RandomCGFloat()))
            
            view
                .fy_edge(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
            
        }
        
        XCTAssertEqual(result, expectedResult)
    }
}
