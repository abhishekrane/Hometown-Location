//
//  MapViewController.swift
//  HomeTownLocation
//
//  Created by Abhishek rane on 11/1/17.
//  Copyright © 2017 Abhishek rane. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{

@IBOutlet weak var Map: MKMapView!
    var i : Int = 0;
    var latitude1 = [Double]()
    var longitude1 = [Double]()
    var nick1 = [String]()
    


    func gettingLatitude() {

        let span:MKCoordinateSpan = MKCoordinateSpanMake(100,100)
        for i in 0...latitude1.count-1 {
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake((latitude1[i]),(longitude1[i]))
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            self.Map.setRegion(region,animated:true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = nick1[i]
            self.Map.addAnnotation(annotation)
         }
     }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingLatitude()
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
