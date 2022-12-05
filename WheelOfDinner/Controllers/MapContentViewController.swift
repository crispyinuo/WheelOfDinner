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
    
    // Swift Singleton pattern
    let sharedModel = ResultModel.shared
    
    override func viewDidLoad(){
        loadBusiness()
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func loadBusiness(){
        print("I got here. loading business")
        sharedModel.getBusiness{businesses in
            DispatchQueue.main.async {
            //put in async because retriving images takes time, you put the task in a separate thread so you don't freeze the UI
            // you get the businesses of type [Business], sort them by reviewCount, and reload data on the table view
              //  ResultModel.shared.businesslist = businesses.sorted(by: { $0.reviewCount! > $1.reviewCount! })
                self.tableview.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedModel.getBusinessCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sharedModel.businesslist[indexPath.row]
        print("I got here in " + sharedModel.businesslist[indexPath.row].name!)
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        // restaurant name
        cell.RestaurantNameLabel.text = result.name ?? "No name"
        
        // restaurant image
        let url = URL(string: result.image_url ?? "")
        print("Image URL: " + result.image_url!)
        cell.ImageView.kf.setImage(with:url)
        
        // restaurant price level
        cell.PriceLabel.text = result.price ?? ""
        
        // restaurant review count
        cell.ReviewLabel.text = "\( String(result.reviewCount ?? 0)) reviews"
        
        // if the restaurant is closed
        if let closed = result.is_closed{
            if(closed){
                cell.isOpenLabel.text = "Closed now"
            }else{
                cell.isOpenLabel.text = "Open"
            }
        }else{
            cell.isOpenLabel.text = ""
        }
        
        // restaurant location
        cell.LocationLabel.text = (result.location?.address1) ?? ""
        
        // restaurant category
        if let category = result.categories{
            cell.CategoryLabel.text = category[0].title ?? ""
        }else{
            cell.CategoryLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return CGFloat(100)
    }

}
