//
//  UpdatePlantDetailViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 6/17/23.
//

import UIKit

class UpdatePlantDetailViewController: UIViewController, UITextFieldDelegate {

    var delegate: PlantDetailViewController!
    
    @IBOutlet var detailTextfield: UITextField!
    
    @IBOutlet var changeLabel: UILabel!
    var section: Int!
    
    override func viewDidLoad() {
        guard (delegate != nil) else { fatalError("PlantDetailViewController delegate is nil!")}
        super.viewDidLoad()
        switch section {
        case 1:
            changeLabel.text = "Change Nickname?"
        case 2:
            changeLabel.text = "Change Sunlight Needs?"
        case 3:
            changeLabel.text = "Change Watering Needs?"
        case 4:
            changeLabel.text = "Change Bloom Cycle?"
        case 5:
            changeLabel.text = "Change Common Name?"
        case 6:
            changeLabel.text = "Change Scientific Name?"
        default:
            break
        }
        detailTextfield.becomeFirstResponder()
        detailTextfield.delegate = self
    }
    @IBAction func updateDetailTapped(_ sender: Any) {
        delegate.didFinishUpdatingDetailField((section, detailTextfield.text ?? ""))
        dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        detailTextfield.resignFirstResponder()
        return true
    }
    
}
