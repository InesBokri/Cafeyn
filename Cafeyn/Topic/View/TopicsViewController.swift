//
//  TopicsViewController.swift
//  Cafeyn
//
//  Created by Ines BOKRI on 30/10/2024.
//

import UIKit

class TopicsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    private var viewModel = TopicsViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private var availableTopics = [String]()
    private var availableTopicsInitial = [String]()
    
    private var favoriteTopics = [String]()
    private var isSection0Visible: Bool = true

    // Dictionnaire pour stocker les index initiaux de chaque sujet, uniquement la première fois qu'ils sont déplacés
    var initialIndexes: [String: Int] = [:]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadTopics()
        setupTableView()
        setupActivityIndicator()
    }
    
    // MARK: - Functions
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "EmptyTopicViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "EmptyTopicViewCell")
        tableView.register(UINib(nibName: "TopicViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "TopicViewCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Center the activity indicator in the view
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadTopics() {
        activityIndicator.startAnimating()
        favoriteTopics = viewModel.loadFavoriteTopics()
        isSection0Visible = favoriteTopics.isEmpty
        viewModel.retrieveTopics { [weak self] topics, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let error = error {
                    // Affiche l'alerte en cas d'erreur
                    let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else if let topics = topics {
                    self.availableTopicsInitial = topics.map { $0.name.raw }

                    if self.favoriteTopics.isEmpty {
                        self.availableTopics = topics.map { $0.name.raw }
                    } else {
                        self.availableTopics = self.availableTopicsInitial.filter { !self.favoriteTopics.contains($0) }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        activityIndicator.stopAnimating()
    }
    
    private func moveToFavoriteTopic(at index: Int) {
        isSection0Visible = false
        let selectedTopic = availableTopics.remove(at: index)
        
        // Store initial index if not already stored
        if initialIndexes[selectedTopic] == nil {
            initialIndexes[selectedTopic] = availableTopicsInitial.firstIndex(of: selectedTopic)
        }
        
        favoriteTopics.append(selectedTopic)
    }
    
    private func moveToAvailableTopics(at index: Int) {
        // Moving a topic back to availableTopics
        if !favoriteTopics.isEmpty && favoriteTopics.indices.contains(index) {
            let removedTopic = favoriteTopics.remove(at: index)
            
            if let originalIndex = initialIndexes[removedTopic] {
                let safeIndex = min(originalIndex, availableTopics.count)
                availableTopics.insert(removedTopic, at: safeIndex)
            } else {
                availableTopics.append(removedTopic)
            }
        }
        
        // Sort availableTopics to match the order in availableTopicsInitial
        availableTopics.sort { topic1, topic2 in
            guard let index1 = availableTopicsInitial.firstIndex(of: topic1),
                  let index2 = availableTopicsInitial.firstIndex(of: topic2) else {
                return false
            }
            return index1 < index2
        }
        
        // Show EmptyTopicViewCell if favoriteTopics is empty
        isSection0Visible = favoriteTopics.isEmpty
    }
    
    // MARK: - IBActions
    @IBAction func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTopics() {
        viewModel.saveTopics(favoriteTopics)
    }
}

// MARK: - UITableViewDataSource
extension TopicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isSection0Visible ? 1 : favoriteTopics.count
        case 1:
            return availableTopics.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if !(favoriteTopics.isEmpty) {
                // Affiche le `TopicViewCell` pour le sujet sélectionné dans la section 0
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopicViewCell", for: indexPath) as? TopicViewCell else {
                    return UITableViewCell()
                }
                cell.setupView(with: favoriteTopics[indexPath.row],
                               isFavorite: true)
                
                return cell
            } else if isSection0Visible {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTopicViewCell", for: indexPath) as? EmptyTopicViewCell else {
                    return UITableViewCell()
                }
                return cell
            }
        } else if !(availableTopics.isEmpty) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopicViewCell", for: indexPath) as? TopicViewCell else {
                return UITableViewCell()
            }
            cell.setupView(with: availableTopics[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 && !(availableTopics.isEmpty) {
            let headerView = UIView()
            let label = UILabel()
            label.text = "À découvrir"
            label.textColor = .black
            label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0),
                label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
            ])
            
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            moveToFavoriteTopic(at: indexPath.row)
        } else if indexPath.section == 0 {
            moveToAvailableTopics(at: indexPath.row)
        }
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension TopicsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if !(favoriteTopics.isEmpty) {
                return 50
            } else if isSection0Visible {
                return 149
            }
        }
        return 50
    }
}

//MARK: - UITableViewDragDelegate
extension TopicsViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.section == 0 else { return [] }
        
        let item = self.favoriteTopics[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
}

// MARK: - UITableViewDropDelegate
extension TopicsViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard destinationIndexPath?.section == 0 else {
            return UITableViewDropProposal(operation: .cancel)
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        guard destinationIndexPath.section == 0 else { return }
        
        coordinator.items.forEach { item in
            guard let sourceIndexPath = item.sourceIndexPath else { return }
            
            tableView.performBatchUpdates({
                let movedItem = favoriteTopics.remove(at: sourceIndexPath.row)
                favoriteTopics.insert(movedItem, at: destinationIndexPath.row)
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }, completion: nil)
            
            coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
        }
    }
}
