//
//  ViewController.swift
//  ImagesTestProject
//
//  Created by Anatoly Gurbanov on 13.02.2021.
//

import UIKit

class ImageController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


}

