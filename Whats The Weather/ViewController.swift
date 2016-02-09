//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Venkat Kotu on 2/8/16.
//  Copyright © 2016 VenkatKotu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var city: UITextField!
    
    

    
    @IBOutlet weak var result: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
        let url = NSURL(string: "http://www.weather-forecast.com/locations/\(city.text!.stringByReplacingOccurrencesOfString(" ", withString: "-"))/forecasts/latest")
        
        var weather = ""
        if url != nil {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {
                (data, response, error) -> Void in
                
                var urlError = false
                let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if error == nil {
                    //  print(urlContent)
                    
                    let urlContentArray = urlContent?.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    if urlContentArray?.count > 0 {
                        
                        var weatherArray = urlContentArray![1].componentsSeparatedByString("</span>")
                        weather = weatherArray[0] as String
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "%")
                        
                    } else {
                        urlError = true
                    }
                    
                }else {
                    urlError = true
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if urlError == true {
                        self.showError()
                    }else{
                        self.result.text = weather
                    }
                }
                
                
                
                
            })
            task.resume()
        }else{
            
            self.showError()
            
        }

    }
    
    func showError() {
        result.text = "Was not able to find wheater for the city \(city.text). please try again"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

