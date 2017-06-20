//
//  Slide.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 19/04/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class Slide: UIView {

    @IBOutlet weak var label: UILabel!
    
    static func create(_ text: String, height: CGFloat, owner: Any?) -> Slide {
        let slide = Bundle.main.loadNibNamed("Slide", owner: owner, options: nil)?.first as! Slide
        slide.label.text = text
        slide.label.numberOfLines = Int(height / 21)
        return slide
    }
}
