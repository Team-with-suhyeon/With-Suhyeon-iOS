//
//  WithSuhyeonLocationSelect.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/15/25.
//

import SwiftUI

struct WithSuhyeonLocationSelect: View {
    let withSuhyeonLocation: [Region]
    let selectedMainLocationIndex: Int
    let selectedSubLocationIndex: Int?
    let onTabSelected: (Int, Int) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(withSuhyeonLocation.indices, id:\.self) { index in
                        ZStack {
                            Text(withSuhyeonLocation[index].location)
                                .font(.body02SB)
                                .foregroundColor(selectedMainLocationIndex == index ? Color.white : Color.black)
                                .padding(.vertical, 9)
                                .padding(.leading, 12)
                                .padding(.trailing, 42)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedMainLocationIndex == index ? Color.primary500 : Color.clear)
                                )
                        }
                        .frame(height: 50)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if(selectedMainLocationIndex != index) {
                                onTabSelected(index, 0)
                            }
                        }
                    }
                }.padding(.leading, 16)
                    .padding(.trailing, 8)
            }
            Divider()
                .foregroundColor(.gray100)
            if selectedMainLocationIndex == -1 { Spacer() } else {
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(withSuhyeonLocation[selectedMainLocationIndex].subLocation.indices, id:\.self) { index in
                            ZStack(alignment: .leading) {
                                HStack {
                                    Text(withSuhyeonLocation[selectedMainLocationIndex].subLocation[index])
                                        .font(.body03SB)
                                        .foregroundColor(.gray500)
                                    Spacer()
                                }
                                .padding(.leading, 12)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedSubLocationIndex == index ? Color.primary50 : Color.clear)
                                )
                                .frame(width: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onTabSelected(selectedMainLocationIndex, index)
                                }
                            }
                            .frame(height: 50)
                            .padding(.leading, 8)
                            .padding(.trailing, 16)
                        }
                    }}
            }
        }.frame(height: .infinity)
    }
}

struct locationPreview: View {
    @State var selectedMainLocationIndex: Int = 0
    @State var selectedSubLocationIndex: Int = 0
    
    var body: some View {
        VStack {
            WithSuhyeonLocationSelect(withSuhyeonLocation: [], selectedMainLocationIndex: selectedMainLocationIndex, selectedSubLocationIndex: selectedSubLocationIndex, onTabSelected: { num1, num2 in
                selectedMainLocationIndex = num1
                selectedSubLocationIndex = num2
            })
        }.frame(height: 400)
    }
}

#Preview {
    locationPreview()
}
