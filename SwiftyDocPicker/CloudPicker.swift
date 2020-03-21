//
//  CloudPicker.swift
//  SwiftyDocPicker
//
//  Created by Abraham Mangona on 9/14/19.
//  Copyright © 2019 Abraham Mangona. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol CloudPickerDelegate: class {
    func didPickDocuments(documents: [CloudPicker.Document]?)
}
class CloudPicker: NSObject, UINavigationControllerDelegate {
    public enum SourceType: Int {
        case filesTxt
        case filesZip
        case folder
    }

    // MARK: Class Document
    class Document: UIDocument {
        var data: Data?
        var myTexts = ""
        
        override func contents(forType typeName: String) throws -> Any {
            guard let data = data else { return Data() }
            return try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
        }
        override func load(fromContents contents: Any, ofType typeName: String?) throws {
            guard let data = contents as? Data else { return }
            self.data = data
        }
    }
    private var pickerController: UIDocumentPickerViewController?
    private weak var presentationController: UIViewController?
 
    private var folderURL: URL?
    var sourceType: SourceType = .folder
    private var documents = [Document]()
    //private var lastSourceTypeData: SourceType = .folder
    //var myTexts2 = [String]()
    
    var delegate: CloudPickerDelegate?
    var showHidden = false
    
    init(presentationController: UIViewController) {
        super.init()
        
        self.presentationController = presentationController
        print("INIT")
//        documents.sort { ($0, $1) -> Bool in
//
//        }
    }
    public func folderAction(for type: SourceType, title: String) -> UIAlertAction? {
         let action = UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.cleadData()
            self.pickerController = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
            self.pickerController!.delegate = self
            self.sourceType = type
            self.presentationController?.present(self.pickerController!, animated: true)
        }
        return action
    }
    public func fileAction(for type: SourceType, title: String, keysOption keys: [CFString]) -> UIAlertAction? {
         let action = UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if self.sourceType == .folder  || self.sourceType == .filesZip {                self.cleadData()            }
            self.pickerController = UIDocumentPickerViewController(documentTypes: keys as [String], in: .open)
            self.pickerController!.delegate = self
            self.pickerController!.allowsMultipleSelection = true
            self.sourceType = type
            self.presentationController?.present(self.pickerController!, animated: true)
        }
        return  action
    }
    public func present(from sourceView: UIView) {
        //let xx = [kUTTypeText, kUTTypeFolder, kUTTypeArchive, kUTTypeFileURL,kUTTypePlainText, kUTTypeZipArchive, kUTTypeGNUZipArchive, kUTTypeUTF8PlainText, kUTTypeUTF16ExternalPlainText, kUTTypeUTF8TabSeparatedText, kUTTypeUTF16PlainText]
        let alertController = UIAlertController(title: "Select From", message: nil, preferredStyle: .actionSheet)
        if let action = self.folderAction(for: .folder, title: "Folder") {
            alertController.addAction(action)
        }
        let keys1 =  [kUTTypeText , kUTTypePlainText, kUTTypeUTF8PlainText, kUTTypeUTF8TabSeparatedText, kUTTypeUTF16PlainText, kUTTypeUTF16ExternalPlainText]
        if let action = self.fileAction(for: .filesTxt, title: "Files text", keysOption: keys1) {
            alertController.addAction(action)
        }
        let keys2 = [kUTTypeArchive, kUTTypeZipArchive,kUTTypeGNUZipArchive]
        if let action = self.fileAction(for: .filesZip, title: "Files archive", keysOption: keys2) {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
    }
    //--------------------------
    func getText(fromCloudFilePath filePath: URL) -> [String] {
        let value = getTextEncoding(filePath: filePath)
        let myStrings = value.data.components(separatedBy: .newlines)
        return myStrings
    }
    private func getTextEncoding(filePath path: URL, defaultEncoding: String.Encoding = .windowsCP1250) -> (encoding: String.Encoding, data: String) {
        var data: String = "brakUJE"
        let val = tryEncodingFile(filePath: path, encoding: .windowsCP1250)
        if  val.isOk  {
            data = val.data
        }
        else {
            data = val.data
        }
        if data == "brakUJE" {
            print("BRAKUJE: \(path)")
        }
        return  (.windowsCP1250, data)
    }
    private func tryEncodingFile(filePath path: URL, encoding: String.Encoding)  -> (isOk: Bool, data: String) {
        do {
            //let fff = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let data = try String(contentsOf: path, encoding: encoding)
            //print("DATA!!,encoding\(encoding):\(data)")
            return (isOk: true, data: data)
        }
        catch let error {
            print("NIE ZDEKODOWANO STRINGA:\(encoding),error:\(error)")
            return (isOk: false, data: "Error:\(error)")
        }
    }
    private func findEncoding(filePath path: URL) -> (encoding: String.Encoding, data: String) {
        let encodingType: [String.Encoding] = [.utf8, .windowsCP1250, .isoLatin2, .unicode, .ascii]
        var data: String = "Nie znaleziono"
        var encoding: String.Encoding = .windowsCP1250
        for i in 0..<encodingType.count {
            let value = tryEncodingFile(filePath: path, encoding: encodingType[i])
            if value.isOk {
                data = value.data
                encoding = encodingType[i]
                break
            }
        }
        return  (encoding, data)
    }
    func mergeText(forStrings strings: [String]) -> String {
        var val = ""
            for elem in strings {     val += elem + "\n"        }
        return val
    }
    func cleadData() {
            documents.removeAll()
    }
    //-----------------------
    deinit {
        print("DEINIT")
    }
}
extension CloudPicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {   return    }
         documentFromURL(pickedURL: url)
         delegate?.didPickDocuments(documents: documents)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        delegate?.didPickDocuments(documents: nil)
    }
    private func documentFromURL(pickedURL: URL) {
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }
        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
                do {
                    let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey] //isDirectoryKey isRegularFileKey
                    let fileList = FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)
                    print("Folder_URL:\(folderURL.absoluteString)")
          
                    switch sourceType {
                        case .folder:
                        for case let fileURL as URL in fileList! {
                            if !fileURL.isDirectory {
                                var document = Document(fileURL: fileURL)
                                if isFileUnhided(fileURL: fileURL, folderURL: folderURL, sourceType: .folder) {
                                    fillDocument(forUrl: fileURL, document: &document)
                                    documents.append(document)
                                    print("File_URL:\(fileURL.absoluteString)")
                                }
                            }
                        }
                    
                        case .filesTxt:
                            var document = Document(fileURL: pickedURL)
                            print("One_File_URL:\(pickedURL.absoluteString)")
                            if isFileUnhided(fileURL: pickedURL, folderURL: folderURL, sourceType: .filesTxt) {
                                fillDocument(forUrl: pickedURL, document: &document)
                                documents.append(document)
                            }
                       
                        case .filesZip:
                            let document = Document(fileURL: pickedURL)
                            print("Opcjia filesZip")
                            if isFileUnhided(fileURL: pickedURL, folderURL: folderURL, sourceType: .filesZip) {
                               //fillDocument(forUrl: pickedURL, document: &document)
                               documents.append(document)
                            }
                    }
                 }
//                catch let error {
//                    print("error:  \(error.localizedDescription)")
//                }
        }
    }
    func documentFromZip(pickedURL: URL) -> [Document]{  //pickedURL: URL,
        var documents_tmp = [Document]()
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()
        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }
        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (folderURL) in
                do {
                    let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey] //isDirectoryKey isRegularFileKey
                    let fileList = FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)
                    print("Folder_URL:\(folderURL.absoluteString)")
                        for case let fileURL as URL in fileList! {
                            if !fileURL.isDirectory {
                                var document = Document(fileURL: fileURL)
                                if isFileUnhided(fileURL: fileURL, folderURL: folderURL, sourceType: .folder) {
                                    fillDocument(forUrl: fileURL, document: &document)
                                    documents_tmp.append(document)
                                    print("File_Zip_URL:\(fileURL.absoluteString)")
                                }
                            }
                        }
                    }
            }
            documents_tmp.sort {
                $0.fileURL.lastPathComponent < $1.fileURL.lastPathComponent
            }

        return documents_tmp
    }
    func fillDocument(forUrl url: URL, document: inout Document) {
        let txts = getText(fromCloudFilePath: url)
        let txt = mergeText(forStrings: txts)
        document.myTexts = txt
    }
    
    func isFileUnhided(fileURL url: URL, folderURL: URL, sourceType: SourceType)  -> Bool {
        let name = url.lastPathComponent
         print("isFileUnhided przed")
        if name.hasPrefix(".")                           {   return false   }
        if sourceType == .folder && folderURL !=  url.deletingLastPathComponent() {
            return false
        }
        print("isFileUnhided po")

        let values =  name.split(separator: ".")
        switch sourceType {
            case .filesTxt:
                print("Txt")
                return isTextDataOk(values: values)
            
            case .filesZip:
                print("Zip")
                if  values[values.count-1].uppercased() == "ZIP"   {
                     return true
                 }
                 else {
                     return false
                 }

            case .folder:
                print("folder")
                return isTextDataOk(values: values)
        }
    }

        
        func isTextDataOk(values: [Substring])  -> Bool{
            if let number = Int(values[0]), number >= 0 {
                 return true
             }
             else {
                 return false
             }
        
        
    }
}

//extension CloudPicker:  {}
extension URL {
    var isDirectory: Bool! {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory
    }
}

    //----
    //private static let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

//    class func unzipFile(atPath path: String, delegate: SSZipArchiveDelegate)
//        {
//            let destFolder = "/Folder_Name"
//            let destPath = documentsURL.appendingPathComponent(destFolder, isDirectory: true)
//            let destString = destPath.absoluteString
//
//            if ( !FileManager.default.fileExists(atPath: destString) )
//            {
//                try! FileManager.default.createDirectory(at: destPath, withIntermediateDirectories: true, attributes: nil)
//            }
//
//            SSZipArchive.unzipFile(atPath: path, toDestination: destString, delegate: delegate)
//        }
