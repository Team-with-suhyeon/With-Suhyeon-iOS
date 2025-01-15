//
//  TermsOfServiceView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct TermsOfServiceView: View {
    @EnvironmentObject var signUpFeature: SignUpFeature
    @State private var agreeStatus: [Bool] = [false, false, false]
    
    var body: some View {
        VStack(alignment: .leading) {
            WithSuhyeonCheckbox(
                state: agreeStatus.allSatisfy { $0 } ? .checked : .unchecked,
                placeholder: "모두 동의",
                hasBackground: true
            ) {
                toggleAllChecks()
            }
            .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(agreeStatus.indices, id: \.self) { index in
                    HStack(alignment: .top, spacing: 12) {
                        WithSuhyeonCheckbox(
                            state: agreeStatus[index] ? .checked : .unchecked,
                            placeholder: getPlaceholder(for: index),
                            hasBackground: false
                        ) {
                            toggleAgreeCheck(at: index)
                        }
                        WithSuhyeonUnderlineButton(title: "보기") {}
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray200, lineWidth: 1)
            )
            Spacer()
        }
        .padding(.horizontal, 16)
        .onChange(of: agreeStatus) { newStatus in
            let allSelected = newStatus.allSatisfy { $0 }
            signUpFeature.updateIsAgree(allSelected)
        }
    }
    
    private func toggleAllChecks() {
        let newState = !agreeStatus.allSatisfy { $0 }
        agreeStatus = Array(repeating: newState, count: agreeStatus.count)
    }
    
    private func toggleAgreeCheck(at index: Int) {
        agreeStatus[index].toggle()
    }
    
    private func getPlaceholder(for index: Int) -> String {
        switch index {
        case 0: return "[필수] 만 18세 이상"
        case 1: return "[필수] 이용약관 동의"
        case 2: return "[필수] 개인정보 처리방침 동의"
        default: return ""
        }
    }
}

#Preview {
    TermsOfServiceView()
}
