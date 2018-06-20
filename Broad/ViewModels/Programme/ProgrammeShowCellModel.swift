//
//  ShowCellModel.swift
//  lrt
//
//  Created by Karolis Stasaitis on 25/12/17.
//  Copyright © 2017 delanoir. All rights reserved.
//

import Foundation

struct ProgrammeShowCellModel : ViewModel {
    
    let id: String
    let name: String
    let description: String?
    let startsAt: Date
    let endsAt: Date
    let thumbnailUrl: URL?
    let linkUrl: URL?
    let archiveUrl: URL?
    
}
