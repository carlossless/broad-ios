//
//  ProgrammeViewController.swift
//  lrt
//
//  Created by Karolis Stasaitis on 8/11/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class ProgrammeViewController : UITableViewController, ModelBased {

    var viewModel: ProgrammeViewModel!
    
    public init() {
        super.init(style: .plain)
        
        navigationItem.title = "Programme"
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(for model: ProgrammeViewModel) {
        self.viewModel = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        tableView.separatorColor = UIColor(hex: 0x373D55)
        tableView.backgroundColor = UIColor(hex: 0x202535)
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(ProgrammeShowCell.self, forCellReuseIdentifier: "Cell")
        
        bind()
    }
    
    func bind() {
        tableView.reactive.reloadData <~ viewModel.shows.map { _ in () }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.reactive.refresh = CocoaAction(viewModel.updateProgramme)
        
        viewModel.updateProgramme.errors.observeValues { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shows.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ProgrammeShowCell
        let model = viewModel.shows.value[indexPath.row]
        cell.configure(for: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
