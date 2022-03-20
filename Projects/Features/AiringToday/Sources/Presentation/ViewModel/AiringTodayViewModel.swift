//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared
import Combine
import Foundation

final class AiringTodayViewModel: AiringTodayViewModelProtocol, ShowsViewModel {
  var fetchTVShowsUseCase: FetchTVShowsUseCase

  var shows: [TVShow]

  var showsCells: [AiringTodayCollectionViewModel] = []

  weak var coordinator: AiringTodayCoordinatorProtocol?

  var viewStateObservableSubject = BehaviorSubject<SimpleViewState<AiringTodayCollectionViewModel>>(value: .loading)

  var viewState: Observable<SimpleViewState<AiringTodayCollectionViewModel>>

  var disposeBag = DisposeBag()

  var cancellabes = Set<AnyCancellable>()

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       coordinator: AiringTodayCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    shows = []

    viewState = viewStateObservableSubject.asObservable()
  }

  func mapToCell(entites: [TVShow]) -> [AiringTodayCollectionViewModel] {
    return entites.map { AiringTodayCollectionViewModel(show: $0) }
  }

  // MARK: Input
  func viewDidLoad() {
    getShows(for: 1)
  }

  func didLoadNextPage() {
    if case .paging(_, let nextPage) = getCurrentViewState() {
      getShows(for: nextPage)
    }
  }

  func refreshView() {
    getShows(for: 1, showLoader: false)
  }

  // MARK: - Output
  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel> {
    guard let currentState = try? viewStateObservableSubject.value() else { return .loading }
    return currentState
  }

  func showIsPicked(with id: Int) {
    navigateTo(step: .showIsPicked(id))
  }

  // MARK: - Navigation
  fileprivate func navigateTo(step: AiringTodayStep) {
    coordinator?.navigate(to: step)
  }
}
