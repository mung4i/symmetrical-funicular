//
//  PaginationView.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 18/01/2024.
//

import SwiftUI

struct PaginationView: View {
    
    let isRightButtonEnabled: Bool
    let isLeftButtonEnabled: Bool
    let rightAction: () -> Void
    let leftAction: () -> Void
    
    @SwiftUI.Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                .fill(colorScheme == .dark ? .black : .white)
                .shadow(
                    color: colorScheme == .dark ? Color.white : Color.black,
                    radius: 2.0
                )
            
            VStack(
                alignment: .leading,
                spacing: 16
            ) {
                HStack {
                    Button(
                        action: leftAction,
                        label: {
                            Image(systemName: "arrow.backward.circle")
                                .opacity(isLeftButtonEnabled ? 1 : 0.5)
                        }
                    )
                    .disabled(!isLeftButtonEnabled)
                    
                    Spacer()
                        .frame(maxWidth: 32)
                    
                    Button(
                        action: rightAction,
                        label: {
                            Image(systemName: "arrow.forward.circle")
                                .opacity(isRightButtonEnabled ? 1 : 0.5)
                        }
                    )
                    .disabled(!isRightButtonEnabled)
                }
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            }
        }
        .frame(width: 150, height: 50)
    }
}

#Preview {
    PaginationView(
        isRightButtonEnabled: true,
        isLeftButtonEnabled: true,
        rightAction: {},
        leftAction: {}
    )
}
