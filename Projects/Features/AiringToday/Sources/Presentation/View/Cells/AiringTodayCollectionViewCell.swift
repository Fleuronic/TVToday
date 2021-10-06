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

class AiringTodayCollectionViewCell: NiblessCollectionViewCell {

  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 14
    view.clipsToBounds = true
    return view
  }()

  private lazy var mainStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [backImageView, bottomView])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.distribution = .fill
    stack.spacing = 0
    return stack
  }()

  private let backImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.clipsToBounds = true
    return imageView
  }()

  private let bottomView = UIView()

  private let showNameLabel: TVBoldLabel = {
    let label = TVBoldLabel()
    label.tvSize = .custom(22)
    return label
  }()

  private let starImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(name: "star")
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    return imageView
  }()

  private let averageLabel = TVRegularLabel()

  private var viewModel: AiringTodayCollectionViewModel?

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  func setViewModel(_ viewModel: AiringTodayCollectionViewModel) {
    self.viewModel = viewModel
    showNameLabel.text = viewModel.showName
    averageLabel.text = viewModel.average
    backImageView.setImage(with: viewModel.posterURL)
  }

  override func prepareForReuse() {
    backImageView.image = nil
  }

  private func setupUI() {
    constructHierarchy()
    activateConstraints()
  }

  private func constructHierarchy() {
    bottomView.addSubview(showNameLabel)
    bottomView.addSubview(starImageView)
    bottomView.addSubview(averageLabel)

    containerView.addSubview(mainStackView)
    contentView.addSubview(containerView)
  }

  private func activateConstraints() {
    activateConstraintsForContainerView()
    activateConstraintsForMainStackView()
    activateConstraintsForPosterImageView()
    activateConstraintsForNameShow()
    activateConstraintsForStartImage()
    activateConstraintsForAverageLabel()
  }

  private func activateConstraintsForContainerView() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.pin(to: contentView, insets: .init(top: 8, left: 8, bottom: 0, right: 8))
  }

  private func activateConstraintsForMainStackView() {
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.pin(to: containerView)
  }

  private func activateConstraintsForPosterImageView() {
    backImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      backImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.8)
    ])
  }

  private func activateConstraintsForNameShow() {
    showNameLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      showNameLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 8),
      showNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: starImageView.leadingAnchor, constant: -8),
      showNameLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
    ])
  }

  private func activateConstraintsForStartImage() {
    starImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      starImageView.widthAnchor.constraint(equalToConstant: 35),
      starImageView.heightAnchor.constraint(equalToConstant: 35),
      starImageView.trailingAnchor.constraint(equalTo: averageLabel.leadingAnchor, constant: -8),
      starImageView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
    ])
  }

  private func activateConstraintsForAverageLabel() {
    averageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      averageLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -8),
      averageLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
    ])
  }
}
