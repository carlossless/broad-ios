//
//  ProgrammeShowCellModel.swift
//  lrt
//
//  Created by Karolis Stasaitis on 25/12/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

class ProgrammeShowCell: UITableViewCell, ModelBased {
    
    var viewModel: ProgrammeShowCellModel!
    
    var titleLabel: UILabel!
    var programmeLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor(hex: 0x202535)
        selectedBackgroundView = UIView()
        selectedBackgroundView!.backgroundColor = UIColor(hex: 0x161A2C)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        
        programmeLabel = UILabel()
        programmeLabel.font = UIFont.systemFont(ofSize: 12)
        programmeLabel.textColor = UIColor(hex: 0xB8BCC8)
        programmeLabel.numberOfLines = 0
        
        addSubviews(
            titleLabel,
            programmeLabel
        )
        
        let layoutGuide = UILayoutGuide()
        self.addLayoutGuide(layoutGuide)
        
        layoutGuide.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(layoutGuide)
            make.leading.equalTo(layoutGuide)
            make.trailing.equalTo(layoutGuide)
        }
        
        programmeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(layoutGuide)
            make.trailing.equalTo(layoutGuide)
            make.bottom.equalTo(layoutGuide)
        }
    }
    
    func configure(for model: ProgrammeShowCellModel) {
        titleLabel.text = model.name
        programmeLabel.text = model.description
    }
    
}
