//
//  AuthVC.swift
//  odev4
//
//  Created by Cagla Efendioglu on 12.10.2022.
//

import UIKit
import SnapKit
import Firebase

class AuthVC: UIViewController {
    
    //MARK: Views
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign In"
        label.font = UIFont.systemFont(ofSize: 32)
        return label
    }()
    
    private lazy var signSegmentControl: UISegmentedControl = {
        var segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        let items = ["Sing In", "Sign Up"]
        segment = UISegmentedControl(items: items)
        segment.backgroundColor = .white
        segment.selectedSegmentTintColor = .gray
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: UIControl.State.normal)
        segment.layer.cornerRadius = 8
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.placeholder = "UserName"
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.backgroundColor = textFieldBackColor
        tf.layer.borderWidth = 0.35
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.cornerRadius = 8
        tf.clipsToBounds = true
        tf.font = .boldSystemFont(ofSize: 13)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = UITextField.BorderStyle.roundedRect
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.placeholder = "Password"
        tf.keyboardType = UIKeyboardType.default
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextField.ViewMode.whileEditing
        tf.backgroundColor = textFieldBackColor
        tf.layer.borderWidth = 0.35
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.layer.cornerRadius = 8
        tf.clipsToBounds = true
        tf.font = .boldSystemFont(ofSize: 13)
        return tf
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    //MARK: Properties
    
    private let textFieldBackColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    //MARK: Private Func
    
    private func configure() {
        navigationItem.title = "Auth"
        view.backgroundColor = .white
        view.addSubview(signInLabel)
        view.addSubview(signSegmentControl)
        view.addSubview(userNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        makeUserName()
        makePassword()
        makeSignIn()
        makeSegment()
        makeSignInLabel()
        createSegmentConntrol()
        signIn()
    }
    
    private func createSegmentConntrol() {
        signSegmentControl.addTarget(self, action: #selector(click(_:)), for: .valueChanged)
    }
    
    @objc func click(_ segmentControl: UISegmentedControl) {
        switch signSegmentControl.selectedSegmentIndex {
        case 0:
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        default:
            signInLabel.text = "Sign Up"
            signInButton.setTitle("Sign Up", for: .normal)
        }
    }
    
    private func singTransactions(email: String, password: String) {
        switch signSegmentControl.selectedSegmentIndex {
        case 0:
            //MARK: SING IN
            
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                guard let strongSelf = self else { return }
                
                if error != nil {
                    strongSelf.showWrongSignIn()

                }else{
                    strongSelf.show(TabBarVC(), sender: nil)
                }
                
            }
        default:
            //MARK: SING UP
            
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self]result, error in
                guard let self = self else { return }
                guard error == nil else {
                    
                    self.showCreateAccount(email: email, password: password)
                    return
                }
                self.show(TabBarVC(), sender: nil)
            })
        }
    }
    
    
    
    private func signIn() {
        signInButton.addTarget(self, action: #selector(signIn(_:)), for: .touchUpInside)
    }
    
    @objc func signIn(_ singInButton: UIButton) {
        guard let email = userNameTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            print("Missing field data")
            return
        }
        
        singTransactions(email: email, password: password)
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an aaccount", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Contiune", style: .default, handler: { _ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
                guard error == nil else {
                    print("Account creation failed")
                    return
                }
                
                print("You have signed in")
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        present(alert, animated: true)
    }
    
    func showWrongSignIn() {
        let alert = UIAlertController(title: "Wrong Account", message: "Name or password is incorrect", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
}

extension AuthVC {
    private func makeSignInLabel() {
        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    private func makeSegment() {
        signSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(signInLabel.snp.bottom).offset(72)
            make.left.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
            make.height.equalTo(view.frame.size.height / 25)
        }
    }
    
    private func makeUserName() {
        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(signSegmentControl.snp.bottom).offset(36)
            make.left.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
            make.height.equalTo(view.frame.size.height / 20)
        }
    }
    
    private func makePassword() {
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(36)
            make.left.equalTo(view).offset(32)
            make.right.equalTo(view).offset(-32)
            make.height.equalTo(view.frame.size.height / 20)
        }
    }
    
    private func makeSignIn() {
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-36)
            make.width.equalTo(view.frame.size.width / 2)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
}
