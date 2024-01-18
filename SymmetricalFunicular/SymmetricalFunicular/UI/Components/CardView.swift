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
    }
}

struct CardView: View {
    @SwiftUI.Environment(\.colorScheme) private var colorScheme
    
    let avatar: String
    let description: String
    let name: String
    let username: String
    let language: String
    let starGazersCount: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                .fill(colorScheme == .dark ? .black : .white)
                .shadow(
                    color: colorScheme == .dark ? Color.white : Color.black,
                    radius: 4
                )
            
            VStack(
                alignment: .leading,
                spacing: 16
            ) {
                HStack {
                    AsyncImage(url: URL(string: avatar), scale: 10)
                        .cornerRadius(15)
                    
                    Text(username)
                        .fontWeight(.semibold)
                }
                
                TextView(text: name, weight: .semibold)
                
                TextView(text: description, weight: .regular)
                
                HStack {
                    Text(language)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                        Text("\(starGazersCount)")
                    }
                    .padding(.leading, 8)
                    .opacity(starGazersCount > 0 ? 1 : 0)

                }
                Spacer()
            }
            .padding(16)
            
        }
        .frame(height: 240)
    }
}

#Preview {
    CardView(
        avatar: "https://avatars.githubusercontent.com/u/25161540?v=4",
        description: "Github client to search repositories by username",
        name: "SymmetricalFunicular",
        username: "mung4i",
        language: "Swift",
        starGazersCount: 14
    )
    .padding(.horizontal, 16)
}
