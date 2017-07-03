//
//  CardDeckExt.swift
//  WildCards
//
//  Created by Ø on 03/07/2017.
//  Copyright © 2017 mainvolume. All rights reserved.
//

import UIKit

extension CardDeckVC {
    
    func addReconizer() {
        panning = UIPanGestureRecognizer(target: self, action: #selector(recognizerPanned(recognizer:)))
        self.view.addGestureRecognizer(panning)
    }
    
    func  recognizerPanned(recognizer:UIPanGestureRecognizer) {
        let delta = recognizer.translation(in: self.view)
        
        switch recognizer.state {
        case .began:
            self.originPoint = self.view.center
        case .changed:
            self.updateCardView(withTranslation: delta)
        case .ended:
            self.resetCarvView()
        default:
            break
        }
    }
    
    func updateCardView(withTranslation delta:CGPoint) {
        if delta.x < 0 {
            let rStrength = min(delta.x / (self.view.bounds.size.width / 2.0), 1)
            print(rStrength)
            if fabs(rStrength) >= 1.0 {
                self.nextCardView()
            }else {
                self.updateFlipLeft(delta.x)
            }
            
        } else {
            
            let rStrength = min(delta.x / (self.view.bounds.size.width / 2.0), 1)
            if rStrength >= 1.0 {
                self.showPurpleCard()
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
        self.carvView.transform = t
        self.carvView.center = CGPoint(x: newX, y: self.carvView.center.y)
        
        
    }
    
    func updateFlipRight(_ delta:CGFloat) {
        let rStrength = min(delta / (self.view.bounds.size.width / 2), 2)
        let fullCircle = CGFloat.pi * 8
        
        let rotAngle:CGFloat = fullCircle * rStrength / 16
        let scaleStrength:CGFloat = rotAngle
        
        let scale = 1.0 - (scaleStrength / 16.0)
        let newX = self.originPoint.x + (delta / 2)
        self.carvView.center = CGPoint(x: newX, y: self.carvView.center.y)
        
        
        var ts = CATransform3DIdentity
        ts = CATransform3DMakeScale(scale, scale, scale)
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        self.carvView.layer.transform = ts
        CATransaction.commit()
        
        var tr = self.carvView.layer.transform
        tr.m34 =  -min(delta / (self.view.bounds.size.width / 2), 1)
        tr = CATransform3DRotate(ts, rotAngle, 0, 1, 0)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        self.carvView.layer.transform = tr
        CATransaction.commit()
        
    }
    
    func showPurpleCard() {
        UIView.animate(withDuration: 0.2) {
            self.carvView.backgroundColor = UIColor.purple
            self.carvView.center = self.originPoint
            let t = CGAffineTransform.identity
            t.rotated(by: 0)
            t.scaledBy(x: 1, y: 1)
            self.carvView.transform = t
            self.view.removeGestureRecognizer(self.panning)
        }
    }
    
    func resetCarvView() {
        UIView.animate(withDuration: 0.2) {
            self.carvView.center = self.originPoint
            let t = CGAffineTransform.identity
            t.rotated(by: 0)
            t.scaledBy(x: 1, y: 1)
            self.carvView.transform = t
        }
    }
    
    func nextCardView() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.removeGestureRecognizer(self.panning)
            self.carvView.center = CGPoint(x: -self.carvView.bounds.width, y: self.carvView.center.y)
        }) { success in
            UIView.animate(withDuration: 0.2) {
                self.addReconizer()
                self.carvView.backgroundColor = UIColor.cyan
                self.carvView.center = self.originPoint
                let t = CGAffineTransform.identity
                t.rotated(by: 0)
                t.scaledBy(x: 1, y: 1)
                self.carvView.transform = t
            }
        }
        
        
    }
    
    
    
}


extension CardDeckVC {
    
    func createCardView () -> UIView {
        let w = self.view.frame.width * 0.8
        let h = self.view.frame.height * 0.8
        let r = CGRect(x: 0, y: 0, width: w, height: h)
        
        let tempCard = UIView(frame: r)
        tempCard.backgroundColor = UIColor.cyan
        tempCard.layer.cornerRadius = 8.0
        
        return tempCard
    }
    
}
