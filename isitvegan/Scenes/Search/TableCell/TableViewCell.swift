//
//  TableViewCell.swift
//  isitvegan
//
//  Created by Ruben on 19/06/2019.
//  Copyright © 2019 Ruben Schmidmeister. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    let nameLabel: UILabel = UILabel()
    let stateLabel: UILabel = UILabel()
    let stateImage: UIImageView = UIImageView()
    let eNumberLabel: UILabel = UILabel()

    var stateImageName: String! {
        didSet {
            stateImage.image = UIImage(systemName: stateImageName)
        }
    }

    var stateColor: UIColor! {
        didSet {
            stateImage.tintColor = stateColor
            stateLabel.textColor = stateColor
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.font = stateLabel.font.withSize(14)

        stateImage.translatesAutoresizingMaskIntoConstraints = false

        eNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        eNumberLabel.textColor = .secondaryLabel
        eNumberLabel.font = eNumberLabel.font.withSize(14)

        contentView.addSubview(nameLabel)
        contentView.addSubview(stateLabel)
        contentView.addSubview(stateImage)
        contentView.addSubview(eNumberLabel)

        contentView.addConstraints([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: stateLabel.leadingAnchor, constant: -10),
            eNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            eNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            eNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stateLabel.trailingAnchor.constraint(equalTo: stateImage.leadingAnchor, constant: -2),
            stateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stateImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stateImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
