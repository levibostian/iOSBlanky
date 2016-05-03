//
//  BaseUIViewController.swift
//  iOSBlanky
//
//  Created by Levi Bostian on 5/3/16.
//  Copyright © 2016 Curiosity IO. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.hidesNavigationBarHairline = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
