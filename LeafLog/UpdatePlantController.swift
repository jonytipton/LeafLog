//
//  UpdatePlantController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 6/17/23.
//

import UIKit

class UpdatePlantController: UIViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var updateButtonLabel: UIButton!
    @IBOutlet var updateLabel: UILabel!
    var delegate: PlantDetailViewController!
    
    override func viewDidLoad() {
        guard (delegate != nil) else { fatalError("no PlantDetailViewController delegate for modal!")}
        super.viewDidLoad()
        updateLabel.textColor = UIColor.init(named: "titleColor")
        datePicker.date = delegate.plant.dateAdded ?? .now
        view.backgroundColor = UIColor(named: "appBackground")
    }
    
    @IBAction func tappedUpdateButton(_ sender: Any) {
        guard (delegate != nil) else {
            dismiss(animated:true)
                    return }
        delegate.plant.dateAdded = datePicker.date
        delegate.garden.saveChanges()
        delegate.tableView.reloadData()
        delegate.tableView.isScrollEnabled = true
        dismiss(animated: true)
    }
    
    

}
