//
//  FetchLoggedUserMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

@testable import ShowDetails
@testable import Shared

class FetchLoggedUserMock: FetchLoggedUser {

  var account: Account?
  
  func execute() -> Account? {
    return account
  }
}
