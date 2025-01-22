//
//  BlockingAccountManagementFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

import Combine
import SwiftUI

class BlockingAccountManagementFeature: Feature {
    struct State {
        var phoneNumber: String = ""
        var isValidPhoneNumber: Bool = true
        var errorMessage: String = ""
        var nickname: String = ""
        var blockingAccountList: [String] = []
    }
    
    enum Intent {
        case tapBlockingAccountButton
        case updatePhoneNumber(String)
        case deleteBlockedNumber(String)
        case fetchBlockingAccounts
    }
    
    enum SideEffect {
        
    }
    
    @Inject private var blockingAccountRepository: BlockingRepository
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    init() {
        bindIntents()
        send(.fetchBlockingAccounts)
    }
    
    private func bindIntents() {
        intentSubject.sink { [weak self] intent in
            self?.handleIntent(intent)
        }.store(in: &cancellables)
    }
    
    func send(_ intent: Intent) {
        intentSubject.send(intent)
    }
    
    func handleIntent(_ intent: Intent) {
        switch intent {
        case .tapBlockingAccountButton:
            addPhoneNumberToBlockingList()
        case .updatePhoneNumber(let phoneNumber):
            updatePhoneNumber(phoneNumber)
        case .deleteBlockedNumber(let phoneNumber):
            deletePhoneNumberFromBlockingList(phoneNumber)
        case .fetchBlockingAccounts:
            fetchBlockingAccounts()
        }
    }
    
    private func addPhoneNumberToBlockingList() {
        withAnimation {
            state.blockingAccountList.insert(state.phoneNumber, at: 0)
        }
        
        blockingAccountRepository.registerBlockingAccount(phoneNumber: state.phoneNumber) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ 차단 계정 등록 성공")
                    self?.state.blockingAccountList.insert(self?.state.phoneNumber ?? "", at: 0)
                    self?.state.phoneNumber = ""
                    self?.state.errorMessage = ""
                case .failure(let error):
                    print("❌ 차단 계정 등록 실패: \(error.localizedDescription)")
                    
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .blockSelfCallBadRequest:
                            self?.state.errorMessage = "본인 번호는 차단할 수 없어요"
                        case .blockFormatBadRequest:
                            self?.state.errorMessage = "전화번호 형식이 맞지 않아요"
                        case .blockAlreadyExistsBadRequest:
                            self?.state.errorMessage = "이미 차단된 번호에요"
                        default:
                            self?.state.errorMessage = ""
                        }
                    } else {
                        self?.state.errorMessage = ""
                    }
                    self?.state.isValidPhoneNumber = false
                    
                    withAnimation {
                        self?.state.blockingAccountList.removeAll { $0 == self?.state.phoneNumber }
                    }
                }
            }
        }
    }
    
    private func deletePhoneNumberFromBlockingList(_ phoneNumber: String) {
        blockingAccountRepository.deleteBlockingAccount(phoneNumber: phoneNumber) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ 차단 계정 삭제 성공")
                    withAnimation {
                        self?.state.blockingAccountList.removeAll { $0 == phoneNumber }
                    }
                    self?.state.errorMessage = ""
                case .failure(let error):
                    print("❌ 차단 계정 삭제 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    private func updatePhoneNumber(_ phoneNumber: String) {
        state.phoneNumber = phoneNumber
    }
    
    private func fetchBlockingAccounts() {
        blockingAccountRepository.fetchBlockingAccounts(){ [weak self] nickname, phoneNumbers in
            self?.state.nickname = nickname
            self?.state.blockingAccountList = phoneNumbers
        }
    }
}
