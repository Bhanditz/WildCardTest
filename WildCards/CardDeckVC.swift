//
//  ViewController.swift
//  WildCards
//
//  Created by Ø on 03/07/2017.
//  Copyright © 2017 mainvolume. All rights reserved.
//

import UIKit


class CardDeckVC: UIViewController {

    var carvView:UIView!
    var panning:UIPanGestureRecognizer!
    var originPoint:CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.carvView = createCardView()
        self.view.addSubview(self.carvView)
        self.addReconizer()
    }

    override func viewWillLayoutSubviews() {
        carvView.center = self.view.center
    }
    
    
    
    
    
}

