//
//  CardDeckExt.swift
//  WildCards
//
//  Created by Ø on 03/07/2017.
//  Copyright © 2017 mainvolume. All rights reserved.
//

import UIKit

extension CardDeckVC {
    
    func addPanReconizer() {
        panning = UIPanGestureRecognizer(target: self, action: #selector(recognizerPanned(recognizer:)))
        self.view.addGestureRecognizer(panning)
    }
    
    func addTapReconizer() {
        tap = UITapGestureRecognizer(target: self, action: #selector(recognizerTapped(recognizer:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func  recognizerPanned(recognizer:UIPanGestureRecognizer) {
        let delta = recognizer.translation(in: self.view)
        
        switch recognizer.state {
        case .began:
            self.originPoint = self.view.center
        case .changed:
            self.updateCardView(withTranslation: delta)
        case .ended:
            self.resetCardView()
        default:
            break
        }
    }
    
    func  recognizerTapped(recognizer:UITapGestureRecognizer) {
        
        self.resetAndShowNext()
    }
    
    func updateCardView(withTranslation delta:CGPoint) {
        if delta.x < 0 {
            let rStrength = min(delta.x / (self.view.bounds.size.width / 2.0), 1)
            if fabs(rStrength) >= 1.0 {
                self.nextCardView()
            }else {
                self.updateFlipLeft(delta.x)
            }
            
        } else {
            
            let rStrength = min(delta.x / (self.view.bounds.size.width / 2.0), 1)
            if rStrength >= 1.0 {
                self.showCardBack()
            }else {
                self.updateFlipRight(delta.x)
                
            }
        }
    }
    
    func updateFlipLeft(_ delta:CGFloat) {
        let rStrength = min(delta / (self.view.bounds.size.width / 2), 1)
        let fullCircle = CGFloat.pi * 2
        
        let rotAngle:CGFloat = fullCircle * rStrength / 16
        let scaleStrength:CGFloat = 1.0 - fabs(rotAngle)
        
        let scale = max(scaleStrength, 0.93)
        let newX = self.originPoint.x + delta
        
        let t = CGAffineTransform.identity
        t.scaledBy(x: scale, y: scale)
        t.rotated(by: rotAngle)
        self.cardView.transform = t
        self.cardView.center = CGPoint(x: newX, y: self.cardView.center.y)
        
        
    }
    
    func updateFlipRight(_ delta:CGFloat) {
        let rStrength = min(delta / (self.view.bounds.size.width / 2), 2)
        let fullCircle = CGFloat.pi * 8
        
        let rotAngle:CGFloat = fullCircle * rStrength / 16
        let scaleStrength:CGFloat = rotAngle
        
        let scale = 1.0 - (scaleStrength / 16.0)
        let newX = self.originPoint.x + (delta / 2)
        self.cardView.center = CGPoint(x: newX, y: self.cardView.center.y)
        
        
        var ts = CATransform3DIdentity
        ts = CATransform3DMakeScale(scale, scale, scale)
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        self.cardView.layer.transform = ts
        CATransaction.commit()
        
        var tr = self.cardView.layer.transform
        tr.m34 =  -min(delta / (self.view.bounds.size.width / 2), 1)
        tr = CATransform3DRotate(ts, rotAngle, 0, 1, 0)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        self.cardView.layer.transform = tr
        CATransaction.commit()
        
    }
    
    func showCardBack() {
        for v in self.cardView.subviews {
            v.removeFromSuperview()
        }
        self.view.removeGestureRecognizer(self.panning)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.cardView.backgroundColor = UIColor.purple
            self.cardView.center = self.originPoint
            let t = CGAffineTransform.identity
            t.rotated(by: 0)
            t.scaledBy(x: 1, y: 1)
            self.cardView.transform = t
        }) { sucess in
            self.cardView.addSubview(CardViewBack(frame: self.cardView.frame) )
            self.addTapReconizer()
        }
        
    }
    
    func resetAndShowNext() {
        self.view.removeGestureRecognizer(tap)
        let r = self.createCardView()
        r.addSubview(self.cardViews.last!)
        let _ = self.cardViews.removeLast()
        r.center = self.view.center
        self.view.insertSubview(r, belowSubview: self.cardView)
        self.resetCardView()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.cardView.alpha = 0
        }) { success in
            self.cardView.removeFromSuperview()
            self.cardView = r
            self.addPanReconizer()
        }
    }
    
    func resetCardView() {
        UIView.animate(withDuration: 0.2) {
            self.cardView.center = self.originPoint
            let t = CGAffineTransform.identity
            t.rotated(by: 0)
            t.scaledBy(x: 1, y: 1)
            self.cardView.transform = t
        }
    }
    
    func nextCardView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.removeGestureRecognizer(self.panning)
            self.cardView.center = CGPoint(x: -self.cardView.bounds.width, y: self.cardView.center.y)
            
        }) { success in
            for v in self.cardView.subviews {
                v.removeFromSuperview()
            }
            if self.cardViews.count > 0 {
                self.cardView.addSubview(self.cardViews.last!)
                let _ = self.cardViews.removeLast()
            }
            
            UIView.animate(withDuration: 0.2) {
                self.addPanReconizer()
                self.cardView.backgroundColor = UIColor.cyan
                self.cardView.center = self.originPoint
                let t = CGAffineTransform.identity
                t.rotated(by: 0)
                t.scaledBy(x: 1, y: 1)
                self.cardView.transform = t
            }
        }
        
        
    }
    
    
    
}

extension CardDeckVC: Labler {
    func createCounter() -> UILabel {
        return makeLabel(withText: "Count : 0", rect: CGRect(origin: CGPoint(x: 20, y: 20) , size: CGSize(width: self.view.frame.size.width, height: 20)))
    }
}


extension CardDeckVC {
    
    func createCardView () -> UIView {
        let w = self.view.bounds.width * 0.8
        let h = self.view.bounds.height * 0.8
        let r = CGRect(x: 0, y: 0, width: w, height: h)
        
        let tempCard = UIView(frame: r)
        tempCard.backgroundColor = UIColor.cyan
        tempCard.layer.cornerRadius = 8.0
        tempCard.clipsToBounds = true
        return tempCard
    }
    
    func createFirstCardView () -> UIView {
        let v = self.createCardView()
        let loadLbl = makeLabel(withText: "loading. swipe to view", rect: CGRect(origin: CGPoint(x: 20.0, y: 0), size: v.bounds.size))
        v.addSubview(loadLbl)
        return v

    }
    
    func createCardView (withModel model:UserItem) -> UIView {
        
        let v = self.createCardView()
        let w = self.view.bounds.width * 0.8
        let h = self.view.bounds.height * 0.8
        let r = CGRect(x: 0, y: 0, width: w, height: h)
        
        let cv = CardViewFront(frame: r, model: model)
        v.addSubview(cv)
        return v
    }
    
}
