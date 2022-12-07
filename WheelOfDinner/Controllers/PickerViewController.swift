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
    
    @IBAction func LogOutButtonDidTapped(_ sender: UIButton) {
        // Transition to start view
        let startViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.startViewController) as? ViewController
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
           let window = sceneDelegate.window{
            window.rootViewController = startViewController
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
        sharedModel.LogOut()
        thisUser.LogOut()
        print("Logging out")
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        if sharedModel.likelist.count > 0 {
            let newValue = arc4random_uniform(UInt32(sharedModel.likelist.count))
            self.PickerView.selectRow(Int(newValue), inComponent: 0, animated: true)
            self.PickerView.reloadComponent(0)
            // wait a couple of seconds before performing segue
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.performSegue(withIdentifier: "PopUp", sender: Int(newValue))
            })
        }else{
            // TODO: display alert
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopUp" {
            guard let PopUpVC = segue.destination as? PopUpViewController
            else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            let result = sharedModel.likelist[sender as! Int]
            PopUpVC.name = result.name ?? ""
            PopUpVC.ImageURL = result.image_url ?? ""
          }
        self.dismiss(animated: true, completion: nil)
        //
    }


}
