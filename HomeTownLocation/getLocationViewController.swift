//
//  getLocationViewController.swift
//  HomeTownLocation
//
//  Created by Abhishek rane on 11/5/17.
//  Copyright © 2017 Abhishek rane. All rights reserved.
//

import UIKit
import MapKit
var Lat : Double = 0.0
var log : Double = 0.0
class getLocationViewController: UIViewController,MKMapViewDelegate,NSMachPortDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var latitude : String = ""
    var longitude : String = ""
    var stateEntered = ""
    var CountryEntered = ""

    @IBAction func button(_ sender: Any) {

        performSegue(withIdentifier: "segue", sender:self)
        
        

    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self.mapView)
            let location = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            Lat = Double(location.latitude)
            log = Double(location.longitude)
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.8,0.8)
            let location2:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(Lat),Double(log))
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location2, span)
            self.mapView.setRegion(region,animated:true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location2
            annotation.title = "You are here"
            self.mapView.addAnnotation(annotation)
           

        }
            
     }
    
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
                        let nickname1 = eachUser["nickname"] as! String
                        let latitude1 = eachUser["latitude"] as! Float
                        let longitude1 = eachUser["longitude"] as! Float
                        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double (latitude1),Double(longitude1))
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = nickname1
                        self.mapView.addAnnotation(annotation)
                
                    }
                   
                }
                catch{
                    print("Error 2")
                }
            }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is FirstViewController
        {
            let vc = segue.destination as? FirstViewController
            vc?.latitude = String(Lat)
            vc?.longitude = String(log)
            vc?.checkInput()
            

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
      gettingData()
        
        if (Double(latitude) == 0.0 && Double(longitude) == 0.0)
        {
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            let searchRequest = MKLocalSearchRequest()
            var SearchParameter = stateEntered
            SearchParameter.append(",")
            SearchParameter.append(CountryEntered)
            searchRequest.naturalLanguageQuery = SearchParameter
            
            let activeSearch = MKLocalSearch(request:searchRequest)
            activeSearch.start{ (response, error) in
                
                if response == nil{
                    print("No response")
                }
                else{
                    
                    let latitude = response?.boundingRegion.center.latitude
                    let longitude = response?.boundingRegion.center.longitude
                    
                    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                    
                    let span = MKCoordinateSpanMake(0.8, 0.8)
                    let region = MKCoordinateRegionMake(coordinate, span)
                    self.mapView.setRegion(region, animated: true)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "You are here"
                    self.mapView.addAnnotation(annotation)
                }
                
            }
        }
        else{
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.8,0.8)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double (latitude)!,Double(longitude)!)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            self.mapView.setRegion(region,animated:true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "You are here"
            self.mapView.addAnnotation(annotation)
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


