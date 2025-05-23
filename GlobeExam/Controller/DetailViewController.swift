//
//  DetailViewController.swift
//  GlobeExam
//
//  Created by John Lester Celis on 23/5/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    let post: Post

    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Detail"

        let container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

        let titleLabel = UILabel()
        titleLabel.text = post.title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0

        let bodyLabel = UILabel()
        bodyLabel.text = post.body
        bodyLabel.numberOfLines = 0
        bodyLabel.textColor = .darkGray

        container.addSubview(titleLabel)
        container.addSubview(bodyLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
}
