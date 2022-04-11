//
//  ViewController.swift
//  P2
//
//  Created by Zahraa Herz on 31/03/2022.
//

import UIKit
import Alamofire
import _Concurrency

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
 
    
    var Ausers = [User]()
    var result: User?
    var page : Int = 1
    var isFiltered = false

    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
   var filteredData: [User]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        fetchUsers { data in
            self.Ausers = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        SearchBar.delegate = self
        filteredData = Ausers

    }
    
    
    @IBAction func LogOutBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "In")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.setViewControllers([vc], animated:true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      

        for cell:UITableViewCell in tableView.visibleCells {
            
            if let indexPath:IndexPath = tableView.indexPath(for: cell) {
                
                //If we have total number of results , add the condition below
                if indexPath.row + 1 == Ausers.count {
                    page = page + 1
                    fetchUsers { data in
                        self.Ausers = data
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    func fetchUsers(completion: @escaping ([User])-> () )
    {
    
        AF.request("https://reqres.in/api/users?page=\(page)", method: .get).response { [self]
                response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(Users.self, from: data)
                    let TotalPage = userData.total!
                    if self.page < TotalPage
                    {
                        self.Ausers = self.Ausers + userData.data!
                        completion(Ausers)

                    }
                   
                } catch let error {
                    print(error)
                }
            }
    
        }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.filteredData[indexPath.row]
        if !isFiltered {return Ausers.count}
        else{ return filteredData.count} // Ausers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isFiltered {
           let user = isFiltered ? filteredData![indexPath.row] : Ausers[indexPath.row]
            cell.textLabel?.text = user.first_name! + " " + user.last_name! }
        else if !isFiltered {
          cell.textLabel?.text = Ausers[indexPath.row].first_name! + " " +  Ausers[indexPath.row].last_name!
        }//self.filteredData[indexPath]//Ausers[indexPath.row].first_name! + " " +  Ausers[indexPath.row].last_name!
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeatailesViewController") as! DeatailesViewController
        let url = URL(string: Ausers[indexPath.row].avatar!)!
        // Fetch Image Data
        if let data = try? Data(contentsOf: url) {
            // Create Image and Update Image View
            vc.image = UIImage(data: data)!
        }
        //vc.image = AsyncImage(url: URL(string: Ausers[indexPath.row].avatar!))//Ausers[indexPath.row].avatar!
        vc.email = Ausers[indexPath.row].email!
        vc.FN = Ausers[indexPath.row].first_name!
        vc.lN = Ausers[indexPath.row].last_name!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        isFiltered = false
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count == 0 {
            isFiltered = false
        }
        else{
            isFiltered = true
            filteredData = searchText.isEmpty ? Ausers : Ausers.filter({(dataString: User) -> Bool in
            //isFiltered = true
            return (dataString.first_name!.range(of: searchText,options: .caseInsensitive) != nil || dataString.last_name!.range(of: searchText,options: .caseInsensitive) != nil)
        })
        }
       

        tableView.reloadData()
    }
    
    
    
}


