//
//  SwiftUISelectionRowView.swift
//  Broad
//
//  Created by Karolis Stasaitis on 02.02.21.
//  Copyright © 2021 delanoir. All rights reserved.
//

import SwiftUI

struct SwiftUISelectionRowView: View {
    @ObservedObject private var viewModel: CombineSelectionRowViewModel
    
    init(model: StationTableCellModel) {
        self.viewModel = CombineSelectionRowViewModel()
        self.viewModel.load(model: model)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(viewModel.title ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Text(viewModel.name ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }.frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity, minHeight: 75, idealHeight: 75, maxHeight: 75)
            if let thumbnail = viewModel.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 75)
                    .background(Color.black)
                    .cornerRadius(10)
            }
        }
    }
}

struct SwiftUISelectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISelectionRowView(model: StationTableCellModel(id: "sdsd", name: "zxczc", title: "sdad", playlistUrl: URL(string:"http://test")!, thumbnailManager: ThumbnailManager.init()))
            .previewLayout(.sizeThatFits)
    }
}
