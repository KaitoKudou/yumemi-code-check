//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var ImgView: UIImageView!
    
    @IBOutlet weak var TtlLbl: UILabel!
    
    @IBOutlet weak var LangLbl: UILabel!
    
    @IBOutlet weak var StrsLbl: UILabel!
    @IBOutlet weak var WchsLbl: UILabel!
    @IBOutlet weak var FrksLbl: UILabel!
    @IBOutlet weak var IsssLbl: UILabel!
    
    var vc1: ViewController!
    var item: Item?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = item else { return }
        configure(item: item)
    }
    
    private func configure(item: Item) {
        TtlLbl.text = item.fullName
        LangLbl.text = item.language.map { "Written in \($0)" }
        StrsLbl.text = "\(item.stargazersCount) stars"
        WchsLbl.text = "\(item.watchersCount) watchers"
        FrksLbl.text = "\(item.forksCount) forks"
        IsssLbl.text = "\(item.openIssuesCount) open issues"
        
        guard let avatarUrl = URL(string: item.owner.avatarUrl) else { return }
        getAvatarImage(url: avatarUrl)
    }
    
    func getAvatarImage(url: URL){
        URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
            guard let data = data else { return }
            let avatarImage = UIImage(data: data)
            DispatchQueue.main.async {
                self?.ImgView.image = avatarImage
            }
        }.resume()
    }
    
}
