//
//  Message.swift
//  
//  Copyright © 2020 Apple Inc. All rights reserved.
//
import Foundation
import UIKit

import SpriteKit

// 用于模拟环境（你可以在此定义其他自定义的通信方式）
enum Environment {
    case user
    case live
}

public class Message {
    // 标记消息是否只在游戏中处理
    public static var isLiveViewOnly: Bool = false
    
    static var proxyNameToProxyType = [String: Messagable.Type]()
    
    // 消息队列
    static var messagesAwaitingSend = [(Message, String)]()
    public static var shouldWaitForTouchAcknowledgement: Bool = false
    private static var loaded = false
    private static let messageEnqueingQueue = DispatchQueue(label: "com.apple.MessageEnqueuingQueue")
    
    var encodedPayload: Data
    var playgroundValue: PlaygroundValue
    
    public init(with payload: Sendable, payloadName: String, proxyName: String) {
        self.encodedPayload = payload.encodePayload()
        playgroundValue = .array([.string(proxyName), .string(payloadName), .data(encodedPayload)])
    }
    
    private init() {
        encodedPayload = Data()
        playgroundValue = .string("")
    }
    
    // 注册消息接收器
    static public func registerToReceiveData(as object: Messagable.Type) {
        let typeName = String(describing: type(of: object))
        let splitLine = typeName.split(separator: ".")
        let key = String(splitLine[0])
        // 将接收的消息类型与代理类型进行映射
        proxyNameToProxyType[key] = object
        
        // 在 SpriteKit 中使用某些触发器或回调来处理消息
        if !loaded {
            loaded = true
            // 你可以在这里设置某些事件监听器或回调来模拟 Playground 的行为
        }
    }
    
    // 获取接收消息的进程
    static func getReceiverProcess() -> Environment {
        // 在 SpriteKit 中，你可能不需要与 LiveView 进行交互，可以直接判断消息的目的地
        return .user
    }
    
    // 发送消息
    static public func send(_ thing: Sendable, payload: Any.Type, proxy: AnyClass) {
        let temp = String(describing: payload)
        let splitLine = temp.split(separator: ".")
        let payloadName = splitLine[0]
        let message = Message(with: thing, payloadName: String(payloadName), proxyName: String(describing: proxy))
        let destination = Message.getReceiverProcess()
        
        if isLiveViewOnly {
            // 如果是 LiveView 只有情况，直接接收消息
            self.receive(message.encodedPayload, payloadName: String(payloadName), withType: String(describing: proxy))
        } else {
            if destination == .user {
                // 在用户进程中队列化消息
                enqueue(message, payloadName: String(describing: payload))
            } else {
                // 直接发送消息
                message.playgroundSend()
            }
        }
    }
    
    // 接收消息并进行处理
    static public func receive(_ data: Data, payloadName: String, withType type: String) {
        if let proxyType = proxyNameToProxyType[type] {
            proxyType.decode(data: data, withId: payloadName)
        } else {
            // 处理未找到类型的情况
        }
    }
    
    // 将消息放入队列中
    static func enqueue(_ message: Message, payloadName: String) {
        messageEnqueingQueue.async {
            if shouldWaitForTouchAcknowledgement {
                messagesAwaitingSend.insert((message, payloadName), at: 0)
                return
            }
            message.playgroundSend()
        }
    }
    
    // 在 SpriteKit 中模拟发送消息
    public func playgroundSend() {
        // 你可以使用自定义的回调或通知来替代 Playground 中的 LiveView 消息处理
        // 比如通过 NotificationCenter、闭包或其他代理方法
        NotificationCenter.default.post(name: .messageSent, object: self)
        
        switch Message.getReceiverProcess() {
        case .user:
            // 用户进程中发送消息的逻辑
            print("Message sent to user process.")
        case .live:
            // 直播进程中的消息发送逻辑
            print("Message sent to live view.")
        }
    }
}

// 通知名称
extension Notification.Name {
    static let messageSent = Notification.Name("messageSent")
}

/*
public class Message {
    
    // Set to true in situations where the sender and receiver are the same: messages don’t need to be passed via IPC.
    // For example, when 'user code' and the live view are both running in the same process.
    public static var isLiveViewOnly: Bool = false
    
    static var proxyNameToProxyType = [String: Messagable.Type]()
    public static var messagesAwaitingSend = [(Message, String)]()
    public static var waitingForTouchAcknowledegment: Bool = false
    public static var shouldWaitForTouchAcknowledgement: Bool = false
    public static let current = Message()
    private static var loaded = false
    private static let messageEnqueingQueue = DispatchQueue(label: "com.apple.MessageEnqueuingQueue")
    var encodedPayload: Data
    var playgroundValue: PlaygroundValue
    
    public init (with payload: Sendable, payloadName: String, proxyName: String) {
        self.encodedPayload = payload.encodePayload()
        playgroundValue = .array([.string(proxyName), .string(payloadName), .data(encodedPayload)])
    }
    
    private init() {
        encodedPayload = Data()
        playgroundValue = .string("")
    }
    
    static public func registerToReceiveData(as object: Messagable.Type) {
        let typeName = String(describing: type(of: object))
        let splitLine = typeName.split(separator: ".")
        let key = String(splitLine[0])
        proxyNameToProxyType[key] = object
        
        //setting current as the message delegate
        if !loaded {
            loaded = true
            let page = PlaygroundPage.current
            page.needsIndefiniteExecution = true
            let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
            proxy?.delegate = current
        }
    }
    
    static func getReceiverProcess() -> Environment {
        if PlaygroundPage.current.liveView is PlaygroundRemoteLiveViewProxy {
            return .live //a proxy means this message is being sent from the user process to the live view
        }
        else {
            return .user //no proxy means this message is being send from the live view to the user process
        }
    }
    
    static public func send(_ thing: Sendable, payload: Any.Type, proxy: AnyClass) {
        let temp = String(describing: payload)
        let splitLine = temp.split(separator: ".")
        let payloadName = splitLine[0]
        let message = Message(with: thing, payloadName: String(payloadName), proxyName: String(describing: proxy))
        let destination = Message.getReceiverProcess()
        
        if isLiveViewOnly {
            // Receive the message directly.
            self.receive(message.encodedPayload, payloadName: String(payloadName), withType: String(describing: proxy))
        } else {
            if destination == .user {
                // Queue the message for sending.
                enqueue(message, payloadName: String(describing: payload))
             }
             else  {
                // Send the message.
                 message.playgroundSend()
             }
        }
    }
    
    static public func receive(_ data: Data, payloadName: String, withType type: String) {
        if let proxyType = proxyNameToProxyType[type] {
            proxyType.decode(data: data, withId: payloadName)
        } else {
        }
    }
    
    static func enqueue(_ message: Message, payloadName: String) {
        messageEnqueingQueue.async {
            guard shouldWaitForTouchAcknowledgement else {
                message.playgroundSend()
                return
            }
            if waitingForTouchAcknowledegment {
                messagesAwaitingSend.insert((message, payloadName), at: 0)
                return
            }
            message.playgroundSend()
        }
    }
    
    public func playgroundSend() {
        // If the live view conforms to PlaygroundLiveViewMessageHandler, call its send() method.
        guard let liveViewMessageHandler = PlaygroundPage.current.liveView as? PlaygroundLiveViewMessageHandler else {
            assertionFailure("*** Unable to cast \(String(describing: PlaygroundPage.current.liveView)) as PlaygroundLiveViewMessageHandler ***")
            return
        }
        
        switch Message.getReceiverProcess() {
            case .user:
                Signpost.liveViewMessageSent.event()
            case .live:
                Signpost.userProcessMessageSent.event()
        }
        
        liveViewMessageHandler.send(self.playgroundValue)
    }
}

extension Message: PlaygroundRemoteLiveViewProxyDelegate {
    
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        Message.messagesAwaitingSend.removeAll()
        Message.waitingForTouchAcknowledegment = false
    }
    
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        
        switch Message.getReceiverProcess() {
            case .live:
                Signpost.liveViewMessageReceived.event()
            case .user:
                Signpost.userProcessMessageReceived.event()
        }
        
        guard case let .array(arr) = message else { fatalError("Message must carry a payload") }
        guard case let .string(proxyName) = arr[0] else { fatalError("Message must carry the name of the associated proxy") }
        guard case let .string(payloadName) = arr[1] else { fatalError("Message must carry the name of it's payload") }
        guard case let .data(payload) = arr[2] else { fatalError("Message must carry a payload")}
        
        Message.receive(payload, payloadName: payloadName, withType: proxyName)
    }
}
*/
