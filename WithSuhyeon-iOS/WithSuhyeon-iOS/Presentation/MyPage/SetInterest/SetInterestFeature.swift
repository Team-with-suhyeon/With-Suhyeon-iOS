//
//  SetInterestFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 3/26/25.
//

import Foundation
import Combine

class SetInterestFeature: Feature {
    struct State {
        var regions: [Region] = []
        var mainLocationIndex: Int = -1
        var subLocationIndex: Int? = nil
        var isLocationSelected: Bool {
            return subLocationIndex != nil
        }
        var buttonEnabled: WithSuhyeonButtonState = .disabled
    }
    
    enum Intent {
        case enterScreen
        case updateLocation(Int, Int)
    }
    
    enum SideEffect {
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var getRegionsUseCase: GetRegionsUseCase
    
    init() {
        bindIntents()
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
        case .enterScreen:
            getRegions()
        case .updateLocation(let mainLocationIndex, let subLocationIndex):
            updateLocation(mainLocationIndex, subLocationIndex)
        }
    }
    
    private func getRegions() {
        getRegionsUseCase.execute { [weak self] result in
            self?.state.regions = result
        }
    }
    
    func updateLocation(_ mainIndex: Int, _ subIndex: Int) {
        state.mainLocationIndex = mainIndex
        
        if mainIndex == 0 {
            state.subLocationIndex = 0
        } else{
            state.subLocationIndex = subIndex
        }
    }
}
