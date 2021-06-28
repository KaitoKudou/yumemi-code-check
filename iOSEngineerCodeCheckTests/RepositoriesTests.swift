//
//  RepositoriesTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 工藤海斗 on 2021/06/28.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class RepositoriesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {        
        if let path = Bundle.main.path(forResource: "SearchRepositories", ofType: "json") {
            let content = try String(contentsOfFile: path)
            let decoder = JSONDecoder()
            let searchResponse = try? decoder.decode(GitHubSearchResponse.self, from: content.data(using: .utf8)!)
            XCTAssertNotNil(searchResponse)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
