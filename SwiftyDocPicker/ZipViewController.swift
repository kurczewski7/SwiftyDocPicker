//
//  ZipViewController.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 18/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import UIKit

class ZipViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var zipFileNameValue = ""
    var urlValue = ""
    
    var cloudPicker: CloudPicker!
    var documents : [CloudPicker.Document] = []
    var indexpath = IndexPath(row: 0, section: 0)
    var tmpDoc = [CloudPicker.Document]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cloudPicker = CloudPicker(presentationController: self)
        if urlValue.count > 0 {
            let urlStr = urlValue
            let url = URL(fileURLWithPath: urlStr, isDirectory: true)
            tmpDoc = cloudPicker.documentFromZip(pickedURL: url)
            //print("-----\ntmpDoc:\(tmpDoc),\(tmpDoc.count)")
        }
        else {
            print("Error Display Zip")
        }
        

        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tmpDoc.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zipCell", for: indexPath) as! ZipCollectionViewCell
        cell.titleLabel.text =  tmpDoc[indexPath.item].fileURL.lastPathComponent    // "\(indexPath.item)"
        //cell.configure(document: documents[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      // 1
      switch kind {
      // 2
      case UICollectionView.elementKindSectionHeader:
        // 3  \(ZipSectionHeaderView.self)  sectionHeader
        guard
          let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "sectionHeader",
            for: indexPath) as? ZipSectionHeaderView
          else {
            fatalError("Invalid view type")
        }

        //let searchTerm = searches[indexPath.section].searchTerm
        headerView.label.text = zipFileNameValue    //searchTerm
        return headerView
      default:
        // 4
        assert(false, "Invalid element type")
      }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        self.indexpath = indexPath
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        performSegue(withIdentifier: "showZipDetail", sender: cell)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showZipDetail" {
            let document = tmpDoc[self.indexpath.row]
            if let nextViewController = segue.destination as? DetailViewController {
                nextViewController.descriptionLabelValue = document.fileURL.lastPathComponent
                nextViewController.textViewValue = document.myTexts
                
                
                //nextViewController.zipFileNameValue = document.fileURL.lastPathComponent
                //Setup.unzipFile(atPath: document.fileURL.absoluteString, delegate: self)
                //let urlStr = unzip(document: document)
                //nextViewController.urlValue = urlStr
            }
         print("showArchiveDetail")
        }
    }
}

        
//        print("segue: \(String(describing: segue.identifier))")
//        let document = documents[self.indexpath.row]
//        if segue.identifier == "showDetail" {
//            if let nextViewController = segue.destination as? DetailViewController {
//                //let document = documents[self.indexpath.row]
//                nextViewController.descriptionLabelValue = document.fileURL.lastPathComponent
//                nextViewController.textViewValue = "\(document.myTexts)\n"  + "\n:" + document.fileURL.absoluteString
//                nextViewController.indexpathValue = self.indexpath
//                            
//                Setup.displayToast(forView: self.view, message: "Druga wiadomość", seconds: 3)
//                Setup.popUp(context: self, msg: "Trzecia wiadomość")
//
//                print("nextViewController:\(nextViewController)")
//                print("fileURL: \(document.fileURL)")
//                print("self.indexpath 2:\(self.indexpath)")
//            }
//      }
//      if segue.identifier == "showArchive" {
//        if let nextViewController = segue.destination as? ZipViewController {
//            nextViewController.zipFileNameValue = document.fileURL.lastPathComponent
//
//            //Setup.unzipFile(atPath: document.fileURL.absoluteString, delegate: self)
//            let urlStr = unzip(document: document)
//            nextViewController.urlValue = urlStr
//        }
//         print("showArchive")
//      }
        
//-------


//    extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return documents.count
//        }
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
//            cell.configure(document: documents[indexPath.row])
//            return cell
//        }
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            self.indexpath = indexPath
//            print("self.indexpath 1:\(self.indexpath)")
//            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
//            let noZip = cloudPicker.sourceType != .filesZip
//            if noZip {
//              performSegue(withIdentifier: "showDetail", sender: cell)
//            }
//            else {
//                //Setup.popUp(context: self, msg: "Zbior ZIP")
//                performSegue(withIdentifier: "showArchive", sender: cell)
//            }
//        }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


