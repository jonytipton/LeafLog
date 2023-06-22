//
//  CollectionViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 6/21/23.
//

import UIKit

private let reuseIdentifier = "reminderCell"

class CollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    enum Days: String {
        case Sunday = "Sunday"
        case Monday = "Monday"
        case Tuesday = "Tuesday"
        case Wednesday = "Wednesday"
        case Thursday = "Thursday"
        case Friday = "Friday"
        case Saturday = "Saturday"
    }
    
    var scheduleList = [Int: [Plant]]() //Section #
    
    let margin = 10.0

    var plants = [Plant]()
    //Reference to managed object context
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchPlants()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        fetchPlants()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
       
        // Do any additional setup after loading the view.
        title = "Watering Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor(named: "titleColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "appBackground")
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "titleColor")!, .font: UIFont(name: "Futura", size: 20)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "titleColor")!, .font: UIFont(name: "Futura", size: 34)!]
        appearance.backgroundColor = UIColor(named: "appBackground")
        navigationItem.standardAppearance = appearance
        
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? SectionHeader{
            sectionHeader.sectionHeaderLabel.text = Calendar.current.weekdaySymbols[indexPath.section]
                return sectionHeader
            }
            return UICollectionReusableView()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleList[section]?.count ?? 0
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reminderCell", for: indexPath) as? ReminderCell else { fatalError("Unable to dequeue resuable cell with identifer: 'reminderCell'")}
        if let plant = scheduleList[indexPath.section]?[indexPath.item] {
            cell.reminderLabel.text = plant.nickname?.capitalized
            cell.reminderLabel.font = UIFont(name: "Futura", size: 15)
            if let photoData = plant.displayPhoto {
                if let image = UIImage(data: photoData) {
                    cell.reminderImageView.image = image
                    cell.reminderImageView.layer.cornerRadius = 25
                }
            }
        }
        
        cell.layoutIfNeeded()
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRowCount = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRowCount - 1))
        
        let size = Double((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRowCount))
        print("Size\(size)")
        return CGSize(width: size, height: size + margin * 2)
    }

    func fetchPlants() {
        //Fetch data from Core Data to display in the collectionview
        do {
            self.plants = try context.fetch(Plant.fetchRequest())
            reloadPlants()
        } catch {
            print("error in fetchPlants(): \(error)")
        }
    }
    
    func reloadPlants() {
        scheduleList.removeAll(keepingCapacity: true)
        for plant in plants {
            if let _ = plant.reminderDay {
                switch plant.reminderDay {
                case "Sunday":
                    scheduleList[0] == nil ? scheduleList[0] = [plant] : scheduleList[0]?.append(plant)
                case "Monday":
                    scheduleList[1] == nil ? scheduleList[1] = [plant] : scheduleList[1]?.append(plant)
                case "Tuesday":
                    scheduleList[2] == nil ? scheduleList[2] = [plant] : scheduleList[2]?.append(plant)
                case "Wednesday":
                    scheduleList[3] == nil ? scheduleList[3] = [plant] : scheduleList[3]?.append(plant)
                case "Thursday":
                    scheduleList[4] == nil ? scheduleList[4] = [plant] : scheduleList[4]?.append(plant)
                case "Friday":
                    scheduleList[5] == nil ? scheduleList[5] = [plant] : scheduleList[5]?.append(plant)
                case "Saturday":
                    scheduleList[6] == nil ? scheduleList[6] = [plant] : scheduleList[6]?.append(plant)
                default:
                    break
                }
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
