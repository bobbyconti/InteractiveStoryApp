//
//  ViewController.swift
//  InteractiveStoryGame
//
//  Created by Bobby Conti on 4/12/19.
//  Copyright © 2019 Bobby Conti. All rights reserved.
//

import UIKit

// MARK: - ViewController

class ViewController: UIViewController {

    // MARK: - User Interface Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Registers notification observers for showing/hiding the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startAdventure" {
            
            // Checks for valid name entered in text field, throws errors
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw AdventureError.nameNotProvided
                    } else {
                        guard let pageController = segue.destination as? PageController else { return }
                        
                        pageController.page = Adventure.story(withName: name)
                    }
                }
            } catch AdventureError.nameNotProvided {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start the story", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                
                present(alertController, animated: true, completion: nil)
            } catch let error {
                fatalError("\(error.localizedDescription)")
            }
        }
    }
    
    // Shifts text field up when keyboard is shown
    @objc func keyboardWillShow(_ notification: Notification) {
        if let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let frame = keyboardFrame.cgRectValue
            textFieldBottomConstraint.constant = frame.size.height + 10
            
            // Animates text field relocation
            UIView.animate(withDuration: 0.8) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // Shifts text field back into original position when keyboard is hidden
    @objc func keyboardWillHide(_ notification: Notification) {
        textFieldBottomConstraint.constant = 40
        
        // Animates text field relocation
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Deinitializers
    
    // Deallocates memory for all observers
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Extensions

// Resigns first responder back to the ViewController
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
