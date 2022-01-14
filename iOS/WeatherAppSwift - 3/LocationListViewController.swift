//
//  LocationListViewController.swift
//  WeatherAppSwift - 3
//
//  Created by Melih Cüneyter on 11.01.2022.
//

import UIKit
import GooglePlaces

class LocationListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var editMenuButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var weatherLocations: [WeatherLocation] = []
    var selectedLocationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupMenuButton()
        
    }
    
    // MARK: - Actions
    func saveLocations() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherLocations) {
            UserDefaults.standard.set(encoded, forKey: "weatherLocations")
        } else {
            print("Error: Saving Encoded didn't work!")
        }
    }
    
    func setupMenuButton() {
        //TODO: Fix "Listeyi düzenle" button action. add "Done" button.
        let editList = UIAction(title: "Listeyi düzenle", image: UIImage(systemName: "pencil")) { (action) in
            if self.tableView.isEditing {
                self.tableView.setEditing(false, animated: true)
                self.addBarButton.isEnabled = true
            } else {
                self.tableView.setEditing(true, animated: true)
                self.addBarButton.isEnabled = false
            }
        }
        
        //TODO: Add Buttons Action
        let celcius = UIAction(title: "Santigrat", image: UIImage(systemName: "c.circle")) { (action) in
            
        }
        
        let fahrenheit = UIAction(title: "Fahrenhayt", image: UIImage(systemName: "f.circle")) { (action) in
            
        }
        
        let turkishLanguage = UIAction(title: "Türkçe", image: UIImage(systemName: "t.circle")) { (action) in
            
        }
        
        let englishLanguage = UIAction(title: "Ingilizce", image: UIImage(systemName: "e.circle")) { (action) in
            
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: [editList, celcius, fahrenheit, turkishLanguage, englishLanguage])
        
        editMenuButton.menu = menu
        editMenuButton.showsMenuAsPrimaryAction = true
    }
    
    //TODO: Convert searchBar from Add Location Button
    func searchBarIsSelected() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedLocationIndex = tableView.indexPathForSelectedRow!.row
        saveLocations()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}

// MARK: - TableView Delegate - DataSource
extension LocationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = weatherLocations[indexPath.row].name
        cell.detailTextLabel?.text = "lat: \(weatherLocations[indexPath.row].latitude), lon: \(weatherLocations[indexPath.row].longitude),"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0 ? true : false)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (indexPath.row != 0 ? true : false)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return (proposedDestinationIndexPath.row != 0 ? sourceIndexPath : proposedDestinationIndexPath)
    }
}

// MARK: - GMSAutoComplete Delegate
extension LocationListViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let newLocation = WeatherLocation(name: place.name ?? "unkown place", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        weatherLocations.append(newLocation)
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
