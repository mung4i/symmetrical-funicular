//
//  CardView.swift
//  SymmetricalFunicular
//
//  Created by Martin Mungai on 17/01/2024.
//

import SwiftUI

private struct TextView: View {
    let text: String
    let weight: Font.Weight
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(weight)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

struct CardView: View {
    
    let avatar: String
    let description: String
    let name: String
    let username: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                .fill(.white)
                .shadow(radius: 10)
            
            VStack(
                alignment: .leading,
                spacing: 16
            ) {
                HStack {
                    Image(systemName: "person.crop.circle")
                    
                    Text(username)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)
                
                TextView(text: name, weight: .semibold)
                
                TextView(text: description, weight: .regular)
                
                Spacer()
            }
            .padding(20)
        }
        .frame(width: 375, height: 250)
    }
}

#Preview {
    CardView(
        avatar: "",
        description: "Github client to search repositories by username",
        name: "SymmetricalFunicular",
        username: "mung4i"
    )
    .padding(.horizontal, 16)
}
