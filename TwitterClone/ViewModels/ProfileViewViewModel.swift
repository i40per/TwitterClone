//
//  ProfileViewViewModel.swift
//  TwitterClone
//
//  Created by Евгений Лукин on 24.06.2023.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveUser() {
      guard let id = Auth.auth().currentUser?.uid else { return }
      DatabaseManager.shared.collectionUsers(retreive: id)
        .handleEvents(receiveOutput: { [weak self] user in
          self?.user = user
          self?.fetchTweets()
        })
        .sink { [weak self] completion in
          if case .failure(let error) = completion {
            self?.error = error.localizedDescription
          }
        } receiveValue: { [weak self] user in
          self?.user = user
        }
        .store(in: &subscriptions)
    }

    func fetchTweets() {
      guard let userID = user?.id else { return }
      DatabaseManager.shared.collectionTweets(retreiveTweets: userID)
        .sink { [weak self] completion in
          if case .failure(let error) = completion {
            self?.error = error.localizedDescription
          }
        } receiveValue: { [weak self] retreivedTweets in
            let sort = retreivedTweets.sorted(by: {$0.createTweetDate < $1.createTweetDate})
            self?.tweets = sort
        }
        .store(in: &subscriptions)
    }
    
    func getFormattedDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMM YYYY"
        return dateFormatter.string(from: date)
    }
}
