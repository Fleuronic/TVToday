//
//  AuthPermissionViewModelProtocol.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift

public protocol AuthPermissionViewModelDelegate: class {
  
  func authPermissionViewModel(didSignedIn signedIn: Bool)
}

protocol AuthPermissionViewModelProtocol {
  
  func signIn()
  
  var authPermissionURL: URL { get }
  
  var delegate: AuthPermissionViewModelDelegate? { get set }
}
