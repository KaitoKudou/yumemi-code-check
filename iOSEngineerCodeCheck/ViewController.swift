//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var SchBr: UISearchBar!
    
    var repo: [[String: Any]]=[]
    private var items: [Item] = []
    
    private var task: URLSessionTask?
    private var word: String!
    private var url: String!
    var idx: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SchBr.text = "GitHubのリポジトリを検索できるよー"
        SchBr.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        word = searchBar.text!
        
        if word.count != 0 {
            guard let wordEncode = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return
            }
            url = "https://api.github.com/search/repositories?q=\(wordEncode)"
            task = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] (data, res, err) in
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
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
            let dtl = segue.destination as! ViewController2
            dtl.item = items[idx]
        }
        
    }
    
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
        // 画面遷移時に呼ばれる
        idx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
