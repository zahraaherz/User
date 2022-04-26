//
//  ViewController.swift
//  P2
//
//  Created by Zahraa Herz on 31/03/2022.
//

import UIKit
import Alamofire
import _Concurrency

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  ,  UICollectionViewDelegate , UICollectionViewDataSource  {
 
    var Ausers = [User]()
    var result: User?
    var page : Int = 1
    var pageC : Int = 1


    @IBOutlet var CollectionView: UICollectionView!
    @IBOutlet var SearchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var Button: UIButton!
    
    var x: Int = 1
    var isTableview: Bool = true
    var isFiltered = false

    var TotalPage: Int = 0
    var filteredData: [User]!
    
    var myAlert: UIAlertController = UIAlertController()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myAlert = self.loader()

        self.present(myAlert,animated: false, completion: nil)

        self.fetchUsers
            { data in
                self.Ausers = data
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                    self.stopLoader(loader: self.myAlert)
                }
            }
        

        if x == 1
        {
           // tableView.isHidden = false
            CollectionView.isHidden = true
            Button.setTitle("Go To CollectionView", for: .normal)
            x += 1
         }
        
        tableView.isHidden = false
        //CollectionView.isHidden = true
                    
        tableView.delegate = self
        tableView.dataSource = self
        
        CollectionView.delegate = self
        CollectionView.dataSource = self

        SearchBar.delegate = self
        filteredData = Ausers

    }

    
    @IBAction func ButtonT(_ sender: Any)
    {
       switch x
        {
            case 1 :
                tableView.isHidden = false
                CollectionView.isHidden = true
                (sender as AnyObject).setTitle("Go To CollectionView", for: .normal)
                x += 1
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
                
            case 2 :
                tableView.isHidden = true
                CollectionView.isHidden = false
                (sender as AnyObject).setTitle("Go To TableView", for: .normal)
                x -= 1
                DispatchQueue.main.async
                {
                    self.CollectionView.reloadData()
                }
            default:
                print("switch default")
        }
    }
    
    
    @IBAction func LogOutBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "In")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.setViewControllers([vc], animated:true)
    }


    func fetchUsers(completion: @escaping ([User])-> () )
    {
        
        AF.request("https://reqres.in/api/users?page=\(page)", method: .get).response { [self]
                response in
                guard let data = response.data else { return }
                do {
                 
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(Users.self, from: data)
                    TotalPage += userData.total!
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
    
   
    func loader() -> UIAlertController
    {
        
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            //present(alert, animated: true, completion: nil)
            return alert
        
    }
    
    func stopLoader(loader : UIAlertController)
    {
            DispatchQueue.main.async
            {
                loader.dismiss(animated: false, completion: nil)
            }
        
    }
      
// ------------------------------------------ functions for paginiation --------------------------------------------
    

    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        for cell : UITableViewCell in tableView.visibleCells
        {
            if let indexPath:IndexPath = tableView.indexPath(for: cell)
            {
                if indexPath.row + 1 == Ausers.count
                {
                    page = page + 1
                    self.fetchUsers
                    { data in
                        self.Ausers = data
                       if(self.tableView.isHidden == false )
                        {
                            DispatchQueue.main.async
                            {
                                self.tableView.reloadData()
                            }
                        }
                        else if(self.tableView.isHidden == true )
                        {
                            DispatchQueue.main.async
                            {
                                self.CollectionView.reloadData()
     
                            }
                        }
                    }
                }
            }
        }
    }
    
    
// ------------------------------------------ TableView ------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isFiltered
        {
            return Ausers.count
            
        }
        else
        {
            return filteredData.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let user = isFiltered ? filteredData![indexPath.row] : Ausers[indexPath.row]
        cell.textLabel?.text = user.first_name! + " " + user.last_name!

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeatailesViewController") as! DeatailesViewController
   
           let user = isFiltered ? filteredData![indexPath.row] : Ausers[indexPath.row]
            
           let url = URL(string: user.avatar!)!
           if let data = try? Data(contentsOf: url)
           {
               vc.image = UIImage(data: data)!
           }
            vc.email = user.email!
            vc.FN = user.first_name!
            vc.lN = user.last_name!
            
            self.navigationController?.pushViewController(vc, animated: true)
    }

// -----------------------------------------------------Search Bar -----------------------------------------------------
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        isFiltered = false
        tableView.reloadData()
        CollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.count == 0
        {
            isFiltered = false
        }
        else
        {
            isFiltered = true
            filteredData = searchText.isEmpty ? Ausers : Ausers.filter({(dataString: User) -> Bool in
            return (dataString.first_name!.range(of: searchText,options: .caseInsensitive) != nil || dataString.last_name!.range(of: searchText,options: .caseInsensitive) != nil)})
        }
       
        tableView.reloadData()
        CollectionView.reloadData()
    }
        
// ---------------------------------------------- Collection View -------------------------------------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if !isFiltered
        {
            return Ausers.count
        }
        else
        {
        return filteredData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
            let user = isFiltered ? filteredData![indexPath.row] : Ausers[indexPath.row]
        
            cell.Name.text = user.first_name! + " " + user.last_name!
        
            let url =  user.avatar!

            cell.Images.downloadedFrom(url)
            
            return cell
     }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DeatailesViewController") as! DeatailesViewController
        
        let user = isFiltered ? filteredData![indexPath.row] : Ausers[indexPath.row]
        let url = URL(string: user.avatar!)!
        if let data = try? Data(contentsOf: url)
        {
            vc.image = UIImage(data: data)!
        }
        vc.email = user.email!
        vc.FN = user.first_name!
        vc.lN = user.last_name!
            
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


