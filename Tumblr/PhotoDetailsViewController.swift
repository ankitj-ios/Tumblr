//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Ankit Jasuja on 7/15/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var detailedImageView: UIImageView!
    var detailedImage : UIImage!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailedImageView.image = detailedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
