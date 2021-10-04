//
//  ShowsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift

public protocol ShowsViewModel: AnyObject {
  associatedtype MovieCellViewModel: Equatable

  var fetchTVShowsUseCase: FetchTVShowsUseCase { get set }

  var shows: [TVShow] { get set }

  var showsCells: [MovieCellViewModel] { get set }

  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<MovieCellViewModel>> { get set }

  var disposeBag: DisposeBag { get set }

  func mapToCell(entites: [TVShow]) -> [MovieCellViewModel]
}

extension ShowsViewModel {

  public func getShows(for page: Int, showLoader: Bool = true) {

    if let state = try? viewStateObservableSubject.value(),
      state.isInitialPage,
      showLoader {
      viewStateObservableSubject.onNext(.loading)
    }

    let request = FetchTVShowsUseCaseRequestValue(page: page)

    fetchTVShowsUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] result in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: result, currentPage: page)
        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          strongSelf.viewStateObservableSubject.onNext(.error(error.localizedDescription))
      })
      .disposed(by: disposeBag)
  }

  private func processFetched(for response: TVShowResult, currentPage: Int) {
    if currentPage == 1 {
      shows.removeAll()
    }

    let fetchedShows = response.results ?? []

    self.shows.append(contentsOf: fetchedShows)

    if self.shows.isEmpty ||
      (fetchedShows.isEmpty && response.page == 1) {
      viewStateObservableSubject.onNext(.empty)
      return
    }

    let cellsShows = mapToCell(entites: shows)

    if response.hasMorePages {
      viewStateObservableSubject.onNext( .paging(cellsShows, next: response.nextPage) )
    } else {
      viewStateObservableSubject.onNext( .populated(cellsShows) )
    }
  }
}
