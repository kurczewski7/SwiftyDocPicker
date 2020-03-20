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
            let urlStr = urlValue+"/baza"
            let url = URL(fileURLWithPath: urlStr, isDirectory: true)
            tmpDoc = cloudPicker.documentFromZip(pickedURL: url)
            tmpDoc.sort {
                $0.fileURL.lastPathComponent < $1.fileURL.lastPathComponent
            }
            print("tmpDoc:\(tmpDoc),\(tmpDoc.count)")
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
}
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


