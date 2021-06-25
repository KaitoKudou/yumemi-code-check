//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 工藤海斗 on 2021/06/26.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var item: Item?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = item else { return }
        configure(item: item)
    }
    
    // MARK: - methods
    private func configure(item: Item) {
        titleLabel.text = item.fullName
        languageLabel.text = item.language.map { "Written in \($0)" }
        starsLabel.text = "\(item.stargazersCount) stars"
        watchersLabel.text = "\(item.watchersCount) watchers"
        forksLabel.text = "\(item.forksCount) forks"
        issuesLabel.text = "\(item.openIssuesCount) open issues"
        
        guard let avatarUrl = URL(string: item.owner.avatarUrl) else { return }
        getAvatarImage(url: avatarUrl)
    }
    
    private func getAvatarImage(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
            guard let data = data else { return }
            let avatarImage = UIImage(data: data)
            
            DispatchQueue.main.async {
                self?.avatarImageView.image = avatarImage
            }
            
        }.resume()
    }
}
