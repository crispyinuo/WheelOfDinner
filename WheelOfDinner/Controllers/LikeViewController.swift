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
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Wait until the first load complete & loading additional business if there is one
        sharedModel.loadList.wait()
        sharedModel.loadList.notify(queue: DispatchQueue.main, execute: {
            print("check finish all likelist loading")
            // Everytime after we load like list, set likeListChanged to false
            self.tableView.reloadData()
                print("Finished all requests.")
            })
        
//        // login in data loaded
//        if(sharedModel.startFirstLoad == true && sharedModel.endFirstLoad == true){
//
//        }
//        // likeListChanged but not loaded
//        if sharedModel.likeListChanged == true && sharedModel.likeListLoad == false {
//            loadLikeList()
//        } else {
//            print("tableview reloading")
//            self.tableView.reloadData()
//        }
    }

    func loadLikeList(){
        let loadList = DispatchGroup()
        let loadQueue = DispatchQueue.global(qos: .background)
        let semaphore = DispatchSemaphore(value: 2)
        print("start reloading")
        sharedModel.likelist = []
        for bid in User.shared.likeList {
            loadQueue.async(group: loadList){
                semaphore.wait()
                self.sharedModel.getBusinessById(BusinessId: bid){business in
                    print("Done with \(business.name ?? "nope")")
                    semaphore.signal()
                }
                Thread.sleep(forTimeInterval: 1)
            }
        }
        loadList.wait()
        loadList.notify(queue: DispatchQueue.main, execute: {
            print("finish reloading")
            // Everytime after we load like list, set likeListChanged to false
                self.sharedModel.likeListChanged = false
                self.sharedModel.likeListLoad = true
                self.tableView.reloadData()
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
            if let bid = sharedModel.likelist[indexPath.row].id{
                           thisUser.deleteFromLikeList(bid: bid)
            sharedModel.likelist.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "LikeDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LikeDetail" {
            let WebDetailVC = segue.destination as! WebViewController
                // let indexPath = tableView.indexPath.row
            WebDetailVC.selectedRestaurant = sharedModel.likelist[(sender as! IndexPath).row].url
            self.tableView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
        //
    }
        
}
