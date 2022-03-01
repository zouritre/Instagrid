//
//  PhotoLibrairy.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 24/02/2022.
//

import Foundation
import PhotosUI

protocol presentPhotoLib {
    
    func getPhotoPickerVC(picker: PHPickerViewController)
    
}

class PhotoLibrairy {
    
    
    var presentPhotoLibDelegate : presentPhotoLib!
    let pickerConfiguration : PHPickerConfiguration
    let photoLibraryVC : PHPickerViewController
    
    init(){
        
        self.pickerConfiguration = PHPickerConfiguration.init(photoLibrary: .shared())
        self.photoLibraryVC = PHPickerViewController.init(configuration: self.pickerConfiguration)
        
    }
    
    /// Get the app authorization to access the device photo library
    internal func openLibrairy (){
        
        
        let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch readWriteStatus {

        case .notDetermined:
            requestAuthorization()
        case .restricted:
            alert(message: "This app can't access the photo librairy on this device")
        case .denied:
            self.alert(message: "You did not allow this app to access your photo librairy. You can change that in Settings")
        case .authorized, .limited:
            presentPhotoLibDelegate.getPhotoPickerVC(picker: photoLibraryVC)
        @unknown default:
            fatalError()
        }
    }
    
    /// Ask the user to set an authorization for the app to access the device photo library
    private func requestAuthorization(){
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite){ [self] status in
            
            switch status {
                
            case .notDetermined:
                alert(message: "To add an image the app needs to have acces to your photo librairy")
            case .restricted:
                alert(message: "This app can't access the photo librairy on this device")
            case .denied:
                alert(message: "You did not allow this app to access your photo librairy. You can change that in Settings")
            case .authorized, .limited:
                presentPhotoLibDelegate.getPhotoPickerVC(picker: photoLibraryVC)
            @unknown default:
                fatalError()

            }
        }
    }
    
    
    /// Display an alert on the screen
    /// - Parameter message: The message to be displayed in the alert
    private func alert(message: String){
        print(message)
        
    }
    
}
