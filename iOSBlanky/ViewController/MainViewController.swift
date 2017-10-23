//
//  ViewController.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    private let gitHubController: GitHubController = GitHubController.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }    
    
    @IBAction func howManyReposButtonPressed(_ sender: UIButton) {
        if let gitHubUsername = usernameTextField.text {
            showLoadingOverlay(text: "Getting repos...")
            
            gitHubController.getUserRepos(gitHubUsername: gitHubUsername, onError: { (message) in
                self.hideLoadingOverlay()
                
                let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                errorAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (_) in }))
                self.present(errorAlertController, animated: true, completion: nil)
            }, onComplete: { (data) in
                self.hideLoadingOverlay()
                
                if let repos = data {
                    let alertController = UIAlertController(title: "Success!", message: String(format: "The number of repos for %@ is: %i", gitHubUsername, repos.count), preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (_) in }))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
}
