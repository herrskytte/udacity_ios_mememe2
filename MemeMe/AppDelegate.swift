//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Frederik Skytte on 07/12/2018.
//  Copyright © 2018 Frederik Skytte. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Shared model for the application
    var memes = [Meme]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //createDemoMemes()
        
        return true
    }
    
    // Create memes to easier check UI on launch. Only use for testing/demo
    fileprivate func createDemoMemes() {
        let img1 = UIImage(named: "meme1")
        let meme1 = Meme(topText: "HUGE PROGRAM COMPILES FOR THE FIRST TIME",
                         bottomText: "NOT SURE IF SUCCESS OR PC EXPLODES",
                         originalImage: img1, memedImage:img1)
        
        let img2 = UIImage(named: "meme2")
        let meme2 = Meme(topText: "IT COMPILES",
                         bottomText: "SHIP IT",
                         originalImage: img2, memedImage:img2)
        
        
        let img3 = UIImage(named: "meme3")
        let meme3 = Meme(topText: "MOST USED LANGUAGE IN PROGRAMMING?",
                         bottomText: "PROFANITY",
                         originalImage: img3, memedImage:img3)
        
        memes.append(meme1)
        memes.append(meme2)
        memes.append(meme3)
        memes.append(meme3)
        memes.append(meme1)
        memes.append(meme2)
        memes.append(meme2)
        memes.append(meme3)
        memes.append(meme3)
        memes.append(meme1)
        memes.append(meme1)
        memes.append(meme2)
    }
}

