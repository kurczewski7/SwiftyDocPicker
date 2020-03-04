//
//  DetailViewController.swift
//  SwiftyDocPicker
//
//  Created by Slawek Kurczewski on 04/03/2020.
//  Copyright © 2020 Abraham Mangona. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var textViewValue = ""
    var descriptionLabelValue = ""
    var indexpathValue = IndexPath(item: 0, section: 0)
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = textViewValue           // "To jest textview"
        descriptionLabel.text = descriptionLabelValue       //"To jest label"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
