//
//  AiringTodayCollectionViewCell.swift
//  MyTvShows
//
//  Created by Jeans on 10/2/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import Shared
import UI

class AiringTodayCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var backImageView: UIImageView!
  @IBOutlet weak var showNameLabel: TVBoldLabel!
  @IBOutlet weak var starImageView: UIImageView!
  @IBOutlet weak var averageLabel: TVRegularLabel!
  
  var viewModel: AiringTodayCollectionViewModel? {
    didSet {
      setupUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUIElements()
  }
  
  private func setupUIElements() {
    starImageView.image = UIImage(name: "star")
    showNameLabel.tvSize = .custom(22)
  }
  
  func setupUI() {
    guard let viewModel = viewModel else { return }
    
    showNameLabel.text = viewModel.showName
    averageLabel.text = viewModel.average
    
    containerView.layer.cornerRadius = 14
    containerView.clipsToBounds = true
    
    backImageView.contentMode = .scaleToFill
    backImageView.setImage(with: viewModel.posterURL)
  }
  
  override func prepareForReuse() {
    backImageView.image = nil
  }
}
