//
//  ZipViewController.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 18/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import UIKit

class ZipViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zipCell", for: indexPath) as! ZipCollectionViewCell
        cell.titleLabel.text = "\(indexPath.item)"
        //cell.configure(document: documents[indexPath.row])
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

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


