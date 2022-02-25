//
//  PhotoLibrairy.swift
//  instagrid
//
//  Created by Bertrand Dalleau on 24/02/2022.
//

import Foundation
import PhotosUI

class PhotoLibrairy {
    
    let mainVC : UIViewController
//    let photoLibConfig : PHPhotoLibrary
//    let pickerConfiguration : PHPickerConfiguration
//    let photoLibrairyVC : PHPickerViewController
    
    init(mainVC: UIViewController){
        
        self.mainVC = mainVC
//        self.photoLibConfig = PHPhotoLibrary()
//        self.pickerConfiguration = PHPickerConfiguration.init(photoLibrary: self.photoLibConfig)
//        self.photoLibrairyVC = PHPickerViewController.init(configuration: self.pickerConfiguration)
    }
    
    internal func openLibrairy (){
        
        
        let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch readWriteStatus {
            
        case .notDetermined:
            requestAuthorization()
        case .restricted:
            alert(message: "This app can't access the photo librairy on this device")
        case .denied:
            alert(message: "You did not allow this app to access your photo librairy. You can change that in Settings")
        case .authorized:
            print("auth")
            mainVC.present(PHPickerViewController.init(configuration: PHPickerConfiguration.init(photoLibrary: PHPhotoLibrary.init())), animated: true, completion: nil)
        case .limited:
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: mainVC)
        @unknown default:
            fatalError()
        }
    }
    
    private func requestAuthorization (){
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            
            switch status {
            case .notDetermined:
                self.alert(message: "To add an image the app needs to have acces to your photo librairy")
            case .restricted:
                self.alert(message: "This app can't access the photo librairy on this device")
            case .denied:
                self.alert(message: "You did not allow this app to access your photo librairy. You can change that in Settings")
            case .authorized:
                print("auth")
                self.mainVC.present(PHPickerViewController.init(configuration: PHPickerConfiguration.init(photoLibrary: PHPhotoLibrary())), animated: true, completion: nil)
            case .limited:
                PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self.mainVC)
            @unknown default:
                fatalError()
                
            }
        }
    }
    
    
    private func alert(message: String){
        print(message)
        
    }
    
}
