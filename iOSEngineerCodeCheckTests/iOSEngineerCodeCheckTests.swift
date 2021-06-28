//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class RepositoriesTableViewPresenterOutputSpy: RepositoriesTableViewPresenterOutput {
    private(set) var countOfRepositories = 0
    private(set) var countOfTransitionToRepositoryDetailView = 0
    var _updateTableView: (() -> Void)?
    
    func reloadRepositoriesTableView() {
        countOfRepositories += 1
        _updateTableView?()
    }
    
    func keyboardClose() {
    }
    
    func showRepositoryDetailView(index: Int) {
        countOfTransitionToRepositoryDetailView += 1
    }
}

class SearchModelProtocolStub: SearchModelProtocol {
    var repositories: [Item] = []
    private var error: Error?
    
    func fetchRepositories(wordEncode: String, completion: @escaping (Result<[Item], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            repositories = [.init(id: 44838949, fullName: "apple/swift", language: "C++", stargazersCount: 56424, watchersCount: 56424, forksCount: 9055, openIssuesCount: 381, owner: .init(avatarUrl: "https://avatars.githubusercontent.com/u/10639145?v=4"))]
            completion(.success(repositories))
        }
    }
    
    func connectCalcel() {
    }
    
    func addRepositories(result: Result<[Item], Error>) {
        switch result {
        case let .success(repositories):
            self.repositories = repositories

        case let .failure(error):
            self.error = error
        }
    }
}


class iOSEngineerCodeCheckTests: XCTestCase {
    private var repositories: [Item] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
    }
    
    func testSearchRepositoriesSuccess() {
        let spy = RepositoriesTableViewPresenterOutputSpy()
        let stub = SearchModelProtocolStub()
        let presenter = RepositoriesTableViewPresenter(view: spy, model: stub)
        let repositories: [Item] = [.init(id: 44838949, fullName: "apple/swift", language: "C++", stargazersCount: 56424, watchersCount: 56424, forksCount: 9055, openIssuesCount: 381, owner: .init(avatarUrl: "https://avatars.githubusercontent.com/u/10639145?v=4"))]
        presenter.view = spy
        presenter.model = stub
        stub.addRepositories(result: .success(repositories))
        
        let expectation = XCTestExpectation(description: "UITableViewが更新されるまで待つ")
        spy._updateTableView = {
            expectation.fulfill()
        }
        
        presenter.didTapSearchbarButton(text: "Swift")
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(spy.countOfRepositories, 1)
        XCTAssertEqual(spy.countOfTransitionToRepositoryDetailView, 0)
    }
    
    func testSearchRepositoriesError() {
        let spy = RepositoriesTableViewPresenterOutputSpy()
        let stub = SearchModelProtocolStub()
        let presenter = RepositoriesTableViewPresenter(view: spy, model: stub)
        let error = NSError()
        presenter.view = spy
        presenter.model = stub
        stub.addRepositories(result: .failure(error))
        presenter.didTapSearchbarButton(text: "")
        
        XCTAssertEqual(spy.countOfRepositories, 0)
        XCTAssertEqual(spy.countOfTransitionToRepositoryDetailView, 0)
    }
    
    func testDidSelectRepository() {
        let spy = RepositoriesTableViewPresenterOutputSpy()
        let stub = SearchModelProtocolStub()
        let presenter = RepositoriesTableViewPresenter(view: spy, model: stub)
        let repositories: [Item] = [.init(id: 44838949, fullName: "apple/swift", language: "C++", stargazersCount: 56424, watchersCount: 56424, forksCount: 9055, openIssuesCount: 381, owner: .init(avatarUrl: "https://avatars.githubusercontent.com/u/10639145?v=4"))]
        presenter.view = spy
        presenter.model = stub
        stub.addRepositories(result: .success(repositories))
        
        let expectation = XCTestExpectation(description: "UITableViewが更新されるまで待つ")
        spy._updateTableView = {
            expectation.fulfill()
        }
        
        presenter.didTapSearchbarButton(text: "Swift")
        presenter.didSelectRow(at: 0)
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(spy.countOfRepositories, 1)
        XCTAssertEqual(spy.countOfTransitionToRepositoryDetailView, 1)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
