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
class CloudPicker: NSObject {
    public enum SourceType: Int {
        case filesA
        case filesB
        case folder
    }
    class Document: UIDocument {
        var data: Data?
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
    var delegate: CloudPickerDelegate?
    
    private var folderURL: URL?
    private var sourceType: SourceType!
    private var documents = [Document]()
    
    init(presentationController: UIViewController) {
        super.init()
        
        self.presentationController = presentationController
        print("INIT")
    }
    public func folderAction(for type: SourceType, title: String) -> UIAlertAction? {
         let action = UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController = UIDocumentPickerViewController(documentTypes: [kUTTypeFolder as String], in: .open)
            self.pickerController!.delegate = self
            self.sourceType = type
            self.presentationController?.present(self.pickerController!, animated: true)
        }
        return action
    }
    public func fileAction(for type: SourceType, title: String, keysOption keys: [CFString]) -> UIAlertAction? {
         let action = UIAlertAction(title: title, style: .default) { [unowned self] _ in
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
        if let action = self.fileAction(for: .filesA, title: "Files text", keysOption: keys1) {
            alertController.addAction(action)
        }
        let keys2 = [kUTTypeArchive, kUTTypeZipArchive,kUTTypeGNUZipArchive]
        if let action = self.fileAction(for: .filesA, title: "Files archive", keysOption: keys2) {
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
                    let keys: [URLResourceKey] = [.nameKey, .isDirectoryKey]
                    let fileList = FileManager.default.enumerator(at: pickedURL, includingPropertiesForKeys: keys)
                    var isFound = false
                    
                    switch sourceType {
                        case .filesA, .filesB :
                            let document = Document(fileURL: pickedURL)
                            for elem in documents {
                                if elem.fileURL.lastPathComponent == pickedURL.lastPathComponent {  isFound = true    }
                            }
                            if !isFound {
                              documents.append(document)
                            }

                        case .folder:
                            for case let fileURL as URL in fileList! {
                                if !fileURL.isDirectory {
                                    let document = Document(fileURL: fileURL)
                                    documents.append(document)
                                }
                            }
                    case .none:
                        break
                    }
                 }
//                catch let error {
//                    print("error:  \(error.localizedDescription)")
//                }
        }
    }
    
}

extension CloudPicker: UINavigationControllerDelegate {}
extension URL {
    var isDirectory: Bool! {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory
    }
}
