//
//  Dispatcher.swift
//  SwiftFlux
//
//  Created by Kenichi Yonekawa on 7/31/15.
//  Copyright (c) 2015 mog2dev. All rights reserved.
//

import Foundation
import Result

public typealias DispatchToken = String

public protocol Dispatcher {
    func dispatch<T: Action>(_ action: T, result: Result<T.Payload, T.ErrorType>)
    func register<T: Action>(_ type: T.Type, handler: @escaping (Result<T.Payload, T.ErrorType>) -> ()) -> DispatchToken
    func unregister(_ dispatchToken: DispatchToken)
    func waitFor<T: Action>(_ dispatchTokens: [DispatchToken], type: T.Type, result: Result<T.Payload, T.ErrorType>)
}

class DefaultDispatcher: Dispatcher {

    internal enum Status {
        case waiting
        case pending
        case handled
    }

    private var callbacks: [DispatchToken: AnyObject] = [:]

    func dispatch<T : Action>(_ action: T, result: Result<T.Payload, T.ErrorType>) {
        dispatch(type: type(of: action), result: result)
    }

    func register<T : Action>(_ type: T.Type, handler: @escaping (Result<T.Payload, T.ErrorType>) -> ()) -> DispatchToken {
        let nextDispatchToken = NSUUID().uuidString
        callbacks[nextDispatchToken] = DispatchCallback<T>(type: type, handler: handler)
        print(callbacks)
        return nextDispatchToken
    }

    func unregister(_ dispatchToken: DispatchToken) {
        callbacks.removeValue(forKey: dispatchToken)
    }

    func waitFor<T : Action>(_ dispatchTokens: [DispatchToken], type: T.Type, result: Result<T.Payload, T.ErrorType>) {
        for dispatchToken in dispatchTokens {
            guard let callback = callbacks[dispatchToken] as? DispatchCallback<T> else { continue }
            switch callback.status {
            case .handled:
                continue
            case .pending:
                // Circular dependency detected while
                continue
            default:
                invokeCallback(dispatchToken, type: type, result: result)
            }
        }
    }

    private func dispatch<T: Action>(type: T.Type, result: Result<T.Payload, T.ErrorType>) {
        objc_sync_enter(self)

        startDispatching(type)
        for dispatchToken in callbacks.keys {
            invokeCallback(dispatchToken, type: type, result: result)
        }

        objc_sync_exit(self)
    }

    private func startDispatching<T: Action>(_ type: T.Type) {
        for (dispatchToken, _) in callbacks {
            guard let callback = callbacks[dispatchToken] as? DispatchCallback<T> else { continue }
            callback.status = .waiting
        }
    }

    private func invokeCallback<T: Action>(_ dispatchToken: DispatchToken, type: T.Type, result: Result<T.Payload, T.ErrorType>) {
        guard let callback = callbacks[dispatchToken] as? DispatchCallback<T> else { return }
        guard callback.status == .waiting else { return }

        callback.status = .pending
        callback.handler(result)
        callback.status = .handled
    }
}

private class DispatchCallback<T: Action> {
    let type: T.Type
    let handler: (Result<T.Payload, T.ErrorType>) -> ()
    var status = DefaultDispatcher.Status.waiting

    init(type: T.Type, handler: @escaping (Result<T.Payload, T.ErrorType>) -> ()) {
        self.type = type
        self.handler = handler
    }
}
