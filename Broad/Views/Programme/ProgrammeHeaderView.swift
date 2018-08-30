//
//  ProgrammeHeaderView.swift
//  Broad
//
//  Created by Karolis Stasaitis on 20/1/18.
//  Copyright © 2018 delanoir. All rights reserved.
//

import Foundation

class ProgrammeHeaderView : UITableViewHeaderFooterView {
    
    var viewModel: ProgrammeShowCellModel!
    
    var titleLabel: UILabel!
    var weekLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        contentView.backgroundColor = UIColor(hex: 0x373D55)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = UIColor.white
        
        weekLabel = UILabel()
        weekLabel.font = UIFont.boldSystemFont(ofSize: 14)
        weekLabel.textColor = UIColor.white
        weekLabel.textAlignment = .right
        
        contentView.addSubviews(
            titleLabel,
            weekLabel
        )
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(4)
            make.leading.equalTo(contentView.snp.leadingMargin)
            make.bottom.equalTo(contentView).offset(-4)
        }
        
        weekLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(4)
            make.leading.equalTo(titleLabel.snp.trailingMargin)
            make.trailing.equalTo(contentView.snp.trailingMargin)
            make.bottom.equalTo(contentView).offset(-4)
        }
    }
    
    func configure(for model: Date) {
        titleLabel.text = model.toString(format: .custom("YYYY MMMM dd"))
        weekLabel.text = model.toString(format: .custom("EEEE"))
    }
    
}
