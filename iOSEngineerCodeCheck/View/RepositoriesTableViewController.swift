//
//  RepositoriesTableViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 工藤海斗 on 2021/06/26.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoriesTableViewController: UITableViewController {
    @IBOutlet weak var repositorySearchBar: UISearchBar!
    private var presenter: RepositoriesTableViewPresenterInput!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositorySearchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        repositorySearchBar.delegate = self
        repositorySearchBar.accessibilityIdentifier = "RepositoriesTableViewController_searchBar"
        presenter = RepositoriesTableViewPresenter(view: self, model: SearchModel())
        inject(presenter: presenter)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            guard let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController else { return }
            repositoryDetailViewController.item = presenter.repositories[index]
        }
    }
    
    // MARK: - methods
    func inject(presenter: RepositoriesTableViewPresenterInput) {
        self.presenter = presenter
    }
    
    // MARK: - TableView data source/delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRepositories
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = presenter.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        presenter.didSelectRow(at: indexPath.row)
    }
    
}

// MARK: - UISearchBarDelegate
extension RepositoriesTableViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyWord = searchBar.text else { return }
        presenter.didTapSearchbarButton(text: keyWord)
    }
}

// MARK: - RepositoriesTableViewPresenterOutput
extension RepositoriesTableViewController: RepositoriesTableViewPresenterOutput {
    func reloadRepositoriesTableView() {
        tableView.reloadData()
    }
    
    func keyboardClose() {
        repositorySearchBar.resignFirstResponder()
    }
    
    func showRepositoryDetailView(index: Int) {
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
