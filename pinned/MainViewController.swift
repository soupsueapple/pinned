//
//  MainViewController.swift
//  pinned
//
//  Created by 汤坤 on 2017/4/5.
//  Copyright © 2017年 Kun Soup. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let sbAll = UIStoryboard(name: "All", bundle: nil)
        let sbTages = UIStoryboard(name: "Tags", bundle: nil)
        let sbMark = UIStoryboard(name: "Mark", bundle: nil)
        let sbOther = UIStoryboard(name: "Other", bundle: nil)
        
        let allNavigationViewController = sbAll.instantiateViewController(withIdentifier: "All") as! UINavigationController
        let tagesNavigationViewController = sbTages.instantiateViewController(withIdentifier: "Tags") as! UINavigationController
        let markNavigationViewController = sbMark.instantiateViewController(withIdentifier: "Mark") as! UINavigationController
        let otherNavigationViewController = sbOther.instantiateViewController(withIdentifier: "Other") as! UINavigationController
        
        allNavigationViewController.tabBarItem = UITabBarItem(title: "All", image: nil, tag: 0)
        tagesNavigationViewController.tabBarItem = UITabBarItem(title: "Tags", image: nil, tag: 0)
        markNavigationViewController.tabBarItem = UITabBarItem(title: "Recent", image: nil, tag: 0)
        otherNavigationViewController.tabBarItem = UITabBarItem(title: "Other", image: nil, tag: 0)
        
        self.viewControllers = [allNavigationViewController, tagesNavigationViewController, markNavigationViewController, otherNavigationViewController]
        
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
