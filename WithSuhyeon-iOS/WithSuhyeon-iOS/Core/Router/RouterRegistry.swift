//
//  RouterRegistry.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Combine

public class RouterRegistry: Router, ObservableObject {
    @Published public var path: [Destination] = []
    @Published public var selectedTab: MainTab = .home
    @Published public var shouldShowBottomBar: Bool = true
    @Published public var selectedCategory: Int = 0
    
    public init() {}
    
    public func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    public func navigateTab(to tab: MainTab) {
        selectedTab = tab
    }
    
    public func popBack() {
        path.removeLast()
    }
    
    public func insert(destination: Destination, at index: Int) {
        guard index >= 0, index <= path.count else { return }
        path.insert(destination, at: index)
    }
    
    public func remove(at index: Int) {
        guard index >= 0, index < path.count else { return }
        path.remove(at: index)
    }
    
    public func popLast() {
        _ = path.popLast()
    }
    
    public func remove(where condition: (Destination) -> Bool) {
        path.removeAll(where: condition)
    }
    
    public func clear() {
        path.removeAll()
    }
    
    public func replaceWith(_ destination: Destination) {
        path = [destination]
    }
    
    public func navigateReplacingPrevious(to destination: Destination) {
        path.removeAll { $0 == destination }
        path.append(destination)
    }
    
    public func currentDestination() -> Destination? {
        return path.last
    }
    
    public func isEmpty() -> Bool {
        return path.isEmpty
    }
}

