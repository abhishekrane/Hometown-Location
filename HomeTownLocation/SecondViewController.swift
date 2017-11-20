//
//  SecondViewController.swift
//  HomeTownLocation
//
//  Created by Abhishek rane on 11/1/17.
//  Copyright © 2017 Abhishek rane. All rights reserved.
//

import UIKit
var globalCountryList = [Any]()
var selectedCountry = String()
 var selectedYear = Int()
var longitudeSend = [Double]()
var latitudeSend = [Double]()
var nickName = [String]()

class SecondViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet weak var UserTableView: UITableView!
    @IBOutlet weak var countryFilter: UIPickerView!
    @IBOutlet weak var yearFilter: UIPickerView!
    var i = 0;
    var globalYear = ["1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017"]
    
    @IBAction func filterButton(_ sender: Any) {
        
        fetchUser.removeAll()
        latitudeSend.removeAll()
        longitudeSend.removeAll()
        nickName.removeAll()
        
        let url:URL?
        if selectedCountry != "" && selectedYear == 0
        {
            
            url = URL (string: "https://bismarck.sdsu.edu/hometown/users?country=\(selectedCountry)")
        }
        else if selectedYear != 0 && selectedCountry == "" {
            url = URL (string: "https://bismarck.sdsu.edu/hometown/users?year=\(selectedYear)")
        }
        else {
            url = URL (string: "https://bismarck.sdsu.edu/hometown/users?year=\(selectedYear)&country=\(selectedCountry)")
        }
        let session = URLSession.shared
        session.dataTask(with: url!){ (data, response, error) in
            if let response = response {
                print(response)
            }
            else    if (error != nil){
                print("Error")
            }
            if let data = data{
                do{
                    let fetchData = try? JSONSerialization.jsonObject(with: data, options:[])
                    guard let fetchDataArr = fetchData as? [Any] else {return}
                    for eachFetchedUser in fetchDataArr{
                        let eachUser =  eachFetchedUser as! [String : Any]
                        let nickname = eachUser["nickname"] as! String
                        let country = eachUser["country"] as! String
                        let state = eachUser["state"] as! String
                        let city = eachUser["city"] as! String
                        let year = eachUser["year"] as! Float
                        let latitude = eachUser["latitude"] as! Float
                        let longitude = eachUser["longitude"] as! Float
                        self.fetchUser.append(User(nickname: nickname, country: country, state: state, city: city,year:year, latitude: latitude,longitude: longitude))
                        latitudeSend.append(Double(latitude))
                        longitudeSend.append(Double(longitude))
                        nickName.append(nickname)
                    }
                    DispatchQueue.main.async {
                       
                        self.UserTableView.reloadData()
                        
                    }
                }
                catch{
                    print("Error 2")
                }
            }
            }.resume()
      
        
     }
        
    
  
    var fetchUser = [User]()
   
    // Displaying User Data
    func gettingData() {
        guard let url = URL(string: "https://bismarck.sdsu.edu/hometown/users") else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url){ (data, response, error) in
            if let response = response {
                print(response)
            }
            else    if (error != nil){
                print("Error")
            }
            if let data = data{
                do{
                    let fetchData = try? JSONSerialization.jsonObject(with: data, options:[])
                    guard let fetchDataArr = fetchData as? [Any] else {return}
                    for eachFetchedUser in fetchDataArr{
                        let eachUser =  eachFetchedUser as! [String : Any]
                        let nickname = eachUser["nickname"] as! String
                        nicknameList.append(nickname)
                        let country = eachUser["country"] as! String
                        let state = eachUser["state"] as! String
                        let city = eachUser["city"] as! String
                        let year = eachUser["year"] as! Float
                        let latitude = eachUser["latitude"] as! Float
                          let longitude = eachUser["longitude"] as! Float
                        self.fetchUser.append(User(nickname: nickname, country: country, state: state, city: city,year:year, latitude: latitude,longitude: longitude))
                       
                        latitudeSend.append(Double(latitude))
                        longitudeSend.append(Double(longitude))
                        nickName.append(nickname)
                        
                    }
                    DispatchQueue.main.async {
                    
                     self.UserTableView.reloadData()
                    }
                }
                catch{
                    print("Error 2")
                }
            }
        }.resume()
    }
  
     //Displaying Country Filter
    func CountryListData() {
        guard let url = URL(string: "https://bismarck.sdsu.edu/hometown/countries") else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url){ (data, response, error) in
            if let response = response {
                print(response)
            }
            else    if (error != nil){
                print("Error")
            }
            if let data = data{
                do{
                    let fetchData = try? JSONSerialization.jsonObject(with: data, options:[])
                    guard let fetchCountryArr = fetchData as? [String] else {return}
                    for eachFetchedCountry in fetchCountryArr{
                        let eachUser =  eachFetchedCountry
                        
                        globalCountryList.append(eachUser)
                        
                    }
                    if self.countryFilter != nil{
                        self.countryFilter.dataSource = self
                        self.countryFilter.delegate = self
                        self.yearFilter.delegate = self
                        self.yearFilter.dataSource = self
                    }
                }
                catch{
                    print("Error 2")
                }
            }
            }.resume()
        
    }
    

    
 
    override func viewDidLoad() {
      super.viewDidLoad()
      UserTableView.dataSource = self
     
      CountryListData()
      gettingData()
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    class User{
        var nickname: String
        var country: String
        var state : String
        var city: String
        var year: Float
        var latitude:Float
        var longitude : Float
        init(nickname: String,country: String, state: String, city:String,year:Float,latitude:Float,longitude: Float) {
            self.nickname = nickname
            self.country = country
            self.state = state
            self.city = city
            self.year = year
            self.latitude = latitude
            self.longitude = longitude
        }
    }
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchUser.count
    }
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserTableView.dequeueReusableCell(withIdentifier: "cell") as! MyTableViewCell
    
        cell.displayNick.text = fetchUser[indexPath.row].nickname
        cell.displayCountry.text = fetchUser[indexPath.row].country
        cell.displayCity.text = String(fetchUser[indexPath.row].year)
        cell.displayState.text = fetchUser[indexPath.row].state
    
        return cell
    }

    
    
    
    @IBAction func mapViewItem(_ sender: Any) {
        performSegue(withIdentifier: "mapSegue", sender:self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        if segue.destination is MapViewController{
            let vc = segue.destination as? MapViewController
            
            vc?.latitude1 = latitudeSend
            vc?.longitude1 = longitudeSend
            vc?.nick1 = nickName
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int = globalCountryList.count
        if pickerView == yearFilter{
            count = globalYear.count
        }
        
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == countryFilter{
            let title = globalCountryList[row]
            return title as? String
        }
        else if pickerView === yearFilter{
            let title = globalYear[row]
            return title as? String
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryFilter{
            selectedCountry = String(describing: globalCountryList[row])
        }
        else if pickerView === yearFilter
        {
            selectedYear = Int(globalYear[row])!
            
        }
    }

}

