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
        guard let repository = item else { return }
        configure(repository: repository)
    }
    
    // MARK: - methods
    func configure(repository: Item) {
        titleLabel.text = repository.fullName
        languageLabel.text = repository.language.map { "Written in \($0)" }
        starsLabel.text = "\(repository.stargazersCount) stars"
        watchersLabel.text = "\(repository.watchersCount) watchers"
        forksLabel.text = "\(repository.forksCount) forks"
        issuesLabel.text = "\(repository.openIssuesCount) open issues"
        
        guard let avatarUrl = URL(string: repository.owner.avatarUrl) else { return }
        getAvatarImage(url: avatarUrl)
    }
    
    private func getAvatarImage(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
            guard let data = data else { return }
            guard let avatarImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.avatarImageView.image = avatarImage
            }
            
        }.resume()
    }
}
