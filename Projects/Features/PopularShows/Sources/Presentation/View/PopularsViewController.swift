//
//  PupularShowsViewController.swift
//  MyMovies
//
//  Created by Jeans on 8/21/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import Shared

class PopularsViewController: NiblessViewController, Loadable, Retryable, Emptiable {
  
  private let viewModel: PopularViewModelProtocol
  
  private var rootView: PopularsRootView?
  
  private let disposeBag = DisposeBag()
  
  init(viewModel: PopularViewModelProtocol) {
    self.viewModel = viewModel
    super.init()
  }
  
  // MARK: - Life Cycle
  
  override func loadView() {
    rootView = PopularsRootView(viewModel: viewModel)
    view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    subscribe()
    viewModel.viewDidLoad()
  }
  
  fileprivate func subscribe() {
    viewModel
      .viewState
      .subscribe(onNext: { [weak self] state in
        guard let strongSelf = self else { return }
        strongSelf.handleTableState(with: state)
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func handleTableState(with state: SimpleViewState<TVShowCellViewModel>) {
    
    rootView?.stopRefresh()
    
    switch state {
    case .loading:
      showLoadingView()
      hideMessageView()
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .none
      
    case .paging:
      hideLoadingView()
      hideMessageView()
      rootView?.tableView.tableFooterView = LoadingView.defaultView
      rootView?.tableView.separatorStyle = .singleLine
      
    case .populated:
      hideLoadingView()
      hideMessageView()
      rootView?.tableView.tableFooterView = UIView()
      rootView?.tableView.separatorStyle = .singleLine
      
    case .empty:
      hideLoadingView()
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .none
      showEmptyView(with: "No Populars TVShow to see")
      
    case .error(let message):
      hideLoadingView()
      rootView?.tableView.tableFooterView = nil
      rootView?.tableView.separatorStyle = .none
      showMessageView(with: message, errorHandler: { [weak self] in
        self?.viewModel.refreshView()
      })
    }
  }
  
  fileprivate func stopRefreshControl() {
    rootView?.stopRefresh()
  }
}
