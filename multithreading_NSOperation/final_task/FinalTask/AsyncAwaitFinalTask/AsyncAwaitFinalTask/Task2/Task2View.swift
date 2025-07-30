//
//  Task2View.swift
//  AsyncAwaitFinalTask
//
//  Created by Nikolay Dechko on 4/9/24.
//

import SwiftUI

struct Task2View: View {
    let task2API: Task2API = .init()

    @State var user: Task2API.User?
    @State var products: [Task2API.Product] = []
    @State var duration: TimeInterval?

    var body: some View {
        VStack {
            if let user, !products.isEmpty, let duration {
                Text("User name: \(user.name)").padding()
                List(products) { product in
                    Text("product description: \(product.description)")
                }
                Text("it took: \(duration) second(s)")
            } else {
                Text("Loading in progress")
            }
        }.task {
            let startDate = Date.now
            
            do {
                var fetchedUser: Task2API.User?
                var fetchedProducts: [Task2API.Product] = []

                try await withThrowingTaskGroup(of: Void.self) { group in
                    group.addTask {
                        fetchedUser = try await task2API.getUser()
                    }
                    
                    group.addTask {
                        fetchedProducts = try await task2API.getProducts()
                    }
                    
                    try await group.waitForAll()
                }
                
                self.user = fetchedUser
                self.products = fetchedProducts
                self.duration = DateInterval(start: startDate, end: .now).duration
                
            } catch {
                print("unexpected error")
            }
        }
    }
}

class Task2API: @unchecked Sendable {
    struct User {
        let name: String
    }

    struct Product: Identifiable {
        let id: String
        let description: String
    }

    func getUser() async throws -> User {
        try await Task.sleep(for: .seconds(1))
        return .init(name: "John Smith")
    }

    func getProducts() async throws -> [Product] {
        try await Task.sleep(for: .seconds(1))
        return [.init(id: "1", description: "Some cool product"),
                .init(id: "2", description: "Some expensive product")]
    }
}

#Preview {
    Task2View()
}
