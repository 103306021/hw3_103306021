//
//  MRTListViewController.swift
//  MRT
//
//  Created by Laura Tsai on 2016/12/26.
//  Copyright © 2016年 Laura Tsai. All rights reserved.
//

import UIKit
import ObjectMapper

struct DataSource {  // A collection of lines
    var lines: [Line]
}
struct Line {  // Each lines has a collection of stations
    let name: String  // like "文湖線"
    let stations: [Station]
}
struct Station {
    var name: String  // like "大安"
    var lines: [String: String]  // like ["淡水信義線": "R05", "文湖線": "BR09"]
}

extension Station: Mappable{
    init?(map: Map){}
    mutating func mapping(map: Map){
        self.name <- map["name"]
        self.lines <- map["lines"]
    }
}




class MRTListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let MRTJSONPath = Bundle.main.path(forResource: "MRT.json", ofType: "json")!
        let jsonString = try! String(contentsOfFile: MRTJSONPath)
        
        // This line returns an instance of `Station`
        let station: Station = Station(JSONString: jsonString)!
        
        // This line returns an array with instances of `Station`
        let stations: [Station] = Mapper<Station>().mapArray(JSONString: jsonString)!
      


        // Create a dictionary which keys are line name and values are stations list
        var linesDict = [String: [Station]]()
        for stationDict in stations {
            
            // Enumerate stations and put them into corresponding collections by lines
            for lineName in station.lines.keys {
                // Check if this line's collection exists.
                if linesDict[lineName] == nil {
                    // Create an array to put stations of this line
                    linesDict[lineName] = []
                }
                // Append this station into the array of its lines
                linesDict[lineName]!.append(station)
            }
        }
        // Create a lines array and convert previous dictionary
        // LinesDict should be added in the above for-loop first
        var lines = [Line]()
        for (lineName, stations) in linesDict {
            let line = Line(name: lineName, stations: stations)
            // Put line into the collection of lines
            lines.append(line)
            
        }
//Note: 2017.1.23 Question
        //        self.lines = lines
        
    }
 
//Note: 2017.1.23 Question
//        var Data: DataSource = DataSource.default
        

        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return self.Data.lines.count
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.Data.lines[section].stations.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MRTCell", for: indexPath)
            
            // Get airport object from the index path
            let station = self.Data.lines[indexPath.section].stations[indexPath.row]
            
            // Setup the cell
            cell.textLabel?.text = station.name
            return cell
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return self.Data.lines[section].name
        }
    
    
//  Note:2017.1.23
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return self.stations.lines.count
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.stations.lines[section].count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MRTCell", for: <#T##IndexPath#>)
//        let MRT = self.lines[indexPath.section].MRT[indexPath.row]
//        
//        cell.textLabel?.text = Station.name
//        
//        return cell
//    }
    
    
    
// Note:20161226
//    func tableView(tableView: UITableView,
//                   cellForRowAtIndexPathIndexPath: NSIndexPath)
//        -> UITableViewCell {
//            // 取得 tableView 目前使用的 cell
//            let cell =
//                tableView.dequeueReusableCellWithIdentifier(
//                    "MRTCell", forIndexPath: indexPath) as UITableViewCell
//            
//            if let myLabel = cell.textLabel {myLabel.text =
//                "\(lines[indexPath.section][indexPath.row])"
//            }
//            
//            return cell
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MRTCell", for: MRTJSONPath)
//        
//        cell.textLabel?.text = "\(indexPath.section)"
//        cell.detailTextLabel?.text = "\(indexPath.row)"
    
//        return cell
//    }
    
    // MARK: - Segue
//    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the identifier of the segue
        // Here, we only handle segue we know
        if segue.identifier == "Show" {
            // Get the destination view controller and cast it to our detail view controller class
            guard let detailViewController = segue.destination as? MRTDetailViewController else {
                return
            }
            // Check whether the sender is cell or not, and get its index path
            guard let cell = sender as? UITableViewCell else {
                return
            }
            let indexPath = self.tableView.indexPath(for: cell)!
            
            // Get airport object from the index path
//            let airport = self.stations.lines[indexPath.section].stations[indexPath.row]
            // Tell the detail view controller which airport to show
//            detailViewController.station = station
        } else {
            // Ask the super class to handle segues we don't know
            super.prepare(for: segue, sender: sender)
        }
    }

    
    
    

}











