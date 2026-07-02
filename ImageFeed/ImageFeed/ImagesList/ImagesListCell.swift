//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by никита  on 01.07.2026.
//

import Foundation
import UIKit
final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
}
