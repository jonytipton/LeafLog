//
//  ReminderPlantDetailController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 6/21/23.
//

import UIKit

class ReminderPlantDetailController: UIViewController {

    var plant: Plant!
    var delegate: PlantDetailViewController!
    
    @IBOutlet var reminderLabel: UILabel!
    @IBOutlet var frequencySegment: UISegmentedControl!
    @IBOutlet var daySegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "appBackground")
        reminderLabel.textColor = UIColor(named: "titleColor")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createTapped(_ sender: Any) {
        plant.reminderFrequency = Int64(frequencySegment.selectedSegmentIndex)
        switch (daySegment.selectedSegmentIndex) {
        case 0:
            plant.reminderDay = "Sunday"
        case 1:
            plant.reminderDay = "Monday"
        case 2:
            plant.reminderDay = "Tuesday"
        case 3:
            plant.reminderDay = "Wednesday"
        case 4:
            plant.reminderDay = "Thursday"
        case 5:
            plant.reminderDay = "Friday"
        default:
            plant.reminderDay = "Saturday"
        }
        delegate.garden.saveChanges()
        dismiss(animated: true)
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
