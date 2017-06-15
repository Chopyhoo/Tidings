//
//  ViewController.swift
//  Tidings
//
//  Created by Alex on 11/06/2017.
//  Copyright © 2017 Alexey Sobolevski. All rights reserved.
//

import UIKit
import ObjectMapper

class AllNewsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let model = AllNewsModel()
        model.setupConnection()
        
        customFeed()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }

    private func customFeed() {
        let path = Bundle.main.path(forResource: "feed", ofType: "json")
        do {
            let feed = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            let feedMapped: [News]? = Mapper<Feed>().map(JSONString: feed)?.news
            print("hui")
            
        } catch(let error) {
            print(error)
        }

    }
}

