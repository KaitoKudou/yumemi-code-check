//
//  SearchModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 工藤海斗 on 2021/06/27.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol SearchModelProtocol {
    func fetchRepositories(wordEncode: String, completion: @escaping (Result<[Item], Error>) -> Void)
    func connectCalcel()
}

class SearchModel: SearchModelProtocol {
    private var requestUrl: String!
    private var task: URLSessionTask?
    
    func fetchRepositories(wordEncode: String, completion: @escaping (Result<[Item], Error>) -> Void) {
        
        requestUrl = "https://api.github.com/search/repositories?q=\(wordEncode)"
        task = URLSession.shared.dataTask(with: URL(string: requestUrl)!) { [weak self] (data, res, err) in
            guard self != nil else { return }
            guard let data = data else { return }
            
            do {
                let repositories = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
                completion(.success(repositories.items))
            } catch let error {
                completion(.failure(error))
            }
        }
        task?.resume()
    }
    
    func connectCalcel() {
        task?.cancel()
    }
}
