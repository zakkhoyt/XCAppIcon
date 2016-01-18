//
//  ViewController.swift
//  XCAppIcon
//
//  Created by Zakk Hoyt on 1/17/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var inputURL: NSURL? = nil
    var outputURL: NSURL? = nil
    
    
    
    @IBOutlet weak var imagePathLabel: NSTextField!
    
    
    @IBOutlet weak var outputPathLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func imagePathButtonAction(sender: AnyObject) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        
        let clicked = panel.runModal()
        
        if clicked == NSFileHandlingPanelOKButton {
            for url in panel.URLs {
                print("selected input file: " + url.description)
                inputURL = url
                imagePathLabel.stringValue = url.description
            }
        }
    }



    @IBAction func outputPathButtonAction(sender: AnyObject) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        let clicked = panel.runModal()
        
        if clicked == NSFileHandlingPanelOKButton {
            for url in panel.URLs {
                print("selected output dir: " + url.description)
                outputURL = url
                outputPathLabel.stringValue = url.description
            }
        }

    }
    
    @IBAction func testButtonAction(sender: AnyObject) {
        guard let inputURL = self.inputURL , outputURL = self.outputURL else {
            print("must pick input and output")
            return
        }
    
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 8)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 16)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 29)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 32)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 40)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 44)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 50)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 57)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 60)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 70)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 72)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 76)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 83.5)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 96)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 122)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 128)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 148)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 174)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 200)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 256)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 320)
        resizeImageUniform(inputURL, outputDirURL: outputURL, size: 512)
        resizeImageWithSuffix(inputURL, outputDirURL: outputURL, pointSize: CGSizeMake(1024, 1024), suffix: 1)
    }
    
    func resizeImageUniform(imageURL: NSURL, outputDirURL: NSURL, size: CGFloat) {
        resizeImage(imageURL, outputDirURL: outputDirURL, pointSize: CGSize(width: size, height: size))
    }
    
    func resizeImage(imageURL: NSURL, outputDirURL: NSURL, pointSize: CGSize) {
        resizeImageWithSuffix(imageURL, outputDirURL: outputDirURL, pointSize: pointSize, suffix: 1)
        resizeImageWithSuffix(imageURL, outputDirURL: outputDirURL, pointSize: pointSize, suffix: 2)
        resizeImageWithSuffix(imageURL, outputDirURL: outputDirURL, pointSize: pointSize, suffix: 3)
    }
    
    
    func resizeImageWithSuffix(imageURL: NSURL, outputDirURL: NSURL, pointSize: CGSize, suffix: UInt) {
        
        var outputFile: String = ""
        var args: [String] = []

        let widthName = String(UInt(pointSize.width))
        let heightName = String(UInt(pointSize.height))
        
        
        switch suffix {

        case 2:
            let widthValue = String(UInt(2*pointSize.width))
            let heightValue = String(UInt(2*pointSize.height))
            outputFile = outputDirURL.path! + "/" + widthName + "x" + heightName + "@2x.png"
            args = [
                imageURL.path!,
                "-z",
                widthValue,
                heightValue,
                "-o",
                outputFile
            ]
        case 3:
            let widthValue = String(UInt(3*pointSize.width))
            let heightValue = String(UInt(3*pointSize.height))
            outputFile = outputDirURL.path! + "/" + widthName + "x" + heightName + "@3x.png"
            args = [
                imageURL.path!,
                "-z",
                widthValue,
                heightValue,
                "-o",
                outputFile
            ]
        default:
            let widthValue = String(UInt(pointSize.width))
            let heightValue = String(UInt(pointSize.height))
            outputFile = outputDirURL.path! + "/" + widthName + "x" + heightName + ".png"
            args = [
                imageURL.path!,
                "-z",
                widthValue,
                heightValue,
                "-o",
                outputFile
            ]
        }
        

        let pipe = NSPipe()
        let file = pipe.fileHandleForReading
        let task = NSTask()
        task.launchPath = "/usr/bin/sips"
        
        task.arguments = args
        task.standardOutput = pipe
        task.launch()
        
        let data = file.readDataToEndOfFile()
        file.closeFile()
        
        let output = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        var argString = ""
        for arg in args {
            argString += arg + " "
        }
        print(task.launchPath! + " " + argString)
        print("xcimage returned: \n" + String(output))
    }
}










