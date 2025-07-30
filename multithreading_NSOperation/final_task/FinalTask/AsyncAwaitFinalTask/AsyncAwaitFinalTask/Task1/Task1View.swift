//
//  SwiftUIView.swift
//  AsyncAwaitFinalTask
//
//  Created by Nikolay Dechko on 4/9/24.
//

import SwiftUI

struct Task1View: View, @unchecked Sendable {
    let task1API = Task1API()
    @State var fact = "To get random number fact presss button below"

    var body: some View {
        VStack {
            Text(fact)
                .padding()
            Button(action: {
                Task {
                    do {
                        let result = try await task1API.getTrivia(for: nil)
                        self.fact = result
                    } catch {
                        self.fact = "Error: \(error)"
                    }
                }
            }, label: { Text("Click me") })
        }
    }
}

#Preview {
    Task1View()
}

class Task1API: @unchecked Sendable {
    let baseURL = "http://numbersapi.com"
    let triviaPath = "random/trivia"
    private var session = URLSession.shared

    func getTrivia(for number: Int?) async throws -> String {
        guard let url = URL(string: baseURL)?.appendingPathComponent(triviaPath) else {
            throw URLError(.badURL)
        }
        print(url)

        let (data, _) = try await session.data(from: url)
        
        guard let randomFact = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeRawData)
        }
        
        return randomFact
    }

}
