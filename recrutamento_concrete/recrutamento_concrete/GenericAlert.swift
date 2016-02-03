//
//  GenericAlert.swift
//  recrutamento_concrete
//
//  Created by Arilson Carmo on 2/2/16.
//  Copyright © 2016 arilson. All rights reserved.
//

import UIKit

class GenericAlert {
    
    func showAlert(stringTitle: String, stringMessage: String, completion: () -> Void) {
        let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
        let alert = UIAlertController(title: stringTitle, message: stringMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            completion()
        }))
        rootViewController.presentViewController(alert, animated: true, completion: nil)
    }
}
