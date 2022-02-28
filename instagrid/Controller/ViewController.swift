//
//  ViewController.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 18/02/2022.
//

import UIKit
import PhotosUI


extension ViewController : presentPhotoLib {

    func getFullLibrairyVC(vc: PHPickerViewController) {
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    func getLimitedLibrairy(sharedLib : PHPhotoLibrary){
        sharedLib.presentLimitedLibraryPicker(from: self)
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        if fetchResult.count >= 1 {
            
            setButtonImage(asset: fetchResult.firstObject!)
        }
    }
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var instagridLabel: UILabel!
    @IBOutlet weak var swipeUp: UILabel!
    @IBOutlet weak var swipeLeft: UILabel!    
    
    @IBOutlet weak var disposition1: UIStackView!
    @IBOutlet weak var disposition2: UIStackView!
    @IBOutlet weak var disposition3: UIStackView!
    
    @IBOutlet weak var showDispo1: UIButton!
    @IBOutlet weak var showDispo2: UIButton!
    @IBOutlet weak var showDispo3: UIButton!
    
    private var dispositionStackViews: [UIStackView] = []
    private var dispositionBottomButtons : [UIButton] = []
    private var currentlySelectedDisposition : UIStackView!
    private var checkedIcon : UIImage = UIImage(named: "Selected")!
    private var tappedButton : UIButton!

    private var photoLib: PhotoLibrairy = PhotoLibrairy()
    
    /// Enable the StackView corresponding to the button tapped
    /// - Parameter tapGestureRecognizer: The UITapGestureRecognizer of the image tapped
    @IBAction func dispositionButtonTapped(sender: UIButton)
    {
        
        if let previousDisposition = currentlySelectedDisposition {

//            Hide the previously selected disposition grid
            previousDisposition.isHidden = true
            
//            Remove the checkmark from the previously selected button
            dispositionBottomButtons[previousDisposition.tag].setImage(UIImage(), for: .normal)
            
//            Enable the StackView (central grid) corresponding to the tapped image tag
            switch sender.tag{

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
    
    
    /// Open the device photo librairy
    /// - Parameter sender: The tapped UIButton
    @IBAction func addImage(_ sender: UIButton) {
        
        self.tappedButton = sender
        self.photoLib.presentPhotoLibDelegate = self
        self.photoLib.openLibrairy()
        
    }
    
    
    /// Set the tapped button background image to the selected image from photo librariry
    /// - Parameter asset: A single PHAsset containing a photo from librairy
    private func setButtonImage(asset: PHAsset) {
        
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, _)->Void in
            
    //        Remove the middle cross on the button
            self.tappedButton.setImage(UIImage(), for: .normal)
            
            self.tappedButton.setBackgroundImage(result!, for: .normal)
        })
        
        
    }
    
    /// Display the selected grid
    private func displaySelectedDisposition (target: Int) {
        
            
//        Show the grid corresponding to the image tapped
        dispositionStackViews[target].isHidden = false
        
//        Store the newly selected grid in a variable
        currentlySelectedDisposition = dispositionStackViews[target]
        
//        Add a checkmark to the tapped image
        dispositionBottomButtons[target].setImage(checkedIcon, for: .normal)
        
        
    }
    
    
    private func groupUIelementsInArrays() {
        
        dispositionBottomButtons = [showDispo1, showDispo2, showDispo3]
        
        dispositionStackViews = [disposition1, disposition2, disposition3]
        
    }
    
    
    private func setDefaultGrid(){
        
        
        currentlySelectedDisposition = dispositionStackViews[0]
        
        dispositionBottomButtons[0].setImage(checkedIcon, for: .normal)
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Manually set fonts for labels because these custom fonts won't display in storyboard for unknown reasons
        instagridLabel.font = UIFont(name: "Thirsty soft", size: 45)
        
        swipeUp.font = UIFont(name: "Delm", size: 26)
        swipeLeft.font = UIFont(name: "Delm", size: 26)

        groupUIelementsInArrays()

        setDefaultGrid()
        
    }


}

