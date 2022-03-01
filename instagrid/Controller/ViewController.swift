//
//  ViewController.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 18/02/2022.
//

import UIKit
import PhotosUI


extension ViewController : presentPhotoLib {

    func getPhotoPickerVC(picker: PHPickerViewController) {
        picker.delegate = self
        
//        Present the picker on the main thread asynchronously
        DispatchQueue.main.async {
            self.present(picker, animated: true)
        }
        
    }
}


extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true, completion: nil)
        
//        Get the selected asset
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        
//            Exit the function if no asset has been selected from photo library (asset returns nil)
        guard let asset = fetchResult.firstObject else {
            print("User canceled or chosed a photo that has not been authorized from limited library")
            return
        }
        
        setButtonImage(asset: asset)
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
    
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    
    
    private var dispositionStackViews: [UIStackView] = []
    private var dispositionBottomButtons : [UIButton] = []
    private var currentlySelectedDisposition : UIStackView!
    private var checkedIcon : UIImage = UIImage(named: "Selected")!
    private var tappedButton : UIButton!

    private var photoLib = PhotoLibrairy()
    
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
    
    @IBAction func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
        
        if gestureRecognizer.state == .ended {
            
            print("swipped")
        }
    }
    
    
    /// Constraint the swipe gesture in a specific direction according to the device orientation
    @objc private func getDeviceOrientation(){
        
        
        switch UIDevice.current.orientation{
            
         case .portrait:
            swipeGesture.direction = .up
        case .landscapeLeft, .landscapeRight:
            swipeGesture.direction = .left
         default:
            return
            
         }
    }
    
    
    /// Set the tapped button background image to the selected image from photo librariry
    /// - Parameter asset: A  PHAsset object identifying a photo from librairy
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
    
    
    /// Group the different grid dispositions UI elements and the buttons to display these grids in two respective arrays
    private func groupUIelementsInArrays() {
        
        dispositionBottomButtons = [showDispo1, showDispo2, showDispo3]
        
        dispositionStackViews = [disposition1, disposition2, disposition3]
        
    }
    
    
    /// Define a default grid and his corresponding button at app start
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
        
//        Notify the controller when the device orientation change
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }


}

