//
//  MapContentViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 11/6/22.
//

import UIKit
import Kingfisher

class MapContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var LocationLabel: UILabel!
    
    // Swift Singleton pattern
    let sharedModel = ResultModel.shared
    let thisUser = User.shared
    
    override func viewDidLoad(){
        super.viewDidLoad()
        sharedModel.businessListChanged = true
        tableview.delegate = self
        tableview.dataSource = self
        // To listen from the mapViewController if it updates the location
        NotificationCenter.default.addObserver(self, selector: #selector(loadListfromMap), name: NSNotification.Name(rawValue: "load"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        if(thisUser.location.isEmpty){
            LocationLabel.text = "My Location"
        }else{
            LocationLabel.text = thisUser.location
        }
        super.viewWillAppear(animated)
        if sharedModel.businessListChanged == true{
            loadBusiness()
        }
    }
    
    func loadBusiness(){
        sharedModel.getBusinessByCoordinates(latitude: thisUser.latitude, longitude: thisUser.longitude){businesses in
            DispatchQueue.main.async { [self] in
            //put in async because retriving images takes time, you put the task in a separate thread so you don't freeze the UI
            // you get the businesses of type [Business], and reload data on the table view
                sharedModel.businessListChanged = false
                self.tableview.reloadData()
            }
        }
    }
    
    @objc func loadListfromMap(notification: NSNotification){
        //load data here when the mapView update its location
        if(thisUser.location.isEmpty){
            LocationLabel.text = "My Location"
        }else{
            LocationLabel.text = thisUser.location
        }
        loadBusiness()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedModel.getBusinessCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sharedModel.businesslist[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.addButton.isEnabled = true
        
        // restaurant name
        cell.RestaurantNameLabel.text = result.name ?? "No name"
        
        // restaurant image
        let url = URL(string: result.image_url ?? "")

        cell.ImageView.kf.setImage(with:url)
        
        // restaurant price level
        cell.PriceLabel.text = result.price ?? ""
        
        // restaurant review count
        cell.ReviewLabel.text = "\( String(result.review_count ?? 0)) reviews"
        
        // restaurant rating
        cell.RatingLabel.text = "Rating: \( String(result.rating ?? 0))"
        
        // set restaurant distance
        if let dis = result.distance{
            // convert from meter to mile
            let mile = dis/1609.344
            cell.distanceLabel.text = "\(String(format: "%.1f", mile)) m"
    
        }else{
            cell.distanceLabel.text = ""
        }
        
        // restaurant location
        cell.LocationLabel.text = (result.location?.address1) ?? "No detail location"
        
        // restaurant category
        if let category = result.categories{
            cell.CategoryLabel.text = category[0].title ?? ""
        }else{
            cell.CategoryLabel.text = ""
        }
        
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(addToLikes), for: .touchUpInside)
        
        return cell
    }
    @objc func addToLikes(sender: UIButton){
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        let selectedRestaurant = sharedModel.businesslist[indexpath1.row]
        
        // add restaurant to userLikes list
        if let id = selectedRestaurant.id {
            if(thisUser.likeList.count >= 9){
                showError("You already have no less than 9 restaurants in your like lists! Delete some before adding more!")
            }
            else if(thisUser.addToLikeList(bid: id)){
                sender.isEnabled = false
                // print("\(selectedRestaurant.name ?? "No name")")
            } else {
                sender.isEnabled = false
                showError("\(selectedRestaurant.name ?? "This restaurant") already exists in your likes!")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "YelpDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "YelpDetail" {
            let WebDetailVC = segue.destination as! WebViewController
                // let indexPath = tableView.indexPath.row
            WebDetailVC.selectedRestaurant = sharedModel.businesslist[(sender as! IndexPath).row].url
            self.tableview.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
        //
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return CGFloat(100)
    }
    
    //when error happen
    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

}
