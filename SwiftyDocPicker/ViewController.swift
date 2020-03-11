//
//  ViewController.swift
//  SwiftyDocPicker
//
//  Created by Abraham Mangona on 9/14/19.
//  Copyright © 2019 Abraham Mangona. All rights reserved.
//

import UIKit
//import SSZipArchive
//import "SSZipArchive”
//#import "SSZipArchive.h"

//    import ZipArchive
    //import SSZipArchive



class ViewController: UIViewController, CloudPickerDelegate {
    var cloudPicker: CloudPicker!
    var documents : [CloudPicker.Document] = []
    var indexpath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.documents =  []
        cloudPicker = CloudPicker(presentationController: self)
        cloudPicker.delegate = self
        Setup.popUp(context: self, msg: "Your message")
        //SSZip
    }
    func didPickDocuments(documents: [CloudPicker.Document]?) {
        self.documents = []
        documents?.forEach {
            self.documents.append($0)
        }
        self.documents.sort {
            $0.fileURL.lastPathComponent < $1.fileURL.lastPathComponent
        }
        collectionView.reloadData()
    }
    @IBAction func pickPressed(_ sender: Any) {
        cloudPicker.present(from: view)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue: \(String(describing: segue.identifier))")
        if segue.identifier == "showDetail" {
        if let nextViewController = segue.destination as? DetailViewController {
            let document = documents[self.indexpath.row]
            
            
            //let textLines = cloudPicker.getText(fromCloudFilePath: document.fileURL)
            print("nextViewController:\(nextViewController)")
            //print("textLines:\(textLines)")
            nextViewController.descriptionLabelValue = document.fileURL.lastPathComponent
            nextViewController.urlValue = document.fileURL
            print("fileURL: \(document.fileURL)")
            //let content = cloudPicker.mergeText(forStrings: textLines)
            //print("content:\(content)")
            nextViewController.textViewValue = "??\n"  + "\n:" + document.fileURL.absoluteString
            Setup.displayToast(forView: self.view, message: "Druga wiadomość", seconds: 3)
            //Setup.displayToast(forController: self, message: "To jest wiadomość", seconds: 3)
            Setup.popUp(context: self, msg: "Trzecia wiadomość")
            print("self.indexpath 2:\(self.indexpath)")
            nextViewController.indexpathValue = self.indexpath
        }
      }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
        cell.configure(document: documents[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexpath = indexPath
        print("self.indexpath 1:\(self.indexpath)")
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        performSegue(withIdentifier: "showDetail", sender: cell)
    }
}


