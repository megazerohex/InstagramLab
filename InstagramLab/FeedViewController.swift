//
//  FeedViewController.swift
//  InstagramLab
//
//  Created by Jamel Peralta Coss on 1/28/16.
//  Copyright © 2016 Jamel Peralta Coss. All rights reserved.
//

import UIKit
import AFNetworking

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //instance variables
    var popularPictures: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 320
        
        networkRequest()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //This method declare how many row the tableview will have
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    //This method is for putting content in the tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        //creates an array of the different contents
        let profiles = popularPictures[indexPath.section]
        let popularPhotoUrl = profiles["images"]!["low_resolution"]!!["url"] as? String   //for images
        let url = NSURL(string: popularPhotoUrl!)
        
        
        //This print each value of an array in the rows
        cell.imagePost.setImageWithURL(url!)
        
        return cell
        
    }
    
    //table section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return popularPictures.count
    }
    
    //for headers
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        let profilePicture = popularPictures[section]
        let profilePictureUrl = profilePicture["user"]!["profile_picture"] as? String
        let url = NSURL(string: profilePictureUrl!)
        profileView.setImageWithURL(url!)
        
        
        // Add a UILabel for the username here
        let usernames = UILabel(frame: CGRect(x: 50, y: 10, width: 100, height: 30))
        let user = popularPictures[section]
        let username = user["user"]!["username"] as? String
        usernames.text = username
        
        headerView.addSubview(profileView)
        headerView.addSubview(usernames)
        return headerView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func networkRequest(){
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //This take the array of all popular Instagram Profiles
                            self.popularPictures = responseDictionary["data"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }
}