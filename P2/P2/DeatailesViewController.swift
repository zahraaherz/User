//
//  DeatailesViewController.swift
//  P2
//
//  Created by Zahraa Herz on 05/04/2022.
//

import UIKit

protocol editData{
    func updataData(userD: User?)
}

class DeatailesViewController: UIViewController{
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var cancel: UIButton!
 //   @IBOutlet weak var EditImage: UIButton!
    
    var delegate : editData?
    var user: User?

    override func viewDidLoad(){
        super.viewDidLoad()
        
        disableText()
        let url = URL(string: (user?.avatar)!)!
        if let data = try? Data(contentsOf: url){
            image.image = UIImage(data: data)!
        }
    }
    func enableText(){
        email.isEnabled = true
        firstName.isEnabled = true
        lastName.isEnabled = true
        editButton.isHidden = true
        cancel.isHidden = false
        save.isHidden = false
    }
    func disableText(){
        email.isEnabled = false
        firstName.isEnabled = false
        lastName.isEnabled = false
        editButton.isHidden = false
        cancel.isHidden = true
        save.isHidden = true
        email.text = user?.email
        firstName.text = user?.first_name
        lastName.text = user?.last_name
    }
    @IBAction func EditButoon(_ sender: Any){
        self.enableText()
    }
    @IBAction  func Save(_ sender: Any){
        if self.email.text != nil && self.firstName.text != nil && self.lastName.text != nil{
            
            let refreshAlert = UIAlertController(title: "Save", message: "Are you sure you want to modify this user?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (action: UIAlertAction!) in
                user?.email = email.text
                user?.first_name = firstName.text
                user?.last_name = lastName.text
                self.delegate?.updataData(userD: user!)
                self.navigationController?.popViewController(animated: true)
            }))

            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                self.enableText()
            }))

            present(refreshAlert, animated: true, completion: nil)


            
        } else {
            let alertC = UIAlertController(title: "Demo", message: "Please enter text in textField.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertC.addAction(action)
            self.present(alertC, animated: true, completion: nil)
        }
    }
    @IBAction func ImageEdit(_ sender: Any){
        let L = UIImagePickerController()
        L.sourceType = .photoLibrary
        L.delegate = self
        L.allowsEditing = true
        present(L, animated: true)
    }
    @IBAction func Cancel(_ sender: Any){
        let refreshAlert = UIAlertController(title: "Cancel!!", message: "All modification will be lost.", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.disableText()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.enableText()
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
}

extension DeatailesViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let images = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
             image.image = images
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
