//
//  EmptyTopicViewCell.swift
//  Cafeyn
//
//  Created by Ines BOKRI on 31/10/2024.
//

import UIKit

class EmptyTopicViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mainView: UIView!

    // MARK: - Initializer
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }
    
    // MARK: - Functions
    func setupView() {
        mainView.layer.cornerRadius = 10
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.clipsToBounds = true
    }
}
