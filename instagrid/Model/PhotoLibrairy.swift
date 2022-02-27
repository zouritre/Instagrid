//
//  PhotoLibrairy.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 24/02/2022.
//

import Foundation
import PhotosUI

@objc protocol presentPhotoLib {
//    var fullPhotoLibVC : UIViewController {get set}
    @objc optional func getFullLibrairyVC(vc: PHPickerViewController)
    @objc optional func getLimitedLibrairy(sharedLib : PHPhotoLibrary)
}

class PhotoLibrairy {
    
    
    var presentFullPhotoLibDelegate : presentPhotoLib!
    let photoLibConfig : PHPhotoLibrary
    let pickerConfiguration : PHPickerConfiguration
    let photoLibrairyVC : PHPickerViewController
    
    init(){
        self.photoLibConfig = PHPhotoLibrary.shared()
        self.pickerConfiguration = PHPickerConfiguration.init(photoLibrary: self.photoLibConfig)
        self.photoLibrairyVC = PHPickerViewController.init(configuration: self.pickerConfiguration)
    }
    
    internal func openLibrairy (){
        
        
        let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch readWriteStatus {

        case .notDetermined:
            requestAuthorization()
        case .restricted:
            alert(message: "This app can't access the photo librairy on this device")
        case .denied:
            self.alert(message: "You did not allow this app to access your photo librairy. You can change that in Settings")
        case .authorized:
            presentFullPhotoLibDelegate.getFullLibrairyVC!(vc: photoLibrairyVC)
        case .limited:
            presentFullPhotoLibDelegate.getLimitedLibrairy!(sharedLib: photoLibConfig)
        @unknown default:
            fatalError()
        }
    }
    
    private func requestAuthorization(){
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite){ [self] status in
                print(status)
            switch status {
            case .notDetermined:
                self.alert(message: "To add an image the app needs to have acces to your photo librairy")
            case .restricted:
                self.alert(message: "This app can't access the photo librairy on this device")
            case .denied:
                self.alert(message: "You did not allow this app to access your photo librairy. You can change that in Settings")
            case .authorized:
                presentFullPhotoLibDelegate.getFullLibrairyVC!(vc: photoLibrairyVC)
            case .limited:
                presentFullPhotoLibDelegate.getLimitedLibrairy!(sharedLib: photoLibConfig)
            @unknown default:
                fatalError()

            }
        }
    }
    
    
    private func alert(message: String){
        print(message)
        
    }
    
}
