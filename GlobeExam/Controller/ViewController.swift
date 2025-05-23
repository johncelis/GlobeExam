//
//  ViewController.swift
//  GlobeExam
//
//  Created by John Lester Celis on 23/5/25.
//

import UIKit
import Combine

class ViewController: UIViewController {
    let viewModel = PostViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var filteredPosts: [Post] = []
    private var isSearching = false
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchTextSubject = PassthroughSubject<String, Never>()
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GlobeExam"
        view.backgroundColor = .white
        setupTableView()
        setupSearch()
        bindViewModel()
        viewModel.getPosts()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self

        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search posts"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        searchTextSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.isSearching = !query.isEmpty
                self?.applySearchFilter(query: query)
            }
            .store(in: &cancellables)
    }

    private func bindViewModel() {
        viewModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.applySearchFilter()
            }
            .store(in: &cancellables)
    }

    @objc private func refreshPulled() {
        viewModel.getPosts()
    }

    private func applySearchFilter(query: String = "") {
        if query.isEmpty {
            isSearching = false
            tableView.reloadData()
            return
        }

        filteredPosts = viewModel.posts.filter { post in
            let text = [post.title, post.body].compactMap { $0 }.joined(separator: " ")
            return text.localizedCaseInsensitiveContains(query)
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredPosts.count : viewModel.numberOfPosts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }

        let post = isSearching ? filteredPosts[indexPath.row] : viewModel.post(at: indexPath.row)
        cell.configure(with: post)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = isSearching ? filteredPosts[indexPath.row] : viewModel.post(at: indexPath.row)
        let detailVC = DetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        searchTextSubject.send(query)
    }
}
