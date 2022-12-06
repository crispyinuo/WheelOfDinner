//
//  LikeViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/4/22.
//

import UIKit
import SwiftUI
import Kingfisher

class LikeViewController: UITableViewController {
    
    // Swift Singleton pattern
    let sharedModel = ResultModel.shared
    let thisUser = User.shared
    let loadList = DispatchGroup()
    
    override func viewDidLoad() {
        sharedModel.likeListChanged = true
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sharedModel.likeListChanged == true{
            loadLikeList()
        }
    }
    
    func loadLikeList(){
        sharedModel.likelist = []
        for bid in User.shared.likeList {
            self.loadList.enter()
            self.sharedModel.getBusinessById(BusinessId: bid){business in
            DispatchQueue.main.async {
               // self.tableView.reloadData()
            }
            self.loadList.leave()
            }
        }

        self.loadList.notify(queue: DispatchQueue.main, execute: {
                self.tableView.reloadData()
                // Everytime after we load like list, set likeListChanged to false
                self.sharedModel.likeListChanged = false
                print("Finished all requests.")
            })

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sharedModel.likelist.count
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //    model.removeFlashcard(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // the ID of business
//        let resultId = thisUser.likeList[indexPath.row]
        let result = sharedModel.likelist[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "likecell", for: indexPath) as! LikeTableViewCell

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
            
            return cell
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return CGFloat(100)
    }
        
}
