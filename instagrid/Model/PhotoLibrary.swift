//
//  PhotoLibrary.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 24/02/2022.
//

import Foundation
import PhotosUI

protocol PresentPhotoLibraryDelegate: AnyObject {

    func getPhotoPickerViewController(picker: PHPickerViewController)
    func alert(message: String)

}

final class PhotoLibrary {

    weak var presentPhotoLibraryDelegate: PresentPhotoLibraryDelegate!
    private let pickerConfiguration: PHPickerConfiguration
    private let photoLibraryViewController: PHPickerViewController

    init() {

        self.pickerConfiguration = PHPickerConfiguration.init(photoLibrary: .shared())
        self.photoLibraryViewController = PHPickerViewController.init(configuration: self.pickerConfiguration)

    }

    /// Get the app authorization to access the device photo library
    func openLibrary() {
        let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch readWriteStatus {

        case .notDetermined:
            requestAuthorization()
        case .restricted:
            presentPhotoLibraryDelegate.alert(message: "Photo librairy access is prohibited on this device")
        case .denied:
            presentPhotoLibraryDelegate.alert(message: "You did not allow this app to access your photo librairy.")
        case .authorized, .limited:
            presentPhotoLibraryDelegate.getPhotoPickerViewController(picker: photoLibraryViewController)
        @unknown default:
            fatalError()
        }
    }

    /// Ask the user to set an authorization for the app to access the device photo library
    private func requestAuthorization() {

        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in

            switch status {

            case .notDetermined:
                self?.presentPhotoLibraryDelegate.alert(message: "You have to authorize access to your photo librairy")
            case .restricted:
                self?.presentPhotoLibraryDelegate.alert(message: "Photo librairy access is prohibited on this device")
            case .denied:
                self?.presentPhotoLibraryDelegate.alert(message: "You did not allow access your photo librairy.")
            case .authorized, .limited:
                guard let photoLibraryViewController = self?.photoLibraryViewController else {
                    return
                }
                self?.presentPhotoLibraryDelegate.getPhotoPickerViewController(picker: photoLibraryViewController)
            @unknown default:
                fatalError()

            }
        }
    }
}
