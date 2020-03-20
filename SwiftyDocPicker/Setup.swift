//
//  Setup.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 05/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import UIKit
import SSZipArchive

class Setup {
//   class func getText(fromCloudFilePath filePath: URL) -> [String] {
//        let value = getTextEncoding(filePath: filePath)
//        let data = value.data
//        let myString = data.components(separatedBy: .newlines)
//        return myString
//    //var texts: [String] = [""]
//    //texts = myString
//    //texts
//    }
//    class func getTextEncoding(filePath path: URL, defaultEncoding: String.Encoding = .windowsCP1250) -> (encoding: String.Encoding, data: String) {
//        let encodingType: [String.Encoding] = [.utf8,.windowsCP1250,.isoLatin2, .unicode, .ascii]
//        var data: String = "brakUJE"
//        var encoding: String.Encoding = .windowsCP1250
//        let val = tryEncodingFile(filePath: path, encoding: defaultEncoding)
//        if  val.data.count > 0 {
//            data = val.data
//        }
//        else {  // find encoding
//            for i in 0..<encodingType.count {
//                let value = tryEncodingFile(filePath: path, encoding: encodingType[i])
//                if value.isOk {
//                    data = value.data
//                    encoding = encodingType[i]
//                    break
//                }
//            }
//        }
//        if data == "brakUJE" {
//            print("BRAKUJE: \(path)")
//        }
//        return  (encoding, data)
//    }
//    class func tryEncodingFile(filePath path: URL, encoding: String.Encoding)  -> (isOk: Bool, data: String) {
//        do {
//            let data = try String(contentsOf: path, encoding: encoding)
//            print("enum <#name#> {

//            return (isOk: true, data: data)
//        }
//        catch {
//            return (isOk: false, data: "")
//        }
//    }
//    class func mergeText(forStrings strings: [String]) -> String {
//        var val = ""
//        for elem in strings {
//            //defer {    print("val:\(val)")   }
//            val += elem + "\n"
//        }
//        return val
//    }
    
    
 
    
    class func findValue<T: Comparable>(currentList: [T], valueToFind: T, handler: (_ currElem: T) -> Bool) -> Bool {
        var found = false
        // TODO: Finalize method
        for i in 0..<currentList.count {
            if currentList[i] == valueToFind { found = true}
        }
        return found
    }
    class func displayToast(forController controller: UIViewController, message: String, seconds delay: Double)  {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .systemYellow
        alert.view.alpha = 0.3
        alert.view.layer.cornerRadius = 10
        alert.view.clipsToBounds = true
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            alert.dismiss(animated: true)
        }
    }
    class func displayToast(forView view: UIView, message : String, seconds delay: Double) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75, y: view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 5, delay: 11, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.2
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    class func popUp(context ctx: UIViewController, msg: String) {

        let toast = UILabel(frame:
            CGRect(x: 16, y: ctx.view.frame.size.height / 2,
                   width: ctx.view.frame.size.width - 32, height: 100))

        toast.backgroundColor = UIColor.lightGray
        toast.textColor = UIColor.white
        toast.textAlignment = .center;
        toast.numberOfLines = 3
        toast.font = UIFont.systemFont(ofSize: 20)
        toast.layer.cornerRadius = 12;
        toast.clipsToBounds  =  true

        toast.text = msg

        ctx.view.addSubview(toast)

        UIView.animate(withDuration: 15.0, delay: 0.2,
            options: .curveEaseOut, animations: {
            toast.alpha = 0.0
            }, completion: {(isCompleted) in
                toast.removeFromSuperview()
        })
    }
    
    //----
  

    class func unzipFile(atPath path: String, delegate: SSZipArchiveDelegate)
        {
            let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destFolder = "/Testownik_tmp"
            let destPath = documentsURL.appendingPathComponent(destFolder, isDirectory: true)
            let destString = destPath.absoluteString
            if ( !FileManager.default.fileExists(atPath: destString) )
            {
                try! FileManager.default.createDirectory(at: destPath, withIntermediateDirectories: true, attributes: nil)
            }
            SSZipArchive.unzipFile(atPath: path, toDestination: destString, delegate: delegate)
        }
}
