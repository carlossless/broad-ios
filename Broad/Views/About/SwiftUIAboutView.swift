//
//  SwiftUIAboutView.swift
//  Broad
//
//  Created by Karolis Stasaitis on 02.02.21.
//  Copyright © 2021 delanoir. All rights reserved.
//

import SwiftUI

struct SwiftUIAboutView: View {
    var body: some View {
        Button(action: {
            UIApplication.shared.open(URL(string: "https://delanoir.com")!, options: [:], completionHandler: nil)
        }) {
            Image(uiImage: R.image.delanoirLogo()!)
        }.navigationBarTitle(R.string.localization.selection_viewAbout())
    }
}

struct SwiftUIAboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SwiftUIAboutView()
        }
    }
}
