//
//  ViewController.swift
//  lrt
//
//  Created by Karolis Stasaitis on 06/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

class MainViewController: UITableViewController {
    
    let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.titleView = UIImageView(image: R.image.logo())
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(MainCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.reactive.reloadData <~ viewModel.stations.map { _ in () }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.reactive.refresh = CocoaAction(viewModel.updateStations)
        
        viewModel.updateStations.errors.observeValues { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y - (self.refreshControl!.frame.size.height)), animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            self.refreshControl?.sendActions(for: .valueChanged)
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stations.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let model = viewModel.stations.value[indexPath.row]
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = model.title ?? "¯\\_(ツ)_/¯"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.stations.value[indexPath.row]
        UIApplication.shared.open(model.content, options: [:], completionHandler: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
