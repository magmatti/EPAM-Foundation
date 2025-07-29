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
                task1API.getTrivia(for: .none) { fact in
                    self.fact = fact ?? "loading error"
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

    func getTrivia(for number: Int?, completion: @Sendable @escaping (String?) -> Void) {
        guard let url = URL(string: baseURL)?.appendingPathComponent(triviaPath) else {
            completion(nil)
            return
        }
        print(url)

        session.dataTask(with: .init(url: url)) { data, response, error in
            guard let data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let randomFact = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                completion(randomFact)
            }

        }.resume()
    }

}
