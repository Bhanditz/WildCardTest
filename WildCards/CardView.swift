//
//  CardView.swift
//  WildCards
//
//  Created by Ø on 04/07/2017.
//  Copyright © 2017 mainvolume. All rights reserved.
//

import UIKit

protocol Labler {
    func makeLabel(withText text:String, rect:CGRect) -> UILabel
}

extension Labler {
     func makeLabel(withText text:String, rect:CGRect) -> UILabel {
        let label = UILabel(frame: rect)
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.numberOfLines = 2
        return label
    }
}


extension CardViewFront {
    
    func makeAvatarView() -> UIView {
        
        let v = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.width, height: self.bounds.height / 2)))
        v.layer.masksToBounds = true
        
        let vd = UIView(frame:v.bounds)
        vd.backgroundColor = UIColor.black
        vd.alpha = 0.55
        
        let imageView = UIImageView(frame: v.bounds)
        imageView.center.x = self.center.x
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let miniImage = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: v.frame.size.width * 0.55 , height: v.frame.size.width * 0.55)))
        miniImage.center.x = self.center.x
        miniImage.layer.masksToBounds = true
        miniImage.layer.cornerRadius = miniImage.frame.size.width / 2
        miniImage.center = imageView.center
        miniImage.contentMode = .scaleAspectFill
        miniImage.layer.borderColor = UIColor.white.cgColor
        miniImage.layer.borderWidth = 5
        
        if let image = item.imageData?[0] {
            imageView.image = UIImage(data: image)
            miniImage.image = UIImage(data: image)
        } else {
            //  placeholder
        }
        
        
        
        
        v.addSubview(imageView)
        v.addSubview(vd)
        v.addSubview(miniImage)
        return v
    }
}

extension CardViewFront: Labler {
    
    func makeData() -> UIView {
        
        let v = UIView(frame: CGRect(origin: CGPoint.init(x: 0, y: self.bounds.height / 2) , size: CGSize(width: self.bounds.width, height: self.bounds.height / 2)))
        
        let spacing = v.frame.size.height / 6
        let size = CGSize(width: v.frame.size.width, height: spacing)
        var idx:CGFloat = 0.0
        let xMargin:CGFloat = 20.0
        
        let nameLbl = makeLabel(withText: "Name: " + item.fullname!, rect: CGRect(origin: CGPoint(x: xMargin, y: spacing * idx), size: size))
        idx += 1
        v.addSubview(nameLbl)
        
        
        let ageLbl = makeLabel(withText: "Age: \(item.age!)", rect: CGRect(origin: CGPoint(x: xMargin, y: spacing * idx), size: size))
        idx += 1
        v.addSubview(ageLbl)
        
        let cityLbl = makeLabel(withText: "City: " + item.city!, rect: CGRect(origin: CGPoint(x: xMargin, y: spacing * idx), size: size))
        idx += 1
        v.addSubview(cityLbl)
        
        let profLbl = makeLabel(withText: "Profession: " + item.job! ,rect: CGRect(origin: CGPoint(x: xMargin, y: spacing * idx), size: size))
        idx += 1
        v.addSubview(profLbl)
        
        
        var smoker = "No"
        if item.smoker! {
            smoker = "Yes"
        }
        let smokesLbl = makeLabel(withText: "Smokes: " + smoker, rect: CGRect(origin: CGPoint(x: xMargin, y: spacing * idx), size: size))
        idx += 1
        v.addSubview(smokesLbl)
        
        var kids = "No"
        if item.wishChildren! {
            kids = "Yes"
        }
        let kidsLbl = makeLabel(withText: "Whishes kids: " + kids, rect: CGRect(origin: CGPoint(x: xMargin, y: spacing * idx), size: size))
        idx += 1
        v.addSubview(kidsLbl)
        
        return v
    }
    
    
}



class CardViewFront: UIView {
    
    var item:UserItem
    
    init(frame: CGRect, model:UserItem) {
        self.item = model
        super.init(frame: frame)
        self.configureData()
        self.configureImageView()
        
    }
    
    
    func configureImageView() {
        self.addSubview(makeAvatarView())
    }
    
    func configureData() {
        let d = makeData()
        self.addSubview(d)
        self.bringSubview(toFront: d)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CardViewBack:Labler {
    func makeMock() -> UIView {
        let v = UIView(frame: CGRect(origin: CGPoint.zero , size: CGSize(width: self.bounds.width, height: self.bounds.height)))
        let mockLbl = makeLabel(withText: "This is a Mock\nTap to exit", rect: v.bounds)
        mockLbl.textColor = UIColor.white
        v.addSubview(mockLbl)
        return v
    }
}


class CardViewBack: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview( self.makeMock() )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
