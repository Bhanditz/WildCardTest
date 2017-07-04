//
//  ViewController.swift
//  WildCards
//
//  Created by Ø on 03/07/2017.
//  Copyright © 2017 mainvolume. All rights reserved.
//

import UIKit


class CardDeckVC: UIViewController {
    
    var cardView:UIView!
    var panning:UIPanGestureRecognizer!
    var tap:UITapGestureRecognizer!
    var originPoint:CGPoint!
    var cardViews:[UIView]! {
        didSet {
            if let x = self.countLabel {
                x.text = "Count: \(cardViews.count)"
            }
        }
    }
    let manager = ModelManager()
    var countLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardViews = []
        self.addPanReconizer()
        self.cardView = createCardView()
        self.view.addSubview(self.cardView)
        self.countLabel = createCounter()
        self.view.addSubview(self.countLabel)
        
        manager.loadData()
        manager.onNewModel = { [weak self] model in
            guard let `self` = self else { return }
            DispatchQueue.main.async { [unowned self] in
                let v = self.createCardView(withModel: model)
                self.cardViews.append(v)
            }
            
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        self.cardView.center = self.view.center
    }
    
    
    
    
    
}

