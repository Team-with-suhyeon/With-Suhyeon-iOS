//
//  BlockingAccountManagementFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation
import Combine

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
            if validatePhoneNumber() {
                addPhoneNumberToBlockingList(state.phoneNumber)
            }
        case .updatePhoneNumber(let phoneNumber):
            updatePhoneNumber(phoneNumber)
        case .deleteBlockedNumber(let phoneNumber):
            deletePhoneNumberFromBlockingList(phoneNumber)
        case .fetchBlockingAccounts:
            fetchBlockingAccounts()
        }
    }
    
    private func addPhoneNumberToBlockingList(_ phoneNumber: String) {
        if state.blockingAccountList.contains(where: { $0.contains(phoneNumber) }) {
            state.errorMessage = "이미 등록된 번호에요"
            return
        }
        state.blockingAccountList.append(phoneNumber)
    }
    
    private func deletePhoneNumberFromBlockingList(_ phoneNumber: String) {
        
    }
    
    private func updatePhoneNumber(_ phoneNumber: String) {
        state.phoneNumber = phoneNumber
    }
    
    private func validatePhoneNumber() -> Bool {
        let myPhoneNumber = "01012341234"
        
        if state.phoneNumber == myPhoneNumber {
            state.errorMessage = "자신의 번호는 차단할 수 없습니다."
            state.isValidPhoneNumber = false
            return false
        } else if state.phoneNumber.count < 11 {
            state.errorMessage = "전화번호 전체를 입력해주세요."
            state.isValidPhoneNumber = false
            return false
        } else if state.phoneNumber.count > 11 {
            state.errorMessage = "번호 길이를 초과했습니다."
            state.isValidPhoneNumber = false
            return false
        }
        
        state.errorMessage = ""
        state.isValidPhoneNumber = true
        return true
    }
    
    private func fetchBlockingAccounts() {
        blockingAccountRepository.fetchBlockingAccounts(){ [weak self] nickname, phoneNumbers in
            self?.state.nickname = nickname
            self?.state.blockingAccountList = phoneNumbers
        }
            /*.receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("✅ 차단 목록 불러오기 성공")
                case .failure(let error):
                    print("❌ 차단 목록 불러오기 실패: \(error)")
                }
            } receiveValue: { [weak self] blockingMembers in
                self?.state.blockingAccountList = blockingMembers.phoneNumbers
                
//                self?.state.blockingAccountList = blockingMembers.flatMap { $0.phoneNumbers }
            }
            .store(in: &cancellables)*/
    }
}
