//
//  ViewController.swift
//  P2
//
//  Created by Zahraa Herz on 31/03/2022.
//

import UIKit
import Alamofire
import _Concurrency

class ViewController: UIViewController , EditData {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    
    var myAlert: UIAlertController = UIAlertController()
    
    var usersModel = [User]()

    var filteredData: [User]!
    
    var selectedData: User?
    
    var saveData : [User] = []
    
    var isFiltered: Bool = false
    
    var totalPage: Int = 0
        
    var page: Int = 1
    
    var swichViews: Int = 1
   
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        myAlert = self.loader()
        
        self.present(myAlert,animated: false, completion: nil)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        // undo button is visable
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear

        self.fetchUsers { data in
                self.usersModel = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.stopLoader(loader: self.myAlert)
                }
            }
        
        if swichViews == 1 {
            
            collectionView.isHidden = true
            button.setTitle("Go To CollectionView", for: .normal)
            swichViews += 1
         }
        
        filteredData = usersModel
    }
    
    @IBAction func undoButton(_ sender: Any) {
        usersModel.insert(contentsOf: saveData, at: (((saveData.first?.id)!) - 1 ))
        saveData.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func ButtonT(_ sender: Any){
         
       switch swichViews {
           
            case 1:
                tableView.isHidden = false
                collectionView.isHidden = true
           
                (sender as AnyObject).setTitle("Go To CollectionView", for: .normal)
           
                swichViews += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case 2:
                tableView.isHidden = true
                collectionView.isHidden = false
           
                (sender as AnyObject).setTitle("Go To TableView", for: .normal)
           
                swichViews -= 1
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            default:
                break
        }
    }
    
    @IBAction func LogOutBtn(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "In")
    }
    
    func fetchUsers(completion: @escaping ([User])-> () ){
        
        AF.request("https://reqres.in/api/users?page=\(page)", method: .get).response { [self] response in
            guard let data = response.data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(Users.self, from: data)
                totalPage += userData.total!
                if self.page < totalPage {
                    self.usersModel = self.usersModel + userData.data!
                    completion(usersModel)
                    }
                } catch let error {
                    print(error)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "DeatailesS"{
            let secondViewController = segue.destination as! DeatailesViewController
            secondViewController.delegate = self
            secondViewController.user = selectedData
        }// For Table View
        if segue.identifier == "DeatailesCollection" { // for CollectionView
                let secondViewController = segue.destination as! DeatailesViewController
                if let cell = sender as? UICollectionViewCell,
                   let indexPath = self.collectionView.indexPath(for: cell) {
                    secondViewController.delegate = self
                    secondViewController.user =  usersModel[indexPath.row]
            }
        }
    }
    
   func update(userD: User?) {
       
      if let row = self.usersModel.firstIndex(where: {$0.id == userD?.id}){
          usersModel[row] = userD!
          tableView.reloadData()
          collectionView.reloadData()
      }
    }
    
    func loader() -> UIAlertController {
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        return alert
    }
    
    func stopLoader(loader : UIAlertController){
        
        DispatchQueue.main.async {
            
            loader.dismiss(animated: false, completion: nil)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        for cell : UITableViewCell in tableView.visibleCells{
            
            if let indexPath:IndexPath = tableView.indexPath(for: cell){
                
                if indexPath.row + 1 == usersModel.count {
                    
                    page = page + 1
                    self.fetchUsers { data in
                        self.usersModel = data
                       if(self.tableView.isHidden == false ){
                           
                            DispatchQueue.main.async{
                                
                                self.tableView.reloadData()
                                
                            }
                        } else if(self.tableView.isHidden == true ){
                            
                            DispatchQueue.main.async {
                                
                                self.collectionView.reloadData()
                                
                            }
                        }
                    }
                }
            }
        }
    }
} // end viewcontroller

// MARK: - UITableViewDelegate & UITableViewDataSource

extension ViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !isFiltered {
            
            return usersModel.count
            
        } else {
            
            return filteredData.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = isFiltered ? filteredData![indexPath.row] : usersModel[indexPath.row]
        cell.textLabel?.text = user.first_name! + " " + user.last_name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
           selectedData = usersModel[indexPath.row]
           performSegue(withIdentifier: "DeatailesS", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            let cancelAlert = UIAlertController(title: "DELETE!!", message: "User Data will be lost.", preferredStyle: UIAlertController.Style.alert)

            cancelAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
                self.saveData.insert(self.usersModel[indexPath.row], at: 0)
                
                let delayTime = DispatchTime.now() + 3.0
                   DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                       
                       self.navigationItem.leftBarButtonItem?.isEnabled = false
                       self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
                   })
                
                self.usersModel.remove(at: indexPath.row)
                tableView.reloadData()
                
            }))

            cancelAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        
                tableView.setEditing(false, animated: true)

            }))

            self.present(cancelAlert, animated: true, completion: nil)
            
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [delete])
        return swipeConfiguration
        
    }
}

// MARK: - UISearchBarDelegate

extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        isFiltered = false
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText.count == 0{
            
            isFiltered = false
            
        } else {
            
            isFiltered = true
            filteredData = searchText.isEmpty ? usersModel : usersModel.filter({(dataString: User) -> Bool in
            return (dataString.first_name!.range(of: searchText,options: .caseInsensitive) != nil || dataString.last_name!.range(of: searchText,options: .caseInsensitive) != nil)})
        }
       
        tableView.reloadData()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ViewController :  UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !isFiltered {
            return usersModel.count
        } else {
        return filteredData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
            let user = isFiltered ? filteredData![indexPath.row] : usersModel[indexPath.row]
            cell.name.text = user.first_name! + " " + user.last_name!
            let url =  user.avatar!
            cell.image.downloadedFrom(url)
            return cell
     }
}

//LEarn/

//1: Model object passing between view controller
//2: Basic push/pop navigation
//3: What are Higher order functions
//4: iOS Swift Coding standards - need more
