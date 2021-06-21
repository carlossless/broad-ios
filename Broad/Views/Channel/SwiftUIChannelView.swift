//
//  SwiftUIChannelView.swift
//  Broad
//
//  Created by Karolis Stasaitis on 21.02.21.
//  Copyright © 2021 delanoir. All rights reserved.
//

import Foundation

import SwiftUI
import AVKit

struct SwiftUIChannelView: View {
    private var viewModel: StationTableCellModel
    
    init(model: StationTableCellModel) {
        self.viewModel = model
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VideoPlayer(
                player: AVPlayer(url: self.viewModel.playlistUrl)
            ).navigationBarTitle(self.viewModel.name)
            List {

            }
        }
    }
}

struct SwiftUIChannelView_Previews: PreviewProvider {
    static var previews: some View {
//        SwiftUIChannelView()
        HStack {
            
        }
    }
}
