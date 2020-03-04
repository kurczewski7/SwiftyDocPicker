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
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cloudPicker = CloudPicker(presentationController: self)
        cloudPicker.delegate = self
    }
    func didPickDocuments(documents: [CloudPicker.Document]?) {
        documents?.forEach {
            self.documents.append($0)
        }
        collectionView.reloadData()
    }
    @IBAction func pickPressed(_ sender: Any) {
        cloudPicker.present(from: view)
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
}

