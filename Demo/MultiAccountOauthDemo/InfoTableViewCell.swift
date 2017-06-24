
//
//  InfoTableViewCell.swift
//  MultiAccountOauthDemo
//
//  Created by Li Kedan on 6/23/17.
//  Copyright © 2017 Thywis inc. All rights reserved.
//

import UIKit
import MultiAccountOauth
import RandomColorSwift

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profile: UIImageView!

    let badProfilePicture = "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg"
    
    func setDisplay(user: GoogleUserInstance) {
        
        name.text = user.name
        email.text = user.email
        
        if user.profile != badProfilePicture {
            let url = URL(string: user.profile)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                profile.image = image
            }
        } else {
            let image = getUserLabel(name: user.name)
            profile.image = image
        }
        
        profile.layer.cornerRadius = profile.frame.width / 2
        profile.clipsToBounds = true
    }
    
    func getUserLabel(name: String) -> UIImage {
        
        let color = RandomColorSwift.randomColor(hue: .value(email.hashValue % 360) , luminosity: .dark)
        return textToImage(char: "\(name.characters.first!)".uppercased(), size: CGSize(width: 200, height: 200), ratio: 0.6, bgColor: color)

    }
 
    func textToImage(char: String, size: CGSize, ratio: CGFloat, bgColor: UIColor) -> UIImage {
        
        let textColor = UIColor.white
        let textFont = UIFont(name: "Avenir-Heavy", size: size.width * ratio)!
        
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        view.backgroundColor = bgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = size.width / 2
        
        let label = UILabel(frame: CGRect(origin: CGPoint(x: size.width * (1 - ratio) / 2, y: size.width * (1 - ratio) / 2), size: CGSize(width: size.width * ratio, height: size.width * ratio)))
        label.font = textFont
        label.textColor = textColor
        label.text = char
        label.textAlignment = NSTextAlignment.center
        view.addSubview(label)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!.cgImage!)
    }
    
}
