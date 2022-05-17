//
//  LogInViewController.swift
//  P2
//
//  Created by Zahraa Herz on 06/04/2022.
//

import UIKit
import Alamofire

class LogInViewController: UIViewController , UISearchBarDelegate{

    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var PassTF: UITextField!
    
    var Ausers = [User]()
    var TotalPage: Int = 0
    var page : Int = 1

    
    @IBOutlet var LoadView: UIView! {
        didSet {
            LoadView.layer.cornerRadius = 6
        }
      }
    
    @IBOutlet var ind: UIActivityIndicatorView!

    let alert = UIAlertController(title: "Erorr!", message: "Incorect Data", preferredStyle: .alert)
        
    var Email = "1"//"Zahra@gmail.com"
    var Pass =  "1"//"hello123"
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)

        hideSpinner()
        if defaults.bool(forKey: "In") {
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController!.setViewControllers([vc], animated:true)
            }
        }
    }

    private func showSpinner() {
      ind.startAnimating()
      LoadView.isHidden = false
    }

    private func hideSpinner() {
      ind.stopAnimating()
      LoadView.isHidden = true
    }

 
    @IBAction func LogInButton(_ sender: Any) {
        
        self.showSpinner()
        Timer.scheduledTimer(withTimeInterval: 2.0 , repeats: false){ [self] (t) in
        if (self.Email == self.EmailTF.text! && self.Pass == self.PassTF.text!)
            {
                hideSpinner()
                self.defaults.set( true , forKey: "In")
                UserDefaults.standard.synchronize()
            }
                else if (self.Email != self.EmailTF.text! || self.Pass != self.PassTF.text!)
            {
                hideSpinner()
                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
                              self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

fileprivate var aview: UIView?

extension LogInViewController
{
    @objc func dismissOnTapOutside()
    {
        self.dismiss(animated: true, completion: nil)
    }

    
}
