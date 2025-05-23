//
//  GlobeExamTests.swift
//  GlobeExamTests
//
//  Created by John Lester Celis on 23/5/25.
//

import XCTest
@testable import GlobeExam

final class GlobeExamTests: XCTestCase {

    func testCachingAndLoadingPosts() {
        let viewModel = PostViewModel()
        let dummyPosts = [
            Post(id: 1, userId: 1, title: "Test Title", body: "Test Body")
        ]

        // Simulate caching
        let mirror = Mirror(reflecting: viewModel)
        if let cacheURL = mirror.descendant("cacheURL") as? URL {
            if let data = try? JSONEncoder().encode(dummyPosts) {
                try? data.write(to: cacheURL)
            }

            let loadedPosts = viewModel.posts.isEmpty ? viewModel.loadCachedPosts() : viewModel.posts
            XCTAssertEqual(loadedPosts.count, 1)
            XCTAssertEqual(loadedPosts.first?.title, "Test Title")
        }
    }
}
