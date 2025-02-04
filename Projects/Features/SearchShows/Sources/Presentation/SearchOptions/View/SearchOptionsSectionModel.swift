//
//  SearchOptionsSectionModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/8/20.
//

import Shared

enum SearchOptionsSectionModel {
  case showsVisited(items: [SearchSectionItem])
  case genres(items: [SearchSectionItem])

  var sectionView: SearchOptionsSectionView {
    switch self {
    case .showsVisited:
      return .showsVisited
    case .genres:
      return .genres
    }
  }

  var items: [SearchSectionItem] {
    switch self {
    case let .showsVisited(items):
      return items
    case let .genres(items):
      return items
    }
  }
}

enum SearchOptionsSectionView: Hashable {
  case showsVisited
  case genres

  var header: String? {
    switch self {
    case .showsVisited:
      return "Recently TVShows Visited"
    case .genres:
      return "TVShows Genres"
    }
  }
}

enum SearchSectionItem: Hashable {
  case showsVisited(items: VisitedShowViewModel)
  case genres(items: GenreViewModel)
}
