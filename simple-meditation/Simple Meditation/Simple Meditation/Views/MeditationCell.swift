//
//  MeditationCell.swift
//  Simple Meditation
//
//  Created by dev on 21.09.2025.
//

import UIKit

class MeditationCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Set cell text size and font based on user device settins
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0  // Allow wrapping if text gets big
    }
}
