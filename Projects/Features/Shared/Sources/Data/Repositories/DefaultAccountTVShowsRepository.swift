//
//  DefaultAccountTVShowsRepository.swift
//  Account
//
//  Created by Jeans Ruiz on 6/27/20.
//

import Combine
import RxSwift
import NetworkingInterface
import Networking

public final class DefaultAccountTVShowsRepository {

  private let dataTransferService: DataTransferService

  private let basePath: String?

  public init(dataTransferService: DataTransferService,
              basePath: String? = nil) {
    self.dataTransferService = dataTransferService
    self.basePath = basePath
  }
}

// MARK: - AccountTVShowsRepository

extension DefaultAccountTVShowsRepository: AccountTVShowsRepository {

  public func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowResult, DataTransferError> {
    let endpoint = Endpoint<TVShowResult>(
      path: "3/account/\(userId)/favorite/tv",
      method: .get,
      queryParameters: [
        "page": page,
        "session_id": sessionId
      ]
    )
    return dataTransferService.request(with: endpoint)
      .map { self.mapShowDetailsWithBasePath(response: $0) }
      .eraseToAnyPublisher()
  }

  public func fetchWatchListShows(page: Int, userId: Int, sessionId: String) -> AnyPublisher<TVShowResult, DataTransferError> {
    let endpoint = Endpoint<TVShowResult>(
      path: "3/account/\(userId)/watchlist/tv",
      method: .get,
      queryParameters: [
        "page": page,
        "session_id": sessionId
      ]
    )

    return dataTransferService.request(with: endpoint)
      .map { self.mapShowDetailsWithBasePath(response: $0) }
      .eraseToAnyPublisher()
  }

  fileprivate func mapShowDetailsWithBasePath(response: TVShowResult) -> TVShowResult {
    guard let basePath = basePath else {
      return response
    }

    var newResponse = response

    newResponse.results = response.results.map { (show: TVShow) -> TVShow in
      var mutableShow = show
      mutableShow.backDropPath = basePath + "/t/p/w780" + ( show.backDropPath ?? "" )
      mutableShow.posterPath = basePath + "/t/p/w780" + ( show.posterPath ?? "" )
      return mutableShow
    }

    return newResponse
  }

  public func fetchTVAccountStates(tvShowId: Int, sessionId: String) -> AnyPublisher<TVShowAccountStateResult, DataTransferError> {
    let endpoint = Endpoint<TVShowAccountStateResult>(
      path: "3/tv/\(String(tvShowId))/account_states",
      method: .get,
      queryParameters: [
        "session_id": sessionId
      ]
    )
    return dataTransferService.request(with: endpoint)
  }

  public func markAsFavorite(session: String, userId: String, tvShowId: Int, favorite: Bool) -> Observable<StatusResult> {
    let endPoint = AccountShowsProvider.markAsFavorite(
      userId: userId,
      tvShowId: tvShowId,
      sessionId: session,
      favorite: favorite)
    return dataTransferService.request(endPoint, StatusResult.self)
  }

  public func saveToWatchList(session: String, userId: String, tvShowId: Int, watchedList: Bool) -> Observable<StatusResult> {
    let endPoint = AccountShowsProvider.savetoWatchList(
      userId: userId,
      tvShowId: tvShowId,
      sessionId: session,
      watchList: watchedList)
    return dataTransferService.request(endPoint, StatusResult.self)
  }
}
