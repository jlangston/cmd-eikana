//
//  ViewController.swift
//  cmd-eikana
//
//  MIT License
//  Copyright (c) 2016 iMasanari
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var showIcon: NSButton!
    @IBOutlet weak var lunchAtStartup: NSButton!
    @IBOutlet weak var checkUpdateAtlaunch: NSButton!
    @IBOutlet weak var updateButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let showIconState = userDefaults.object(forKey: "showIcon")
        showIcon.state = showIconState == nil ? 1 : showIconState as! Int
        
        if #available(OSX 10.12, *) {
        } else {
            showIcon.title += "（macOS Sierraのみ）"
            showIcon.isEnabled = false
        }
        
        lunchAtStartup.state = userDefaults.integer(forKey: "lunchAtStartup")
        checkUpdateAtlaunch.state = userDefaults.integer(forKey: "checkUpdateAtlaunch")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @available(OSX 10.12, *)
    @IBAction func clickShowIcon(_ sender: AnyObject) {
        statusItem.isVisible = (showIcon.state == NSOnState)
        userDefaults.set(showIcon.state, forKey: "showIcon")
    }
    @IBAction func clickLunchAtStartup(_ sender: AnyObject) {
        setLaunchAtStartup(lunchAtStartup.state == NSOnState)
        userDefaults.set(lunchAtStartup.state, forKey: "lunchAtStartup")
    }
    @IBAction func clickCheckUpdateAtlaunch(_ sender: AnyObject) {
        userDefaults.set(checkUpdateAtlaunch.state, forKey: "checkUpdateAtlaunch")
    }
    
    @IBAction func checkUpdateButton(_ sender: AnyObject) {
        updateButton.isEnabled = false
        checkUpdate({ (isNewVer: Bool?) -> Void in
            self.updateButton.isEnabled = true
            if isNewVer == nil {
                let alert = NSAlert()
                
                // alert.messageText = "通信に失敗しました"
                alert.messageText = "Communication Failed"
                // alert.informativeText = "時間をおいて試してください"
                alert.informativeText = "Please wait a while and try it."
                
                alert.runModal()
            }
            else if isNewVer == false {
                let alert = NSAlert()
                
                // alert.messageText = "最新バージョンです"
                alert.messageText = "It is the latest version"
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                alert.informativeText = "ver.\(version)"
                
                alert.runModal()
            }
        })
    }
}

