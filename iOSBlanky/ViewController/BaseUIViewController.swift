//
//  BaseUIViewController.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController, UITextFieldDelegate {
    
    let keyboardMoveUpHeight: CGFloat = 50
    
    private var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesNavigationBarHairline = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func addTextField(textField: UITextField) {
        textFields.append(textField)
        
        textField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: keyboardMoveUpHeight)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: keyboardMoveUpHeight)
    }
    
    func dismissKeyboard() {
        textFields.forEach { (textField) in
            textField.resignFirstResponder()
        }
    }
    
    func animateViewMoving(shouldMoveUp: Bool, moveValue: CGFloat) {
        let movementDuration: NSTimeInterval = 0.3
        let movement: CGFloat = (shouldMoveUp ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame.offsetInPlace(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
