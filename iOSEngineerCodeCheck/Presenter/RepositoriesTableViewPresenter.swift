//
//  RepositoriesTableViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 工藤海斗 on 2021/06/27.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - protocols
protocol RepositoriesTableViewPresenterInput: AnyObject {
    var numberOfRepositories: Int { get }
    var repositories: [Item] { get }
    func didTapSearchbarButton(text: String)
    func didSelectRow(at indexPathRow: Int)
    func cancel()
}

protocol RepositoriesTableViewPresenterOutput: AnyObject {
    func reloadRepositoriesTableView()
    func keyboardClose()
    func showRepositoryDetailView(index: Int)
}

class RepositoriesTableViewPresenter: RepositoriesTableViewPresenterInput {
    weak var view: RepositoriesTableViewPresenterOutput!
    var model: SearchModelProtocol!
    private(set) var repositories: [Item] = []
    
    
    init(view: RepositoriesTableViewPresenterOutput, model: SearchModelProtocol) {
        self.view = view
        self.model = model
    }
    
    var numberOfRepositories: Int {
        return repositories.count
    }
    
    // MARK: - methods
    func didTapSearchbarButton(text: String) {
        if text.count != 0 {
            guard let wordEncode = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            model.fetchRepositories(wordEncode: wordEncode) { [weak self] result in
                switch result {
                case .success(let items):
                    self?.repositories = items
                    DispatchQueue.main.async {
                        self?.view.keyboardClose()
                        self?.view.reloadRepositoriesTableView()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func didSelectRow(at indexPathRow: Int) {
        view.showRepositoryDetailView(index: indexPathRow)
    }
    
    func cancel() {
        model.connectCalcel()
    }
}
