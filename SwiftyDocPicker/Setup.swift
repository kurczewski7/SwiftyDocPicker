//
//  Setup.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 05/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import Foundation
class Setup {
   class func getText(fromCloudFilePath filePath: URL) -> [String] {
        var texts: [String] = ["brak"]
        let value = getTextEncoding(filePath: filePath)
        let data = value.data
        let myString = data.components(separatedBy: .newlines)
        texts = myString
        return texts
    }
    class func getTextEncoding(filePath path: URL) -> (encoding: String.Encoding, data: String) {
        let encodingType: [String.Encoding] = [.utf8,.windowsCP1250,.isoLatin2, .unicode, .ascii]
        var data: String = ""
        var encoding: String.Encoding = .ascii
        
        for i in 0..<encodingType.count {
            let value = tryEncodingFile(filePath: path, encoding: encodingType[i])
            if value.isOk {
                data = value.data
                encoding = encodingType[i]
                break
            }
        }
        let retVal: (encoding: String.Encoding, data: String)  = (encoding, data)
        return retVal
    }
    class func tryEncodingFile(filePath path: URL, encoding: String.Encoding)  -> (isOk: Bool, data: String) {
        do {
             let data = try String(contentsOf: path, encoding: encoding)
            return (isOk: true, data: data)
        }
        catch {
            return (isOk: false, data: "")
        }
    }
    class func mergeText(forStrings strings: [String]) -> String {
        var val = ""
        for elem in strings {
            defer {    print("val:\(val)")   }
            val += elem + "\n"
        }
        return val
    }
    class func findValue<T: Comparable>(currentList: [T], valueToFind: T, handler: (_ currElem: T) -> Bool) -> Bool {
        var found = false
        for i in 0..<currentList.count {
            if currentList[i] == valueToFind { found = true}
        }
        return found
    }
}
