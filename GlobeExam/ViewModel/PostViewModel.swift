//
//  PostViewModel.swift
//  GlobeExam
//
//  Created by John Lester Celis on 23/5/25.
//

import Foundation
import Combine
import Alamofire

class PostViewModel {
    @Published var posts: [Post] = []
    private var cancellables: Set<AnyCancellable> = []
    private let apiURL = "https://jsonplaceholder.typicode.com/posts"
    private let cacheURL: URL
    
    init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheURL = caches.appendingPathComponent("GlobeExam")
    }
    
    func getPosts() {
        AF.request(apiURL)
            .publishDecodable(type: [Post].self)
            .sink { [weak self] response in
                if let posts = response.value {
                    self?.cachePosts(posts)
                    self?.posts = posts
                } else {
                    self?.posts = self?.loadCachedPosts() ?? []
                }
            }
            .store(in: &cancellables)
    }
    
    private func cachePosts(_ posts: [Post]) {
        if let data = try? JSONEncoder().encode(posts) {
            try? data.write(to: cacheURL)
        }
    }

    func loadCachedPosts() -> [Post] {
        guard let data = try? Data(contentsOf: cacheURL),
              let posts = try? JSONDecoder().decode([Post].self, from: data) else {
            return []
        }
        return posts
    }

    func post(at index: Int) -> Post {
        return posts[index]
    }

    func numberOfPosts() -> Int {
        return posts.count
    }
}
