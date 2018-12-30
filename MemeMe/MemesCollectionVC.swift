//
//  MemesCollectionVC.swift
//  MemeMe
//
//  Created by Frederik Skytte on 21/12/2018.
//  Copyright © 2018 Frederik Skytte. All rights reserved.
//

import UIKit

class MemesCollectionVC: UICollectionViewController {
    
    var allMemes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    let space:CGFloat = 8.0
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    // MARK: ViewControllerMethods
    
    override func viewDidLoad() {
        self.collectionFlowLayout?.minimumInteritemSpacing = space
        self.collectionFlowLayout?.minimumLineSpacing = space
        
        let horizontalWidth = UIDevice.current.orientation.isPortrait ?
            view.frame.size.width : view.frame.size.height
        
        updateFlowLayoutProperties(toWidth: horizontalWidth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView!.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        updateFlowLayoutProperties(toWidth: size.width)
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        let meme = self.allMemes![indexPath.row]
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        //Populate view controller with data from the selected item
        detailController.currentMeme = allMemes![indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    // MARK: Private helper fuctions
    
    private func updateFlowLayoutProperties(toWidth width: CGFloat){
        let imagesPerRow: CGFloat = UIDevice.current.orientation.isPortrait ? 3.0 : 4.0
        let dimension = (width - ((imagesPerRow - 1.0) * self.space)) / imagesPerRow
        
        self.collectionFlowLayout?.itemSize = CGSize(width: dimension, height: dimension)
    }
}
