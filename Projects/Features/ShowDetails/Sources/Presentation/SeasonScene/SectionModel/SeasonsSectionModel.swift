//
//  SeasonsSectionModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/31/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxDataSources

enum SeasonsSectionModel: Equatable {
  case
  headerShow(header: String, items: [SeasonsSectionItem]),
  seasons(header: String, items: [SeasonsSectionItem]),
  episodes(header: String, items: [SeasonsSectionItem])
}

extension SeasonsSectionModel: AnimatableSectionModelType {

  typealias Item = SeasonsSectionItem

  var items: [SeasonsSectionItem] {
    switch self {
    case .headerShow(_, items: let items):
      return items
    case .seasons(_, items: let items):
      return items
    case .episodes(_, items: let items):
      return items
    }
  }

  typealias Identity = String
  var identity: String {
    switch self {
    case .headerShow(header: let header, items: _):
      return header
    case .seasons(header: let header, items: _):
      return header
    case .episodes(header: let header, items: _):
      return header
    }
  }

  init(original: Self, items: [Self.Item]) {
    switch original {
    case .headerShow(header: let header, items: _):
      self = .headerShow(header: header, items: items)
    case .seasons(header: let header, items: _):
      self = .seasons(header: header, items: items)
    case .episodes(header: let header, items: _):
      self = .episodes(header: header, items: items)
    }
  }
}

// MARK: - Cell Types
enum SeasonsSectionItem {
  case
  headerShow(viewModel: SeasonHeaderViewModelProtocol),
  seasons(number: Int),
  episodes(items: EpisodeSectionModelType)
}

extension SeasonsSectionItem: IdentifiableType {
  typealias Identity = Int

  public var identity: Int {
    switch self {
    case .headerShow(viewModel: let viewModel):
      return viewModel.showName.hashValue
    case .seasons(number: let seasonNumber):
      return seasonNumber
    case .episodes(items: let episode):
      return episode.identity
    }
  }
}

extension SeasonsSectionItem: Equatable {
  public static func == (lhs: SeasonsSectionItem, rhs: SeasonsSectionItem) -> Bool {
    return lhs.identity == rhs.identity
  }
}
