//
//  SwiftUIView.swift
//  Broad
//
//  Created by Karolis Stasaitis on 02.02.21.
//  Copyright © 2021 delanoir. All rights reserved.
//

import SwiftUI

struct SwiftUISelectionView: View {
    
    @ObservedObject private var viewModel = CombineSelectionViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.stations) { station in
                NavigationLink(destination: SwiftUIChannelView(model: station)) {
                    SwiftUISelectionRowView(model: station)
                }
            }
                .navigationBarTitle(R.string.localization.programme_viewTitle())
                .navigationBarItems(leading:
                    NavigationLink(destination: SwiftUIAboutView()) {
                        Text(R.string.localization.selection_viewAbout())
                    }
                )
        }
    }
}

struct SwiftUISelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISelectionView()
            .preferredColorScheme(.dark)
    }
}
