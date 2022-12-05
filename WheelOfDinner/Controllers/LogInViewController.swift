//
//  LogInViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/1/22.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController {
    
    let myUser = User.shared;

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
        // Validate the fields
        let error = validateFields()
        
        if error != nil{
            showError(error!)
        }
        else{
            // Create cleaned versions of the data
            let email = self.EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // User created successfully, store the username
            Auth.auth().signIn(withEmail: email, password: password){
                (result, error) in
                // Check for errors
                if error != nil{
                    self.showError(error!.localizedDescription)
                }
                else{
                    // Transition to the home page
                    // TODO: Get uid and set User
                 //   myUser.setUser(uid: <#T##String#>, username: <#T##String#>)
                    self.transitionToHome()
                }
                
            }
            
        }
    }
    

    @IBAction func SignUpRedirectionDidTapped(_ sender: UIButton) {
    }
    
    // if the fields are not correct, return error message
    func validateFields() -> String?{
        // Check that all fields are filled in
        if  EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in both fields."
        }
        //TODO: check email format
        return nil
    }
    
    //when any field is empty, add alert message
    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // if login successful, transition from login Page to homepage
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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
