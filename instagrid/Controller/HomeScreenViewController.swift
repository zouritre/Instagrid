//
//  ViewController.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 18/02/2022.
//

import UIKit
import PhotosUI

// MARK: Protocols


extension HomeScreenViewController: PresentPhotoLibraryDelegate {

    func getPhotoPickerViewController(picker: PHPickerViewController) {
        picker.delegate = self

//        Present the picker on the main thread asynchronously
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.present(picker, animated: true)
        }

    }

    /// Display an alert on the screen
    /// - Parameter message: The message to be displayed in the alert
    func alert(message: String) {

        self.displayAlert(message: message)
    }
}

extension HomeScreenViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        dismiss(animated: true, completion: nil)

//        Get the selected asset
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)

//            Exit the function if no asset has been selected from photo library (asset returns nil)
        guard let asset = fetchResult.firstObject else {
            self.displayAlert(message: "User canceled or chosen photo has not been authorized from limited library")
            return
        }

        setButtonImage(asset: asset)
    }
}

extension UIViewController {
    /// Display an alert on the screen
    /// - Parameter message: The message to be displayed in the alert
    func displayAlert(message: String) {

        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

        DispatchQueue.main.async {

            self.present(alert, animated: true)
        }
    }
}
class HomeScreenViewController: UIViewController {

    // MARK: Variables

    @IBOutlet weak var instagridLabel: UILabel!
    @IBOutlet weak var swipeUp: UILabel!
    @IBOutlet weak var swipeLeft: UILabel!

    @IBOutlet weak var disposition1: UIStackView!
    @IBOutlet weak var disposition2: UIStackView!
    @IBOutlet weak var disposition3: UIStackView!

    @IBOutlet weak var showDispo1: UIButton!
    @IBOutlet weak var showDispo2: UIButton!
    @IBOutlet weak var showDispo3: UIButton!

    @IBOutlet weak var dispositionsGrid: UIView!
    @IBOutlet weak var grid: UIView!

    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!

    private var dispositionStackViews: [UIStackView] = []
    private var currentlySelectedDisposition: UIStackView!

    private var dispositionBottomButtons: [UIButton] = []
    private var tappedButton: UIButton!

    private var checkedIcon: UIImage = UIImage(named: "Selected")!
    private var photoLib = PhotoLibrary()

    /// Enable the StackView corresponding to the button tapped
    /// - Parameter tapGestureRecognizer: The UITapGestureRecognizer of the image tapped
    @IBAction func dispositionButtonTapped(sender: UIButton) {

        if let previousDisposition = currentlySelectedDisposition {

//            Hide the previously selected disposition grid
            previousDisposition.isHidden = true

//            Remove the checkmark from the previously selected button
            dispositionBottomButtons[previousDisposition.tag].setImage(UIImage(), for: .normal)

//            Enable the StackView (central grid) corresponding to the tapped image tag
            switch sender.tag {

            case 0: displaySelectedDisposition(target: 0)
            case 1: displaySelectedDisposition(target: 1)
            case 2: displaySelectedDisposition(target: 2)

            default: print("Couldn't load selected disposition")

            }
        } else {

            print("currentlySelectedDisposition var is nil")

        }

    }

    /// Open the device photo librairy
    /// - Parameter sender: The tapped UIButton
    @IBAction func openPhotoLibrary(_ sender: UIButton) {

        self.tappedButton = sender
        self.photoLib.presentPhotoLibraryDelegate = self
        self.photoLib.openLibrary()

    }

    // MARK: Grid swipe animation

    @IBAction func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {

        if gestureRecognizer.state == .ended {

            switch gestureRecognizer.direction {

            case .up:
                animateDispositionsGrid(direction: .up)
            case .left:
                animateDispositionsGrid(direction: .left)
            default:
                return
            }
        }
    }

    /// Animate the grid view and present an UIActivityViewController
    /// - Parameter directon: The direction of the swipe
    private func animateDispositionsGrid(direction: UISwipeGestureRecognizer.Direction) {

        UIView.animate(withDuration: 0.5) { [self] in

            if direction == .up {

                    makeGridTranslation(posX: CGFloat.zero, posY: -UIScreen.main.bounds.height/2)

            } else {

                makeGridTranslation(posX: -UIScreen.main.bounds.width/2, posY: CGFloat.zero)

            }

            dispositionsGrid.alpha = 0

        } completion: { [self] _ in

            let gridImage = convertUIViewToImage(view: grid)

            let activityViewController = UIActivityViewController.init(activityItems: [gridImage], applicationActivities: nil)

            activityViewController.completionWithItemsHandler = { _, _, _, _ in

                UIView.animate(withDuration: 0.5) { [self] in

                    makeGridTranslation(posX: 0, posY: 0)
                    dispositionsGrid.alpha = 1
                }
            }

            DispatchQueue.main.async {

                self.present(activityViewController, animated: true)
            }
        }
    }

    private func convertUIViewToImage(view: UIView) -> UIImage {

        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)

        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }

    /// Move the grid to the specific coordinates
    /// - Parameters:
    ///   - x: The x coordinate of the new view location
    ///   - y: The y coordinate of the new view location
    private func makeGridTranslation(posX: CGFloat, posY: CGFloat) {

        dispositionsGrid.transform = CGAffineTransform(translationX: posX, y: posY)
    }

    /// Constraint the swipe gesture in a specific direction according to the device orientation
    @objc private func getDeviceOrientation() {

        switch UIDevice.current.orientation {

        case .portrait:
            swipeGesture.direction = .up
        case .landscapeLeft, .landscapeRight:
            swipeGesture.direction = .left
        default:
            return

         }
    }

    // MARK: UI setup

    /// Set the tapped button background image to the selected image from photo librariry
    /// - Parameter asset: A  PHAsset object identifying a photo from librairy
    private func setButtonImage(asset: PHAsset) {

        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option, resultHandler: { (result, _) -> Void in

    //        Remove the middle cross on the button
            self.tappedButton.setImage(UIImage(), for: .normal)

            guard let result = result else {
                return
            }

            self.tappedButton.setBackgroundImage(result, for: .normal)
            self.tappedButton.layoutIfNeeded()
            self.tappedButton.subviews.first?.contentMode = .scaleAspectFill
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

    /// Group the different grid dispositions and the buttons to display these grids in two respective arrays
    private func groupUIelementsInArrays() {

        dispositionBottomButtons = [showDispo1, showDispo2, showDispo3]

        dispositionStackViews = [disposition1, disposition2, disposition3]

    }

    /// Define a default grid and his corresponding button at app start
    private func setDefaultGrid() {

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
