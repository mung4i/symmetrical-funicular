//
//  EmptyStateView.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 18/01/2024.
//

import SwiftUI

struct EmptyStateView: View {
    @SwiftUI.Environment(\.colorScheme) private var colorScheme
    
   let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                .fill(colorScheme == .dark ? .black : .white)
                .shadow(
                    color: colorScheme == .dark ? Color.white : Color.black,
                    radius: 4
                )
            
            VStack(alignment: .center) {
                Text(title)
                    .frame(alignment: .center)
            }
            .padding()
        }
        .frame(width: 200, height: 120)
    }
}

#Preview {
    EmptyStateView(title: "No more repositories to browse")
}
