//
//  ViewController.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 18/02/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var instagridLabel: UILabel!
    @IBOutlet weak var swipeUp: UILabel!
    @IBOutlet weak var swipeLeft: UILabel!
    
    @IBOutlet weak var disposition1: UIStackView!
    @IBOutlet weak var disposition2: UIStackView!
    @IBOutlet weak var disposition3: UIStackView!
    
    @IBOutlet weak var showDispo1: UIImageView!
    @IBOutlet weak var showDispo2: UIImageView!
    @IBOutlet weak var showDispo3: UIImageView!
    
    private var dispositionStackViews: [UIStackView] = []
    private var dispositionImageViews : [UIImageView] = []
    
    private var currentlySelectedDisposition : UIStackView!
    
    private var checkedIcon : UIImage = UIImage(named: "Selected")!
    
    
    /// Make every disposition images tappable like buttons
    private func setTapRecognizerOnDispositionImages() {
        
        
        for element in dispositionImageViews {
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            
//            Make every images tappable
            element.isUserInteractionEnabled = true
            element.addGestureRecognizer(tapGestureRecognizer)

        }
        

    }

    
    /// Enable the StackView corresponding to the button tapped
    /// - Parameter tapGestureRecognizer: The UITapGestureRecognizer of the image tapped
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        if let previousDisposition = currentlySelectedDisposition {

//            Hide the previously selected disposition grid
            previousDisposition.isHidden = true
            
//            Remove the checkmark from the previously tapped image
            dispositionImageViews[previousDisposition.tag].isHighlighted = false

            let tappedImage = tapGestureRecognizer.view as! UIImageView

//            Enable the StackView (central grid) corresponding to the tapped image tag
            switch tappedImage.tag{

            case 0: displaySelectedDisposition(target: 0)
            case 1: displaySelectedDisposition(target: 1)
            case 2: displaySelectedDisposition(target: 2)

            default: print("Couldn't load selected disposition")

            }

        }

        else {

            print("currentlySelectedDisposition var is nil")

        }

    }
    
    
    /// Display the selected grid
    private func displaySelectedDisposition (target: Int) {
        
//        Show the grid corresponding to the image tapped
        dispositionStackViews[target].isHidden = false
        
//        Store the newly selected grid in a variable
        currentlySelectedDisposition = dispositionStackViews[target]
        
//        Add a checkmark to the tapped image
        dispositionImageViews[target].isHighlighted = true
        
    }
    
    
    private func groupUIelementsInArrays() {
        
        dispositionImageViews = [showDispo1, showDispo2, showDispo3]
        
        dispositionStackViews = [disposition1, disposition2, disposition3]
        
    }
    
    
    private func setHighlightedImageOnDispositionImages (){
        
        
        for element in dispositionImageViews {
            
            element.highlightedImage = checkedIcon

        }
    }
    
    
    private func setDefaultGrid(){
        
        
        currentlySelectedDisposition = dispositionStackViews[0]
        
        dispositionImageViews[0].isHighlighted = true
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Manually set fonts for labels because these custom fonts won't display in storyboard for unknown reasons
        instagridLabel.font = UIFont(name: "Thirsty soft", size: 45)
        
        swipeUp.font = UIFont(name: "Delm", size: 26)
        swipeLeft.font = UIFont(name: "Delm", size: 26)

        groupUIelementsInArrays()

        setTapRecognizerOnDispositionImages()

        setHighlightedImageOnDispositionImages()

        setDefaultGrid()
        
        
    }


}

