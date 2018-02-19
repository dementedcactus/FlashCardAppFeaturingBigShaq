//
//  AddCardVC.swift
//  FlashCardAppFeaturingBigShaq
//
//  Created by Richard Crichlow on 2/18/18.
//  Copyright © 2018 Richard Crichlow. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController {

    let addCardView = AddCardView()
    
    let categories = ["Advice", "AMA", "Animals", "Art", "Beauty", "Books", "Business", "Cats", "Celebs", "Cooking", "Cosplay", "Cute", "Dating", "Drugs", "Dogs", "Education", "ELI5", "Entertainment", "Fashion", "Fitness", "FML", "Food", "Funny", "Health", "Hmm", "Hobbies", "IRL", "LGBTQ+", "Lifestyle", "Memes", "MFW", "MLIA", "Music", "Movies", "Nature", "News", "NSFW", "Other", "Poetry", "Politics", "Random", "Religion", "Relationships", "Science", "Sex", "Sports", "Stories", "Tech", "TFW", "Thirst Traps", "THOT Stuff", "THOT Thoughts", "Throwback", "Travel", "TV", "Weird", "Women", "Work", "World", "WTF"]
    
    let sampleDecks: [Deck] = [Deck(name: "Trees", numberOfCards: 5, cards: nil), Deck(name: "Wanada", numberOfCards: 15, cards: nil), Deck(name: "MergeSort", numberOfCards: 9, cards: nil)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addCardView.availableDecksTableView.dataSource = self
        addCardView.availableDecksTableView.delegate = self
        addCardView.decksToPickFromButton.addTarget(self, action: #selector(availableDecksButtonAction), for: .touchUpInside)
        addCardView.categoryTableView.dataSource = self
        addCardView.categoryTableView.delegate = self
        addCardView.categoryButton.addTarget(self, action: #selector(categoryButtonAction), for: .touchUpInside)
        
    }
    
    @objc private func availableDecksButtonAction(sender: UIButton!) {
        print("Button tapped")
        if addCardView.availableDecksTableView.isHidden == true {
            addCardView.availableDecksTableView.isHidden = false
            animateAvailableDecksTV()
        } else {
            addCardView.availableDecksTableView.isHidden = true
        }
    }
    
    func animateAvailableDecksTV() {
        addCardView.availableDecksTableView.reloadData()
        let cells = addCardView.availableDecksTableView.visibleCells
        let tableViewHeight = addCardView.availableDecksTableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: -tableViewHeight)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    @objc private func categoryButtonAction(sender: UIButton!) {
        print("Button tapped")
        if addCardView.categoryTableView.isHidden == true {
            addCardView.categoryTableView.isHidden = false
            animateCategoryTV()
        } else {
            addCardView.categoryTableView.isHidden = true
        }
    }
    
    func animateCategoryTV() {
        addCardView.categoryTableView.reloadData()
        let cells = addCardView.categoryTableView.visibleCells
        let tableViewHeight = addCardView.categoryTableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: -tableViewHeight)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .clear
        view.addSubview(addCardView)
        addCardView.dismissView.addTarget(self, action: #selector(dismissViewAction), for: .touchUpInside)
    }
    
    @objc func dismissViewAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
extension AddCardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return sampleDecks.count
        } else {
            return categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var displaycell = UITableViewCell()
        
        if tableView == self.addCardView.availableDecksTableView {
            var cell:CustomTableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath) as? CustomTableViewCell
            let deck = sampleDecks[indexPath.row]
            cell!.deckLabel.text = " \(deck.name)"
            displaycell = cell!
            
        } else if tableView == self.addCardView.categoryTableView {
            var cell:CategoryTableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryTableViewCell
            
            let category = categories[indexPath.row]
            cell!.categoryLabel.text = "\(category)"
            displaycell = cell!
        }
        
        return displaycell
    }
    
}
extension AddCardVC: UITableViewDelegate {
    
}
