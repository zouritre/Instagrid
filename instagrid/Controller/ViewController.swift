//
//  ViewController.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 18/02/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var instagridLabel: UILabel!
    @IBOutlet weak var swipeToShare: UILabel!
    
    @IBOutlet weak var dispo1: UIView!
    @IBOutlet weak var dispo2: UIView!
    @IBOutlet weak var dispo3: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instagridLabel.font = UIFont(name: "Thirsty soft", size: 45)
        swipeToShare.font = UIFont(name: "Delm", size: 26)
        
        
//        for family: String in UIFont.familyNames
//        {
//            print(family)
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
    }


}

