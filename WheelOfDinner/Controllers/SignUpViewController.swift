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
            // Create cleaned versions of the data
            let username = self.UsernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // User created successfully, store the username
            Auth.auth().createUser(withEmail: email, password: password){ [self] (result,err) in
                // Check for errors
                if err != nil{
                    self.showError("Error creating user")
                }
                else{
                    // Create the user
//                    let db = Firestore.firestore()
                    User.shared.initializeUser(username: username, uid: result!.user.uid)
                    User.shared.FetchData(uid: result!.user.uid)
//                    db.collection("users").document(result!.user.uid).setData(["username":username, "uid": result!.user.uid]){ error in
//                        self.showError("Error saving user data.")
//                    }
                    // Transition to the home page
                    self.transitionToHome()
                }
            }
            
        }
    }
    
     @IBAction func LogInRedirectionDidTapped(_ sender: UIButton) {
     }
    
  
    // if the fields are not correct, return error message
    func validateFields() -> String?{
        // Check that all fields are filled in
        if UsernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        // check email format
        else if !isValidEmail(EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""){
            return "Email format invalid."
        }
        return nil
    }
    
    // Check if the email format is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //when any field is empty, add alert message
    func showError(_ message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // if signup successful, transition from signUp Page to homepage
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    

}
