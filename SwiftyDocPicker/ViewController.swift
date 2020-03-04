//
//  ViewController.swift
//  SwiftyDocPicker
//
//  Created by Abraham Mangona on 9/14/19.
//  Copyright © 2019 Abraham Mangona. All rights reserved.
//

import UIKit

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
    }
    func didPickDocuments(documents: [CloudPicker.Document]?) {
        self.documents = []
        documents?.forEach {
            self.documents.append($0)
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
            print("nextViewController:\(nextViewController)")
            nextViewController.descriptionLabelValue = document.fileURL.lastPathComponent
            nextViewController.textViewValue = document.fileURL.absoluteString
            }
      }
    }
    func getCurrentItem(for collectionCell: UICollectionViewCell) -> Int {
        //let ii = collectionView.indexPath(for: UICollectionViewCell)
        if let indexPath = collectionView.indexPath(for: collectionCell) {
            // use indexPath to delete the cell
            return indexPath.row
        }
        else {
            return 0
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
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        performSegue(withIdentifier: "showDetail", sender: cell)
        
//        if let cell = collectionView.cellForItem(at: indexPath) {
//
//        }
    }
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//    if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
//    cellLabels[indexPath.row] as String
//    cellImages[indexPath.row] as String
//       }
//    }
    
}

