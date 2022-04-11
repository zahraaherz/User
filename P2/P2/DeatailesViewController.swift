//
//  DeatailesViewController.swift
//  P2
//
//  Created by Zahraa Herz on 05/04/2022.
//

import UIKit

class DeatailesViewController: UIViewController {

    @IBOutlet var Image: UIImageView!
    @IBOutlet var Email: UILabel!
    @IBOutlet var FairstName: UILabel!
    @IBOutlet var LastName: UILabel!
    
    var image = UIImage()
    var email = ""
    var FN = ""
    var lN = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Email.text = email
        FairstName.text = FN
        LastName.text = lN
        Image.image = image
        
        // Do any additional setup after loading the view.
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
