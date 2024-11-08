//
//  TopicViewCell.swift
//  Cafeyn
//
//  Created by Ines BOKRI on 01/11/2024.
//

import UIKit

class TopicViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!

    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Functions
    func setupView(with topic: String, isFavorite: Bool = false) {
        if isFavorite {
            topicImageView.image = UIImage(named: "remove")
            topicImageView.tintColor = .red
            favoriteImageView.image = UIImage(named: "menu")
            favoriteImageView.tintColor = .lightGray
            favoriteImageView.isHidden = false
        } else {
            topicImageView.image = UIImage(named: "add")
            topicImageView.tintColor = .black
            favoriteImageView.isHidden = true
        }
        topicLabel.text = topic
    }
}
