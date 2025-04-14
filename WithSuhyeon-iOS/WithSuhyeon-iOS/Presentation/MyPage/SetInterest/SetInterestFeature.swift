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
    }
    
    enum Intent {
        case enterScreen
        case updateLocation(Int, Int)
        case submitLocation
    }
    
    enum SideEffect {
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var getRegionsUseCase: GetRegionsUseCase
    @Inject var myPageRepository: MyPageRepository
    
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
        case .submitLocation:
            submitLocation()
        }
    }
    
    private func getRegions() {
        getRegionsUseCase.execute { [weak self] result in
            guard let self = self else { return }
            self.state.regions = result
            self.getMyInterestRegion()
        }
    }
    
    private func getMyInterestRegion() {
        myPageRepository.getMyInterestRegion { [weak self] (interestRegion: MyInterestRegion) in
            guard let self = self else { return }
            if let indexPair = self.findIndex(for: interestRegion.region) {
                self.state.mainLocationIndex = indexPair.mainIndex
                self.state.subLocationIndex = indexPair.subIndex
            } else {
                if let first = self.state.regions.first, !first.subLocation.isEmpty {
                    self.state.mainLocationIndex = 0
                    self.state.subLocationIndex = 0
                }
            }
        }
    }
    
    private func findIndex(for regionStr: String) -> (mainIndex: Int, subIndex: Int)? {
        for (mainIndex, region) in state.regions.enumerated() {
            if region.location == regionStr {
                return (mainIndex, 0)
            }
            if let subIndex = region.subLocation.firstIndex(where: { $0 == regionStr }) {
                return (mainIndex, subIndex)
            }
        }
        return nil
    }
    
    func updateLocation(_ mainIndex: Int, _ subIndex: Int) {
        state.mainLocationIndex = mainIndex
        
        if mainIndex == 0 {
            state.subLocationIndex = 0
        } else {
            state.subLocationIndex = subIndex
        }
    }
    
    func submitLocation() {
        guard state.mainLocationIndex != -1,
              state.regions.indices.contains(state.mainLocationIndex),
              let subIndex = state.subLocationIndex else {
            return
        }
        
        let selectedRegion = state.regions[state.mainLocationIndex]
        let regionString: String
        if selectedRegion.subLocation.indices.contains(subIndex) {
            regionString = selectedRegion.subLocation[subIndex]
        } else {
            regionString = selectedRegion.location
        }
        
        let requestDTO = MyInterestRegionRequestDTO(region: regionString)
        
        myPageRepository.postMyInterestRegion(region: requestDTO) { success in
            if success {
                print("✅ 성공")
            } else {
                print("❌ 실패")
            }
        }
    }
}
