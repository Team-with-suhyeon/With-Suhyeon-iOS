//
//  WithSuhyeonAgeSelectModal.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonAgeSelectModal: View {
    @Binding var isPresented: Bool
    @State private var selectedAgeRange: String? = nil
    
    let ageRanges = ["20 ~ 24", "25 ~ 29", "30 ~ 34", "35 ~ 39", "40세 이상"]
    
    var body: some View {
        VStack {
            // 모달 핸들바
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.gray200)
                .frame(width: 60, height: 4)
                .padding(.top, 12)
            
            Text("나이대 선택")
                .font(.title02B)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            
            VStack(spacing: 12) {
                ForEach(ageRanges, id: \.self) { range in
                    Button(action: {
                        selectedAgeRange = range
                        print("선택된 나이: \(range)")
                    }) {
                        HStack {
                            Text(range)
                                .font(.body02SB)
                                .foregroundColor(selectedAgeRange == range ? Color.primary600 : Color.gray400)
                            
                            Spacer()
                            
                            if selectedAgeRange == range {
                                Image(.icnPurpleCheck)
                            }
                        }
                        .padding(.leading, 24)
                        .padding(.trailing, 16)
                        .frame(height: 64)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedAgeRange == range ? Color.primary50 : Color.gray25)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(selectedAgeRange == range ? Color.primary100 : Color.clear, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            
            Button(action: {
                print("나이 선택 결과: \(selectedAgeRange ?? "None")")
                isPresented = false
            }) {
                Text("선택완료")
                    .font(.body01B)
                    .foregroundColor(selectedAgeRange != nil ? Color.white : Color.gray400)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(selectedAgeRange != nil ? Color.primary500 : Color.gray200)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 36)
            .disabled(selectedAgeRange == nil)
        }
        .background(Color.white)
        .cornerRadius(24)
    }
}

struct ContentViewView: View {
    @State private var isModalPresented: Bool = false
    
    var body: some View {
        ZStack {
            Button("모달 열기") {
                isModalPresented = true
            }
            .sheet(isPresented: $isModalPresented) {
                WithSuhyeonAgeSelectModal(isPresented: $isModalPresented)
                ///모달창의 높이를 직접 설정하려면 .frame으로 height를 설정하는 게 아니라 sheet의 .presentationDetents 속성을 이용
                    .presentationDetents([.height(598)])
            }
        }
    }
}

#Preview {
    ContentViewView()
}
