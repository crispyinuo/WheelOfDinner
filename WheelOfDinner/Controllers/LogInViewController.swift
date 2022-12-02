//
//  LogInViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/1/22.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var LogInButton: UIButton!
    
    @IBOutlet weak var SignUpRedirectButton: UIButton!
    
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func LogInDidTapped(_ sender: UIButton) {
    }
    

    @IBAction func SignUpRedirectionDidTapped(_ sender: UIButton) {
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
