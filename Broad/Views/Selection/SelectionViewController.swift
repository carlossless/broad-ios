//
//  ViewController.swift
//  Broad
//
//  Created by Karolis Stasaitis on 06/03/2017.
//  Copyright © 2017 delanoir. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa
import AVKit
import AVFoundation

class SelectionViewController: UITableViewController, ModelBased {
    
    var viewModel: SelectionViewModel!
    
    public init() {
        super.init(style: .plain)
        
        navigationItem.title = "LRT"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: R.string.localization.selection_viewChannels(),
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: R.string.localization.selection_viewAbout(),
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(for model: SelectionViewModel) {
        self.viewModel = model
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        tableView.separatorColor = UIColor(hex: 0x373D55)
        tableView.backgroundColor = UIColor(hex: 0x202535)
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(StationTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        bind()
    }
    
    func bind() {
        navigationItem.leftBarButtonItem?.reactive.pressed = CocoaAction(self.viewModel.openAboutScreen)
        
        tableView.reactive.reloadData <~ viewModel.stations.map { _ in () }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.reactive.refresh = CocoaAction(viewModel.updateStations)
        
        viewModel.updateStations.errors.observeValues { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stations.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StationTableViewCell
        let model = viewModel.stations.value[indexPath.row]
        cell.configure(for: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
