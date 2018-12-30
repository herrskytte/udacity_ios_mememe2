//
//  DetailsViewController.swift
//  MemeMe
//
//  Created by Frederik Skytte on 28/12/2018.
//  Copyright © 2018 Frederik Skytte. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var currentMeme: Meme?
    
    @IBOutlet weak var fullSizeImageView: UIImageView!
    
    // MARK: ViewControllerMethods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.fullSizeImageView.image = currentMeme?.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
