//
//  TableViewController.swift
//  UXSnappyTableViewTopView
//
//  Created by Michael Nino Evensen on 21/10/2016.
//  Copyright © 2016 Michael Nino Evensen. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // keeps track of if list is expanded or not
    var headerViewActive = false

    // Totalt TableView Content Height
    var totalContentHeight: CGFloat {
        return self.tableView.rowHeight * CGFloat(tableView.numberOfRows(inSection: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Set full height for tableHeaderView
        self.tableView.tableHeaderView?.frame.size.height = self.view.frame.size.height
        
        // Redeclare to update layout
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
        
        // Set contentInset
        if let tableViewHeaderHeight = self.tableView.tableHeaderView?.frame.size.height {
            
            // Set content offset
            self.tableView.contentInset.top = -tableViewHeaderHeight
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Placeholder content
        cell.textLabel?.text = "Label"
        
        return cell
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        // Top and bottom dragging threshold
        let snapThreshold: CGFloat = 65.0
        
        // Animation speed
        let animationSpeed: TimeInterval = 0.4
        
        // Disable paging after you've scrolled past headerView
        if scrollView.contentOffset.y <= (self.view.frame.size.height - snapThreshold) {
            
            if !headerViewActive {
                
                // Include current contentOffset to avoid overriding deceleration
                let contentOffset = scrollView.contentOffset
               
                // Animate
                UIView.animate(withDuration: animationSpeed, animations: {
                    
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -self.totalContentHeight, right: 0)
                    scrollView.contentOffset = contentOffset
                }, completion: { (_) in
                    
                    // Set to active
                    self.headerViewActive = true
                })
            }
        }
        
        if scrollView.contentOffset.y >= snapThreshold, let tableViewHeaderHeight = self.tableView.tableHeaderView?.frame.size.height {
            
            if self.headerViewActive {
                
                // Include current contentOffset to avoid overriding deceleration
                let contentOffset = scrollView.contentOffset
                
                // Animate
                UIView.animate(withDuration: animationSpeed, animations: {
                    
                    scrollView.contentInset = UIEdgeInsets(top: -tableViewHeaderHeight, left: 0, bottom: 0, right: 0)
                    scrollView.contentOffset = contentOffset
                }, completion: { (_) in
                    
                    // Set to inactive
                    self.headerViewActive = false
                })
            }
        }
    }
}
