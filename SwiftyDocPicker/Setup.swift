//
//  Setup.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 05/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import Foundation
class Setup {
   class func getText(fromCloudFilePath filePath: URL, encodingSystem encoding: String.Encoding = .utf8) -> [String] {
        var texts: [String] = ["brak"]
            let path = filePath
            do {
                let data = try String(contentsOf: path, encoding: encoding)
                let myString = data.components(separatedBy: .newlines)
                texts = myString
            }
            catch {
                print("Błąd: \(error)")
            }
        return texts
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
