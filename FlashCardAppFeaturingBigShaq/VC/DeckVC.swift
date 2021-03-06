//
//  DeckVC.swift
//  FlashCardAppFeaturingBigShaq
//
//  Created by Richard Crichlow on 2/13/18.
//  Copyright © 2018 Richard Crichlow. All rights reserved.
//

import UIKit
import SnapKit

class DeckVC: UIViewController {
    
    // MARK: Values for data
    let deckView = DeckView()
    var arrayOfCards = [Card]() {
        didSet {
            if arrayOfCards.isEmpty {
                deckView.questionTextView.text = "No data in this deck"
            } else {
                loadCard()
            }
        }
    }
    var deck = "" // This is the deck's name a.k.a. category
    var currentCard = 0 //The index you're currently at in the deck
    public func injectADeck(deckname: String) {
        self.deck = deckname
    }
    
    // MARK: Values for animation
    var widthValue: CGFloat = 0
    var heightValue: CGFloat  = 0
    var xOffSet: CGFloat = 0
    var yOffSet: CGFloat = 0
    var startingPosition: CGRect = .zero {
        didSet {
            self.widthValue = startingPosition.width
            self.xOffSet = startingPosition.minX
            self.yOffSet = startingPosition.minY
            self.heightValue = startingPosition.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startingPosition = deckView.questionTextView.frame
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DatabaseService.manager.getAllFlashcardsByCategory(forUserID: (AuthUserService.manager.getCurrentUser()?.uid)!, andDeck: deck) { (Cards) in
            if let cards = Cards {
                self.arrayOfCards = cards
                
            } else {
                print("Couldn't get cards or there are no cards")
                //TODO: Maybe show an image of no data as a background
            }
        }
    }
    
    private func setupView() {
        self.view.addSubview(deckView)
        deckView.showAnswerButton.addTarget(self, action: #selector(showAnswerClicked), for: .touchUpInside)
        deckView.repeatButton.addTarget(self, action: #selector(repeatClicked), for: .touchUpInside)
        deckView.nextQuestionButton.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        deckView.previousButton.addTarget(self, action: #selector(previousClicked), for: .touchUpInside)
        
        
    }
    
    private func loadCard() {
        deckView.questionTextView.text = arrayOfCards[currentCard].question
        deckView.answerTextView.text = arrayOfCards[currentCard].answer
        navigationItem.title = self.deck
    }
    
    @objc private func showAnswerClicked() {
        
        UIView.animate(withDuration: 1.0, animations: {
            self.deckView.questionTextView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(CGFloat.pi)) / 180.0)
            self.deckView.questionTextView.alpha = 0.0
            self.deckView.containerView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.deckView.safeAreaLayoutGuide.snp.top)
                make.leading.equalTo(self.deckView.safeAreaLayoutGuide.snp.leading)
                make.trailing.equalTo(self.deckView.safeAreaLayoutGuide.snp.trailing)
                make.height.equalTo(self.deckView.safeAreaLayoutGuide.snp.height).multipliedBy(0.80)
            }
        })
    }
    @objc private func repeatClicked() {
        deckView.questionTextView.alpha = 1
        deckView.questionTextView.frame = startingPosition
        deckView.questionTextView.transform = CGAffineTransform(rotationAngle: (0))
        self.deckView.containerView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.deckView.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.deckView.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.deckView.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(self.deckView.safeAreaLayoutGuide.snp.height).multipliedBy(0.40)
        }
    }
    @objc private func nextClicked() {
        
        currentCard += 1
        if currentCard > arrayOfCards.count - 1 {
            let alert = Alert.create(withTitle: "End", andMessage: "End of Deck Reached", withPreferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            loadCard()
            repeatClicked()
        }
    }
    
    @objc private func previousClicked() {
        
        currentCard -= 1
        if currentCard < 0 {
            let alert = Alert.create(withTitle: "Beginning", andMessage: "Beginning of Deck Reached", withPreferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            loadCard()
            repeatClicked()
        }
    }
    
    
    
}
