//
//  ProgrammeViewController.swift
//  lrt
//
//  Created by Karolis Stasaitis on 8/11/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

class ProgrammeViewController : UITableViewController, ModelBased {

    var viewModel: ProgrammeViewModel!
    
    public init() {
        super.init(style: .plain)
        
        navigationItem.title = "LRT"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Channels", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: nil, action: nil)
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        bind()
    }
    
    func bind() {
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shows.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StationTableViewCell
        let model = viewModel.shows.value[indexPath.row]
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
