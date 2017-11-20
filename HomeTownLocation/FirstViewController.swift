//
//  FirstViewController.swift
//  HomeTownLocation
//
//  Created by Abhishek rane on 11/1/17.
//  Copyright © 2017 Abhishek rane. All rights reserved.
//

import UIKit
var globalCountry  = [Any]()
var globalState = [Any]()
var nick = String()
var password = String()
var country = String()
var state = String()
var city = String()
var year = String()
var nicknameList = [String]()
var yearList = ["1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017"]

class FirstViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
   
    
    var selectedCountry : String = ""
    
    @IBOutlet weak var nicknameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var stateTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var yearTextfield: UITextField!
    @IBOutlet weak var longitudeTextfield: UITextField!
    @IBOutlet weak var latitudeTextfield: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var submit: UIButton!

    var latitude = String()
    var longitude = String()
    
    //Enabling submit button
    func checkInput()   {
        nicknameTextfield.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        countryTextfield.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        stateTextfield.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        cityTextfield.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        yearTextfield.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
    }


    @objc func textChanged(_ textField: UITextField) {
        if nicknameTextfield.text == "" || passwordTextfield.text == "" || countryTextfield.text == "" || stateTextfield.text == "" || cityTextfield.text == "" || yearTextfield.text == "" {

            submit.isHidden = true
        
        } else {

            submit.isHidden = false
          }
    }

    
    
    //Getting Latitude and Longitude
    @IBAction func getButton(_ sender: Any) {
        nick = nicknameTextfield.text!
        password = passwordTextfield.text!
        country = countryTextfield.text!
        state = stateTextfield.text!
        city = cityTextfield.text!
        year = yearTextfield.text!
        
        
        performSegue(withIdentifier: "getlocation", sender: self)
        submit.isHidden = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "getlocation") {
            let secondController = segue.destination as! getLocationViewController
            secondController.latitude = latitudeTextfield.text! != "" ? latitudeTextfield.text! : "0"
            secondController.longitude = longitudeTextfield.text! != "" ? longitudeTextfield.text! : "0"
            secondController.stateEntered = stateTextfield.text!
            secondController.CountryEntered = countryTextfield.text!
        }
 
    }
    
    // Submitting Data and Validating
    @IBAction func onSubmit(_ sender: Any) {
    validate()
   
   let parameters = ["nickname":nicknameTextfield.text!,"password":passwordTextfield.text!, "city":cityTextfield.text!,"longitude": Double(longitudeTextfield.text!)!,"state":stateTextfield.text!,"year":Int(yearTextfield.text!)!,"latitude":Double(latitudeTextfield.text!)!,"country":countryTextfield.text!] as [String : Any]
      
        guard let url = URL(string: "https://bismarck.sdsu.edu/hometown/adduser") else {return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options:[]) else {return}
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
        
            if let response = response {
                print (response)
            }
             if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print (json)
                }
                 catch{
                    print(error)
                 }
            }
        }.resume()
        
        self.view.endEditing(true)
     }
    
    
    func CountryData() {
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
                    guard let fetchDataArr = fetchData as? [String] else {return}
                    for eachFetchedCountry in fetchDataArr{
                        let eachUser =  eachFetchedCountry
                        
                        globalCountry.append(eachUser)
                        
                    }
                       if self.countryPicker != nil{
                        self.countryPicker.dataSource = self
                        self.countryPicker.delegate = self
                        }
                    }
                catch{
                    print("Error 2")
                }
            }
            }.resume()
     }
    
    func StateData() {
        
        guard let url = URL(string: "https://bismarck.sdsu.edu/hometown/states?country=\(selectedCountry)") else {return}
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
                    guard let fetchDataArr = fetchData as? [String] else {return}
                    for eachFetchedState in fetchDataArr{
                        let eachUser =  eachFetchedState
                        
                       
                        globalState.append(eachUser)
                        
                    }
                    if self.statePicker != nil{
                        
                        self.statePicker.delegate = self
                        self.statePicker.dataSource = self
                    }
                }
                catch{
                    print("Error 2")
                }
            }
            }.resume()
        
      }
    
    
    
    func validate() {
       
        getNickName()
        
        if(passwordTextfield.text!.isEmpty || (((passwordTextfield.text)?.count)! < 3))
        {
            let alertController = UIAlertController(title: "Alert", message: "Please enter a valid password.It should not be less than 4 characters ",preferredStyle: .alert)
            let Ok = UIAlertAction(title: "Ok", style: .default) { (_) in}
            alertController.addAction(Ok)
            self.present(alertController, animated: true, completion: nil)
            passwordTextfield.text = ""
            
        }
        
        if Int(yearTextfield.text!)! < 1970 || Int(yearTextfield.text!)! > 2017 {
            let alertController = UIAlertController(title: "Alert", message: "Please enter a valid year.",preferredStyle: .alert)
            let Ok = UIAlertAction(title: "Ok", style: .default) { (_) in}
            alertController.addAction(Ok)
            self.present(alertController, animated: true, completion: nil)
            yearTextfield.text = "0";
        }
        
        for name in nicknameList {
            if ((nicknameTextfield.text!).caseInsensitiveCompare(name) == .orderedSame || nicknameTextfield.text!.isEmpty)
            {
                let alertController = UIAlertController(title: "Alert", message: "Please enter an unique nickname.",preferredStyle: .alert)
                let Ok = UIAlertAction(title: "Ok", style: .default) { (_) in}
                alertController.addAction(Ok)
                self.present(alertController, animated: true, completion: nil)
                nicknameTextfield.text = ""
                nicknameList.removeAll()
            }
        }
        
        
    }
    
    func getNickName() {
        
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
                    }
                   
                }catch{
                    print("Error 2")
                }
            }
            }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        nicknameTextfield.text = nick
        passwordTextfield.text = password
        countryTextfield.text = country
        stateTextfield.text = state
        cityTextfield.text = city
        yearTextfield.text = year
        if nicknameTextfield.text == "" || passwordTextfield.text == "" || countryTextfield.text == "" || stateTextfield.text == "" || cityTextfield.text == "" || yearTextfield.text == "" {
           
            submit.isHidden = true
            
        } else {
          
            submit.isHidden = false
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        submit.isHidden = true
        getNickName()
        
         CountryData()
         checkInput()
        
        longitudeTextfield.text = String(log)
        latitudeTextfield.text = String(Lat)
        nicknameTextfield.delegate = self
        passwordTextfield.delegate = self
        countryTextfield.delegate = self
        stateTextfield.delegate = self
        cityTextfield.delegate = self
        yearTextfield.delegate = self
        longitudeTextfield.delegate = self
        latitudeTextfield.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        nicknameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        countryTextfield.resignFirstResponder()
        stateTextfield.resignFirstResponder()
        cityTextfield.resignFirstResponder()
        yearTextfield.resignFirstResponder()
        longitudeTextfield.resignFirstResponder()
        latitudeTextfield.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        nicknameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        countryTextfield.resignFirstResponder()
        stateTextfield.resignFirstResponder()
        cityTextfield.resignFirstResponder()
        yearTextfield.resignFirstResponder()
        latitudeTextfield.resignFirstResponder()
        longitudeTextfield.resignFirstResponder()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count : Int = globalCountry.count
         if pickerView == statePicker
         {
            count = globalState.count
        }
       
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == countryPicker
        {
            let title = globalCountry[row]
            return title as? String
        }
        else if pickerView === statePicker
        {
          
            let title = globalState[row]
           
            return title as? String
        }
    
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPicker
        {   globalState.removeAll()
            stateTextfield.text = "" ;
            selectedCountry = globalCountry[row] as! String
            StateData()
           self.countryTextfield.text = globalCountry[row] as? String
        }
        else if pickerView === statePicker
        {
            self.stateTextfield.text = globalState[row] as? String

        }
    }
    
}

