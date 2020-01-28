//
//  Alerts.swift
//  MarvelApiApp
//
//  Created by tarek on 1/28/20.
//  Copyright © 2020 tarek. All rights reserved.
//

import UIKit
import SVProgressHUD


class Messages {
    
    static let instance = Messages()
    
    func showMessage(title : String , message : String , controller : UIViewController ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        controller.present(alert, animated : true , completion: nil)
    }
    
    
    func showProgressSpinner(message : String)  {
            SVProgressHUD.setBackgroundColor( .black)
            SVProgressHUD.setForegroundColor(.white)
            SVProgressHUD.setBorderWidth(4.0)
            SVProgressHUD.show(withStatus: message)
    }
    
    func dissmissProgrressSpinner() {
        SVProgressHUD.dismiss()
    }
    
}
