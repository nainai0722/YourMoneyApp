//
//  GridImageView.swift
//  YourMoneyApp
//
//  Created by 指原奈々 on 2025/04/16.
//

import SwiftUI


struct GridView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State var imageArray = ["bath","eat"]
    let onTap: (String) -> Void
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment:.leading) {
                    LazyVGrid(columns: columns) {
                        ForEach(imageArray, id: \.self){ image in
                            IconView(imageName: image, size: 80, fontsize: 10, onTap: {
                                print(image + "tap")
                                onTap(image)
                            })
                        }
                    }
                }
            }
        }
    }
}



struct IconView: View {
    var imageName: String = "bath"
    var size: CGFloat = 150
    var fontsize: CGFloat = 20
    let onTap: () -> Void
    var body: some View {
        VStack {
            Button(action:{
                onTap()
            }) {
                VStack(spacing: 0) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size * 0.95, height: size * 0.95)
                }
            }
        }
        .frame(width: size, height: size)
        .padding()
        .background(Color.white) // 背景白にする場合
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 3)
        )
        .cornerRadius(12)
    }
}

struct ImageIconView:View {
    var body: some View {
        Image("bath")
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
    }
}

#Preview {
//    GridImageView()
}
