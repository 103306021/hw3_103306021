//
//  StationsListViewController.swift
//  Station
//
//  Created by Laura Tsai on 2016/12/28.
//  Copyright © 2016年 Laura Tsai. All rights reserved.
//

import UIKit

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


extension Station {
    
    //Convert a dictionary into object instances.
    init?(fromDictionary dict: [String: Any]) {
        guard let name = dict["StationName"] as? String else {
            return nil
        }
        self.name = name
        
        let lines = dict["Lines"] as! [String : String]
        self.lines = lines
    }
}


//The following are for plist

enum DataSourceErrorType: Error {
    case fileNotFound
    case invalidContent
}

extension DataSource {
    
    init(contentsOfFile path: String) throws {
        // Read plist into arrray of dictionaries
        guard let stationDictionaries = NSArray(contentsOfFile: path) as? [[String: Any]] else {
            throw DataSourceErrorType.fileNotFound
        }
        
        // Create a dictionary which keys are line name and values are stations list
        var linesDict = [String: [Station]]()
        for stationDict in stationDictionaries {
            guard let station = Station(fromDictionary: stationDict) else {
                throw DataSourceErrorType.invalidContent
            }
            
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
        self.lines = lines
    }
}

extension DataSource {
    private static func loadDefaultSource() -> DataSource {
        // Get default plist from the Bundle
        let dataPath = Bundle.main.path(forResource: "stationsList", ofType: "plist")!
        // Create the source
        guard let source = try? DataSource(contentsOfFile: dataPath) else {
            fatalError()
        }
        return source
    }
    
    static let `default`: DataSource = loadDefaultSource()
}








//--------------------
class StationsListViewController: UITableViewController {
    
    var Data: DataSource = DataSource.default

    override func viewDidLoad() {
        super.viewDidLoad()
    }

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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
