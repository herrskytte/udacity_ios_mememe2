//
//  MemesTableVC.swift
//  MemeMe
//
//  Created by Frederik Skytte on 21/12/2018.
//  Copyright © 2018 Frederik Skytte. All rights reserved.
//

import UIKit

class MemesTableVC: UITableViewController {
    
    var allMemes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: ViewControllerMethods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! MemeTableCell
        let meme = self.allMemes![indexPath.row]
        
        // Set the name and image
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        cell.memeImageView.image = meme.originalImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        //Populate view controller with data from the selected item
        detailController.currentMeme = allMemes![indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
        
    }
}



