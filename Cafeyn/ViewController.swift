//
//  ViewController.swift
//  Cafeyn
//
//  Created by Ines BOKRI on 30/10/2024.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOulet
    @IBOutlet weak var redirectionTopicButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Functions
    private func setupUI() {
        redirectionTopicButton.layer.cornerRadius = 5
        redirectionTopicButton.layer.borderWidth = 1
        redirectionTopicButton.clipsToBounds = true
    }

    // MARK: - IBAction
    @IBAction func goToTopicsView() {
        let storyboard = UIStoryboard(name: "TopicsViewController", bundle: nil)
        let topicsVC = storyboard.instantiateViewController(withIdentifier: "TopicsViewController")
        topicsVC.modalPresentationStyle = .fullScreen
        self.present(topicsVC, animated: true)
    }
}

