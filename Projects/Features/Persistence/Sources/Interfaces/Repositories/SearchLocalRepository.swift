//
//  SearchLocalRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol SearchLocalRepository {
  
  func saveSearch(query: String, userId: Int) -> Observable<Void>
  
  func fetchSearchs(userId: Int) -> Observable<[Search]>
}
