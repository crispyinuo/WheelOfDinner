//
//  MapContentViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 11/6/22.
//

import UIKit
import SwiftUI
import Kingfisher

class MapContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var LocationLabel: UILabel!
    
    // Swift Singleton pattern
    let sharedModel = ResultModel.shared
    let thisUser = User.shared
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if(thisUser.location.isEmpty){
            LocationLabel.text = "My Location"
        }else{
            LocationLabel.text = thisUser.location
        }
        super.viewWillAppear(animated)
        loadBusiness()
    }
    
    func loadBusiness(){
        sharedModel.getBusinessByCoordinates(latitude: thisUser.latitude, longitude: thisUser.longitude){businesses in
            DispatchQueue.main.async {
            //put in async because retriving images takes time, you put the task in a separate thread so you don't freeze the UI
            // you get the businesses of type [Business], and reload data on the table view
                self.tableview.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedModel.getBusinessCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sharedModel.businesslist[indexPath.row]
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
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
        
        // if the restaurant is closed
        if let closed = result.is_closed{
            if(closed == true){
                cell.isOpenLabel.text = "Closed now"
                cell.isOpenLabel.textColor = UIColor.red
            }else{
                cell.isOpenLabel.text = "Open"
                cell.isOpenLabel.textColor = UIColor.systemGreen
            }
        }else{
            cell.isOpenLabel.text = ""
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
        
        //TODO: add restaurant to userLikes list
        if let id = selectedRestaurant.id{
            thisUser.addToLikeList(bid: id)
            print(selectedRestaurant.name!)
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

}
