//
//  BaseUIViewController.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import UIKit
import Kamagari
import EventKit
import SwiftOverlays
import Photos
import iOSBoilerplate

fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func <= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}


enum BaseUIViewControllerError: Error {
    case clearUserDataError
    
    var error: NSError {
        switch self {
        case .clearUserDataError: return BaseError.generateNSError(code: -1)
        }
    }
}

class BaseUIViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate var textFields: [UITextField] = []
    
    fileprivate var getPhotoCameraOrGalleryOnCancel: (() -> Void)!
    fileprivate var getPhotoCameraOrGalleryOnError: ((_ errorMessage: String) -> Void)!
    fileprivate var getPhotoCameraOrGalleryOnPhotoRetrieved: ((_ image: UIImage) -> Void)!
    fileprivate var getPhotoCameraOrGalleryTitleActionSheet: String?
    fileprivate let getPhotoCameraOrGalleryPickerController = UIImagePickerController() // swiftlint:disable:this variable_name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTouchOutsideTextFieldHideKeyboard()
        setBackButtonText()
        
        detectIfUserUpgradedFromPreviousBetaBuild()
    }
    
    // REMOVE ME IF V1 BUILDS
    fileprivate func detectIfUserUpgradedFromPreviousBetaBuild() {
        if BuildUtil.getVersionName().get(1) == "1" {
            fatalError("Remove me for v1 builds of app")
        }
        
        let buildVersionFromPreviousInstall = NSUserDefaultsUtil.getString("preferencesBuildVersion")
        
        if buildVersionFromPreviousInstall != nil && buildVersionFromPreviousInstall! != BuildUtil.getVersionName() {
            NotificationCenterUtil.postUserUnauthorized(true)
        } else {
            NSUserDefaultsUtil.saveString("preferencesBuildVersion", value: BuildUtil.getVersionName())
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenterUtil.removeObserver(self)
    }
    
    func setBackButtonText() {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }
    
    func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate // swiftlint:disable:this force_cast
    }
    
    // Call from child view controller. Iterates textfields, checks if blank, shows dialog if blank returns false. Else, returns true.
    func assertTextFieldsFilledIn() -> Bool {
        for textField in textFields {
            if textField.text?.characters.count <= 0 {
                var errorMessage = "All text fields must be filled out to continue."
                
                if let placeholderText = textField.placeholder {
                    errorMessage = placeholderText + " must not be blank."
                }
                
                AlertBuilder(title: "Error", message: errorMessage, preferredStyle: .alert)
                    .addAction(title: "Ok", style: .cancel) { _ in }
                    .build()
                    .kam_show(animated: true)
                
                return false
            }
        }
        
        return true
    }
    
    // override if do not want to add gesture recognizer to hide keyboard on self.view touch.
    func shouldAddHideKeyboardOutsideTouchRecognizer() -> Bool {
        return false
    }
    
    fileprivate func setupTouchOutsideTextFieldHideKeyboard() {
        if shouldAddHideKeyboardOutsideTouchRecognizer() {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
            self.view.addGestureRecognizer(tapRecognizer)
        }
    }
    
    func hideAllChildrenViews() {
        for subview in self.view.subviews {
            subview.isHidden = true
        }
    }
    
    func showAllChildrenViews() {
        for subview in self.view.subviews {
            subview.isHidden = false
        }
    }
    
    func showShareSheet(_ shareMessage: String) {
        let activityViewController = UIActivityViewController(activityItems: [shareMessage as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func addEventToCalendar(_ title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        _ = SwiftOverlays.showBlockingWaitOverlayWithText("Adding event to calendar...")
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            defer {
                SwiftOverlays.removeAllBlockingOverlays()
            }
            
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    if completion == nil {
                        AlertBuilder(title: "Error", message: "Could not create calendar event. Try again.", preferredStyle: .alert)
                            .addAction(title: "Ok", style: .cancel) { _ in }
                            .build()
                            .kam_show(animated: true)
                    } else {
                        completion?(false, e)
                    }
                    return
                }
                if completion == nil {
                    AlertBuilder(title: "Success", message: "Added to calendar", preferredStyle: .alert)
                        .addAction(title: "Ok", style: .cancel) { _ in }
                        .build()
                        .kam_show(animated: true)
                } else {
                    completion?(true, nil)
                }
            } else {
                if completion == nil {
                    AlertBuilder(title: "Error", message: "Could not create calendar event. Try again.", preferredStyle: .alert)
                        .addAction(title: "Ok", style: .cancel) { _ in }
                        .build()
                        .kam_show(animated: true)
                } else {
                    completion?(false, error as NSError?)
                }
            }
        })
    }
    
    // call from child class to automate all textfield actions such as hide keyboard on return, hide keyboard touch outside.
    func addTextField(_ textField: UITextField) {
        textFields.append(textField)
        
        textField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func dismissKeyboard() {
        textFields.forEach { (textField) in
            textField.resignFirstResponder()
        }
    }
    
}

// User take photo/choose photo from gallery.
extension BaseUIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getPhotoFromCameraOrGallery(_ titleActionSheet: String?, onCancel: @escaping () -> Void, onError: @escaping (_ errorMessage: String) -> Void, onPhotoRetrieved: @escaping (_ image: UIImage) -> Void) {
        self.getPhotoCameraOrGalleryTitleActionSheet = titleActionSheet
        self.getPhotoCameraOrGalleryOnError = onError
        self.getPhotoCameraOrGalleryOnCancel = onCancel
        self.getPhotoCameraOrGalleryOnPhotoRetrieved = onPhotoRetrieved
        
        AlertBuilder(title: titleActionSheet, preferredStyle: .actionSheet)
            .addAction(title: "Take new picture", style: .default) { _ in
                self.takePhoto()
            }
            .addAction(title: "Pick picture from gallery", style: .default) { _ in
                self.getPhotoFromGallery()
            }
            .addAction(title: "Cancel", style: .cancel) { _ in
                self.getPhotoCameraOrGalleryOnCancel()
            }
            .build()
            .kam_show(animated: true)
    }
    
    fileprivate func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) && UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front) {
            getPhotoCameraOrGalleryPickerController.allowsEditing = false
            getPhotoCameraOrGalleryPickerController.sourceType = UIImagePickerControllerSourceType.camera
            //            imagePickerController.mediaTypes = [kUTTypeJPEG as String] // Record movie (video with audio)
            getPhotoCameraOrGalleryPickerController.cameraCaptureMode = .photo
            getPhotoCameraOrGalleryPickerController.modalPresentationStyle = .fullScreen
            getPhotoCameraOrGalleryPickerController.cameraDevice = UIImagePickerControllerCameraDevice.front
            getPhotoCameraOrGalleryPickerController.delegate = self
            
            present(getPhotoCameraOrGalleryPickerController, animated: true, completion: nil)
        } else {
            self.getPhotoCameraOrGalleryOnError("Your device is not able to take photos.")
        }
    }
    
    fileprivate func getPhotoFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.getPhotoCameraOrGalleryOnError("Your device is not able to get photos from gallery.")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismiss(animated: true, completion: { _ in
            self.getPhotoCameraOrGalleryOnPhotoRetrieved(image)
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let capturedImage = info[UIImagePickerControllerOriginalImage] as! UIImage // swiftlint:disable:this force_cast
        
        // saves to camera roll on phone. Maybe you don't need it? Maybe you can just send to API.
        //        PHPhotoLibrary.shared().performChanges({
        //            PHAssetChangeRequest.creationRequestForAsset(from: capturedImage)
        //        }) { saved, error in
        //            if saved {
        //                // photo saved to camera roll.
        //            } else {
        //                self.getPhotoCameraOrGalleryOnError("Error saving photo to camera roll.")
        //            }
        //        }
        
        self.dismiss(animated: true, completion: { _ in
            self.getPhotoCameraOrGalleryOnPhotoRetrieved(capturedImage)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func setNavigationBarTitle(_ text: String?) {
        if let text = text {
            if self.navigationItem.titleView is UIButton {
                (self.navigationItem.titleView as! UIButton).setTitle(text, for: UIControlState.normal) // swiftlint:disable:this force_cast
            } else {
                self.navigationController?.navigationBar.topItem?.title = text
            }
        }
    }
    
    func setNavigationBarTitleToButton(_ selector: Selector) {
        self.navigationItem.navigationBarTitleButton(titleText: self.navigationController?.navigationBar.topItem?.title ?? "", target: self, selector: selector, navigationController: self.navigationController)
    }
    
}
