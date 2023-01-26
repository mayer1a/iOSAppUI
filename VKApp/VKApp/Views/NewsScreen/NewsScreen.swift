//
//  NewsScreen.swift
//  VKApp
//
//  Created by Artem Mayer on 12.01.2023.
//

import SwiftUI

struct NewsScreen: View {
    
    // MARK: - Properties

    var body: some View {
        NavigationView {
            List() {
                Text("")
            }
            .listStyle(.plain)
            .navigationBarTitle("Новости", displayMode: .inline)
            .navigationBarBackButtonHidden()
        }
    }
}
