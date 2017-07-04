//
//  WildCardsTests.swift
//  WildCardsTests
//
//  Created by Ø on 04/07/2017.
//  Copyright © 2017 mainvolume. All rights reserved.
//

import XCTest
@testable import WildCards


class WildCardsTests: XCTestCase {
    
    var managerTest:ModelManager! = ModelManager()
    
    override func setUp() {
        super.setUp()
        managerTest.loadData()
        
        managerTest.onNewModel = {  model in
            print(model)
        }
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        managerTest = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testLoad() {
        NetworkLayerConfiguration.setup()
        
        let dataRequest = DataOperation()
        dataRequest.success = {  item in
            print(item.count)
        }
        
        dataRequest.failure = {
            error in print(error.localizedDescription)
        }
        NetworkQueue.shared.addOperation(dataRequest)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.managerTest.loadData()
            
            self.managerTest.onNewModel = {  model in
                print(model.firstName)
            }
        }
    }
    
}
