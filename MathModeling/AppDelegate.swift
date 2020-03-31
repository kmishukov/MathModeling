//
//  AppDelegate.swift
//  Task1
//
//  Created by Konstantin Mishukov on 31.03.2020.
//  Copyright © 2020 Konstantin Mishukov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timer: Timer? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        guard let statusButton = statusBarItem.button else { return }
        
//        statusButton.title = Date.now.stringTimeWithSeconds
//
//        timer = Timer.scheduledTimer(
//            timeInterval: 1,
//            target: self,
//            selector: #selector(updateStatusText),
//            userInfo: nil,
//            repeats: true
//        )
    }
    
    @objc
    func updateStatusText(_ sender: Timer) {
        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = Date.now.stringTimeWithSeconds
        print(Date.now.stringTimeWithSeconds)
    }

}

