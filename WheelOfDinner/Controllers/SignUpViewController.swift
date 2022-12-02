//
//  SignUpViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/1/22.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var RegisterButton: UIButton!
    
    @IBOutlet weak var LogInRedirectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func RegisterDidTapped(_ sender: UIButton) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil{
            showError(error!)
        }
        else{
            Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>){ [self] (result,err) in
                // Check for errors
                if err != nil{
                    self.showError("Error creating user")
                }
                else{
                    // Create the user
                    
                    // Create cleaned versions of the data
                    let username = self.UsernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let email = self.EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let password = self.PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    // User created successfully, store the username
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["username":username, "uid":result!.user.uid]){(error) in
                        if error != nil{
                            self.showError("Error saving user data.")
                        }
                    }
                    // Transition to the home page
                    self.transitionToHome()
                    
                }
                
            }
            
        }
    }
    
     @IBAction func LogInRedirectionDidTapped(_ sender: UIButton) {
     }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
    // if the fields are not correct, return error message
    func validateFields() -> String?{
        // Check that all fields are filled in
        if UsernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        //TODO: check email format
        return nil
    }
    
    func showError(_ message: String){
        //TODO: add alert message
    }
    
    func transitionToHome(){

    }
    

}
