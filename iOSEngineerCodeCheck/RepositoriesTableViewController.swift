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
    private var items: [Item] = []
    
    private var task: URLSessionTask?
    private var requestUrl: String!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositorySearchBar.text = "GitHubのリポジトリを検索できるよー"
        repositorySearchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            guard let repositoryDetailViewController = segue.destination as? RepositoryDetailViewController else { return }
            repositoryDetailViewController.item = items[index]
        }
    }
    
    // MARK: - methods
    private func fetchRepositories(keyWord: String) {
        if keyWord.count != 0 {
            guard let wordEncode = keyWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            requestUrl = "https://api.github.com/search/repositories?q=\(wordEncode)"
            task = URLSession.shared.dataTask(with: URL(string: requestUrl)!) { [weak self] (data, res, err) in
                guard let data = data else { return }
                do {
                    let repositories = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
                    self?.items = repositories.items
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            task?.resume()
        }
    }
    
    // MARK: - TableView data source/delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = items[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
}

// MARK: - UISearchBarDelegate
extension RepositoriesTableViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyWord = searchBar.text else { return }
        fetchRepositories(keyWord: keyWord)
        searchBar.resignFirstResponder()
    }
}
