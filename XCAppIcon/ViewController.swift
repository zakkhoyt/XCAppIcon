//
//  ViewController.swift
//  XCAppIcon
//
//  Created by Zakk Hoyt on 1/17/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

//  Get input file
//  Get output director
//  Resize images using sips
//  @2x + @3x
//  83.5
//  Create AppIcon.appiconset dir
//  Create Contents.json file
//  Write json content to file along with duplicating images




import Cocoa

class ViewController: NSViewController {

    var inputURL: NSURL? = nil
    var outputURL: NSURL? = nil
    
    @IBOutlet weak var imagePathLabel: NSTextField!
    @IBOutlet weak var outputPathLabel: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressIndicator.hidden = true
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
    
        progressIndicator.hidden = false
        progressIndicator.startAnimation(nil)
        
        // Generate images
        let imageSizes: [CGFloat] = [8, 16, 29, 32, 40, 44, 50, 57, 60, 70, 72, 76, 83.5, 96, 122, 18, 148, 174, 200, 256, 320, 512, 1024]
        for i in 0..<imageSizes.count {
            let size = imageSizes[i]
            resizeImageUniform(inputURL, outputDirURL: outputURL, size: size)
        }
        
        
        // Generate JSON file

        let appIcon = AppIcon()

        appIcon.images.append(Image(size: 29, idiom: .iPhone, scale: ._2x))
        appIcon.images.append(Image(size: 29, idiom: .iPhone, scale: ._3x))
        appIcon.images.append(Image(size: 40, idiom: .iPhone, scale: ._2x))
        appIcon.images.append(Image(size: 40, idiom: .iPhone, scale: ._3x))
        appIcon.images.append(Image(size: 60, idiom: .iPhone, scale: ._2x))
        appIcon.images.append(Image(size: 60, idiom: .iPhone, scale: ._3x))
        
        if let json = appIcon.json() {
            print("json: \n" + String(json))
        } else {
            print("No json to print")
        }
        
        
        
        
        
        
        progressIndicator.stopAnimation(nil)
        progressIndicator.hidden = true
        
        
    }
    
    func resizeImageUniform(imageURL: NSURL, outputDirURL: NSURL, size: CGFloat) {
//        let semaphore = dispatch_semaphore_create(0)
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.resizeImage(imageURL, outputDirURL: outputDirURL, pointSize: CGSize(width: size, height: size))
//                dispatch_semaphore_signal(semaphore);
//            })
//        }
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    func resizeImage(imageURL: NSURL, outputDirURL: NSURL, pointSize: CGSize) {
        resizeImageWithSuffix(imageURL, outputDirURL: outputDirURL, pointSize: pointSize, suffix: 1)
        resizeImageWithSuffix(imageURL, outputDirURL: outputDirURL, pointSize: pointSize, suffix: 2)
        resizeImageWithSuffix(imageURL, outputDirURL: outputDirURL, pointSize: pointSize, suffix: 3)
    }
    
    
    func resizeImageWithSuffix(imageURL: NSURL, outputDirURL: NSURL, pointSize: CGSize, suffix: UInt) {
        
        
        var outputFile: String = ""
        var args: [String] = []

        let widthName = pointSize.width % 1 == 0 ? "\(UInt(pointSize.width))" : NSString(format: "%.1f", pointSize.width)
        let heightName = pointSize.height % 1 == 0 ? "\(UInt(pointSize.height))" : NSString(format: "%.1f", pointSize.height)
        
        
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










