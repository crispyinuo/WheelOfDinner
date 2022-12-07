//
//  PopUpViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/6/22.
//

import UIKit
import Kingfisher

class PopUpViewController: UIViewController {
    
    public var ImageURL: String!
    
    public var name: String!

    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var RestaurantNameLabel: UILabel!
    
    @IBAction func OKDidTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image_url = ImageURL{
            self.ImageView.kf.setImage(with: URL(string: image_url))
        }
        self.RestaurantNameLabel.text = name
        // Do any additional setup after loading the view.
    }
    
    // reset
    override func viewWillDisappear(_ animated: Bool) {
        self.ImageView = nil
        self.RestaurantNameLabel.text = ""
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
