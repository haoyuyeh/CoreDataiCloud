//
//  ViewController.swift
//  CoreDataiCloud
//
//  Created by Hao Yu Yeh on 2023/11/2.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel: ViewControllerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ViewControllerViewModel(delegate: self)
        tableView.delegate = viewModel as? any UITableViewDelegate
        tableView.dataSource = viewModel
    }

    @IBAction func addBtnPressed(_ sender: UIButton) {
        viewModel.addNewItem()
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        viewModel.deleteItem()
    }
}

extension ViewController: ViewControllerViewModelDelegate {
    func itemDidUpdate() {
        tableView.reloadData()
    }
}
