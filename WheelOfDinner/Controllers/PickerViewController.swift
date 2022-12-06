//
//  PickerViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/6/22.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    // Swift Singleton pattern
    let sharedModel = ResultModel.shared
    let thisUser = User.shared
    let loadList = DispatchGroup()

    @IBOutlet weak var PickerView: UIPickerView!
    
    @IBAction func startButton(_ sender: UIButton) {
        let newValue = arc4random_uniform(UInt32(sharedModel.likelist.count))
        self.PickerView.selectRow(Int(newValue), inComponent: 0, animated: true)
        self.PickerView.reloadComponent(0)
    }
    
    override func viewDidLoad() {
        sharedModel.spinnerChanged = true
        super.viewDidLoad()
        PickerView.delegate = self
        PickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sharedModel.spinnerChanged == true{
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
            self.PickerView.reloadAllComponents()
                // Everytime after we load like list, set spinnerChanged to false
                self.sharedModel.spinnerChanged = false
                print("Finished all requests.")
            })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sharedModel.likelist.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return sharedModel.likelist[row].name
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
