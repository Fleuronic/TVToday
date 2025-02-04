//
//  SeasonEpisodeTableViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import RxSwift
import Shared

class SeasonListTableViewCell: NiblessTableViewCell {

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isScrollEnabled = true
    collectionView.backgroundColor = .secondarySystemBackground
    return collectionView
  }()

  typealias DataSource = UICollectionViewDiffableDataSource<SectionSeasonsList, Int>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionSeasonsList, Int>
  private var dataSource: DataSource?

  var viewModel: SeasonListViewModelProtocol?

  private var disposeBag = DisposeBag()

  // MARK: - Life Cycle
  public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  private func setupUI() {
    backgroundColor = .secondarySystemBackground
    constructHierarchy()
    activateConstraints()
    configureViews()
  }

  private func constructHierarchy() {
    contentView.addSubview(collectionView)
  }

  private func activateConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.pin(to: contentView)
  }

  private func configureViews() {
    collectionView.allowsMultipleSelection = false
    collectionView.registerCell(cellType: SeasonEpisodeCollectionViewCell.self)
    collectionView.delegate = self
  }

  public func setViewModel(viewModel: SeasonListViewModelProtocol?) {
    self.viewModel = viewModel
    setupDataSource()
    setupBindables()
  }

  private func setupBindables() {
    guard let viewModel = viewModel else {
      return
    }

    viewModel
      .seasons
      .map { data -> Snapshot in
        var snapShot = Snapshot()
        snapShot.appendSections([.season])
        snapShot.appendItems(data, toSection: .season)
        return snapShot
      }
      .subscribe(onNext: { [weak self] snapshot in
        self?.dataSource?.apply(snapshot)
      })
      .disposed(by: disposeBag)

    viewModel
      .seasonSelected
      .filter { $0 > 0 }
      .subscribe(onNext: { [weak self] season in
        self?.selectedSeason(at: season)
      })
      .disposed(by: disposeBag)
  }

  private func selectedSeason(at index: Int) {
    let indexPath = IndexPath(row: index - 1, section: 0)
    if indexPath.row < collectionView.numberOfItems(inSection: 0) {
      collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
    }
  }

  private func setupDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, season in
      guard let strongSelf = self else {
        fatalError()
      }
      let cell = collectionView.dequeueReusableCell(with: SeasonEpisodeCollectionViewCell.self, for: indexPath)
      cell.setViewModel(viewModel: strongSelf.viewModel?.getModel(for: season))
      return cell
    })
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SeasonListTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 50, height: 50)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    let height = collectionView.layer.frame.height
    let insetTop = (height - 50) / 2

    return UIEdgeInsets(top: insetTop, left: 8, bottom: insetTop, right: 0)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let item = dataSource?.itemIdentifier(for: indexPath) {
      viewModel?.inputSelectedSeason.onNext(item)
    }
  }
}
