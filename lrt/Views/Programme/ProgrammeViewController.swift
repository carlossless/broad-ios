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
        
        tableView.estimatedRowHeight = 44
        
        view.backgroundColor = UIColor.white
        
        tableView.refreshControl = UIRefreshControl()
        
        tableView.separatorColor = UIColor(hex: 0x373D55)
        tableView.backgroundColor = UIColor(hex: 0x202535)
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(ProgrammeHeaderView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.register(ProgrammeShowCell.self, forCellReuseIdentifier: "Cell")
        
        bind()
    }
    
    func bind() {
        tableView.refreshControl!.reactive.refresh = CocoaAction(viewModel.updateProgramme)
        
//        tableView.reactive.reloadData <~ viewModel.shows.producer.map { _ in () }
        
        viewModel.shows.producer
            .take(during: self.reactive.lifetime)
            .observe(on: UIScheduler())
            .startWithValues { [weak self] _ in
                self?.tableView.reloadData()
                if let pair = self?.viewModel.currentShow.value {
                    print(pair)
                    self?.tableView.scrollToRow(at: IndexPath(row: pair.row, section: pair.section), at: .top, animated: false)
                }
            }
        
        viewModel.updateProgramme.errors.observeValues { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // For some reason the tint color has to be applied just before showing the refresh control, otherwise it doesn't get set
        tableView.refreshControl!.tintColor = UIColor.white
        tableView.contentOffset = CGPoint(x: 0, y: -refreshControl!.frame.size.height)
        refreshControl!.beginRefreshing()
        viewModel.updateProgramme.apply().start()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.shows.value.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shows.value[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ProgrammeShowCell
        let model = viewModel.shows.value[indexPath.section].cells[indexPath.row]
        cell.configure(for: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! ProgrammeHeaderView
        view.configure(for: viewModel.shows.value[section].date)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
