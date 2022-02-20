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
    
    @IBOutlet weak var disposition1: UIStackView!
    @IBOutlet weak var disposition2: UIStackView!
    @IBOutlet weak var disposition3: UIStackView!
    
    @IBOutlet weak var showDispo1: UIImageView!
    @IBOutlet weak var showDispo2: UIImageView!
    @IBOutlet weak var showDispo3: UIImageView!
    
    private var currentlySelectedDisposition : UIStackView!
    
    
    private func setTapRecognizerOnDispositionImages() {
        

        let dispositionImageViews : [UIImageView] = [showDispo1!, showDispo2!, showDispo3!]

        for element in dispositionImageViews {
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            
            element.isUserInteractionEnabled = true
            element.addGestureRecognizer(tapGestureRecognizer)

        }
        
        currentlySelectedDisposition = disposition1

    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        if let previousDisposition = currentlySelectedDisposition {


            previousDisposition.isHidden = true

            let tappedImage = tapGestureRecognizer.view as! UIImageView

            switch tappedImage.tag{

            case 0: disposition1.isHidden = false; currentlySelectedDisposition = disposition1
            case 1: disposition2.isHidden = false; currentlySelectedDisposition = disposition2
            case 2: disposition3.isHidden = false; currentlySelectedDisposition = disposition3

            default: print("Couldn't load selected disposition")

            }

        }

        else {

            print("currentlySelectedDisposition var is nil")

        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instagridLabel.font = UIFont(name: "Thirsty soft", size: 45)
        
        swipeToShare.font = UIFont(name: "Delm", size: 26)
        
        setTapRecognizerOnDispositionImages()

        
    }


}

