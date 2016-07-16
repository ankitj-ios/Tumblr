//
//  ViewController.swift
//  Tumblr
//
//  Created by Ankit Jasuja on 7/14/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var posts = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        let clientId = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = NSURL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                   delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data,
                    options:[]) as? NSDictionary {
//                    NSLog("response: \(responseDictionary)")
                    let response = responseDictionary["response"] as! NSDictionary
                        self.posts = response["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                }
                
            }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tumblrFeedCell = tableView.dequeueReusableCellWithIdentifier("TumblrFeedCell", forIndexPath: indexPath) as!TumblrFeedTableViewCell
        let post = self.posts[indexPath.row]
        let photos = post["photos"] as! [NSDictionary]
        let firstPhoto = photos[0]
        let originalSize = firstPhoto["original_size"] as! NSDictionary
        let url = originalSize["url"] as! String
        let nsurl = NSURL(string: url);
        let tumblrImageView = tumblrFeedCell.feedImageView as UIImageView
        tumblrImageView.setImageWithURL(nsurl!)
        return tumblrFeedCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let sourceTumblrFeedCell = sender as! TumblrFeedTableViewCell
        let destinationPhotoDetailsViewController = segue.destinationViewController as! PhotoDetailsViewController
        destinationPhotoDetailsViewController.detailedImage = sourceTumblrFeedCell.feedImageView.image
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let clientId = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let postsCategory : [String] = ["humansofnewyork.tumblr.com", "peacecorps.tumblr.com", "pitchersandpoets.tumblr.com"]
        let postsCategoryIndex = randomNumber(0...2)
        let url = NSURL(string: "https://api.tumblr.com/v2/blog/\(postsCategory[postsCategoryIndex])/posts/photo?api_key=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                   delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
          completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data,
                    options:[]) as? NSDictionary {
                    //                    NSLog("response: \(responseDictionary)")
                    let response = responseDictionary["response"] as! NSDictionary
                    self.posts = response["posts"] as! [NSDictionary]
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
                
            }
        });
        task.resume()
    }
    
    func randomNumber(range: Range<Int> = 0...2) -> Int {
        let min = range.startIndex
        let max = range.endIndex
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
}

