//
//  WebSocketClient.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/18/25.
//

import SwiftUI
import Combine

final class WebSocketClient {
    
    static let shared = WebSocketClient()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession: URLSession
    private var cancellables = Set<AnyCancellable>()
    private let subject = PassthroughSubject<String, Never>()
    private var isConnecting = false
    private var retryCount = 0
    private let maxRetryCount = 5
    private let initialRetryInterval: TimeInterval = 2.0
    private var targetType: WebSocketTargetType? = nil
    
    private init() {
        self.urlSession = URLSession(configuration: .default)
    }
    
    func connect(target: WebSocketTargetType) {
        targetType = target
        guard !isConnecting else { return }
        isConnecting = true
            
        guard let url = URL(string: target.baseURL + target.path) else {
            print("❌ Invalid WebSocket URL")
            return
        }
        
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        
        print("✅ WebSocket 연결됨: \(url.absoluteString)")
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("❌ WebSocket 연결 종료")
    }
    
    func sendMessage(_ message: String) {
        let wsMessage = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(wsMessage) { error in
            if let error = error {
                print("❌ WebSocket 메시지 전송 실패: \(error.localizedDescription)")
            } else {
                print("✅ WebSocket 메시지 전송됨: \(message)")
            }
        }
    }
    
    func send<T: Encodable>(_ value: T) {
        do {
            let jsonData = try JSONEncoder().encode(value)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                sendMessage(jsonString)
            }
        } catch {
            print("❌ JSON 인코딩 실패: \(error)")
        }
    }
    
    
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("📩 WebSocket 수신 메시지: \(text)")
                    self.subject.send(text)
                case .data(let data):
                    print("📩 WebSocket 수신 바이너리 데이터: \(data)")
                @unknown default:
                    fatalError()
                }
                
            case .failure(let error):
                print("❌ WebSocket 메시지 수신 실패: \(error.localizedDescription)")
                self.handleConnectionFailure()
            }
            
            //self.receiveMessage()
        }
    }
    
    private func handleConnectionFailure() {
        self.isConnecting = false
        self.retryCount += 1
        
        if retryCount <= maxRetryCount {
            let delay = initialRetryInterval * pow(2.0, Double(retryCount - 1))
            print(" WebSocket 재연결 시도 (횟수: \(retryCount), \(delay)초 후)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let self = self else { return }
                guard let target = self.targetType else { return }
                self.connect(target: target)
            }
        } else {
            print("❌ WebSocket 연결 실패: 최대 재연결 횟수 초과")
        }
    }
    
    func handleAppLifecycleEvents() {
        // 앱이 포그라운드에서 백그라운드로 전환될 때
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.disconnect()
        }
        
        // 앱이 백그라운드에서 포그라운드로 전환될 때
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            // 필요한 경우 다시 연결
            // self.connect(target: yourWebSocketTarget)
        }
        
        // 앱이 종료될 때
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.disconnect()
        }
    }
    
    func messagePublisher() -> AnyPublisher<String, Never> {
        return subject.eraseToAnyPublisher()
    }
}
