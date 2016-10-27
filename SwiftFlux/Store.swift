//
//  Store.swift
//  SwiftFlux
//
//  Created by Kenichi Yonekawa on 7/31/15.
//  Copyright (c) 2015 mog2dev. All rights reserved.
//

import Foundation

public typealias StoreListenerToken = String

public protocol Store: AnyObject {}

private var EventEmitterObjectKey: UInt8 = 0

extension Store {
    private var eventEmitter: EventEmitter {
        guard let eventEmitter = objc_getAssociatedObject(self, &EventEmitterObjectKey) as? EventEmitter else {
            let eventEmitter = DefaultEventEmitter()
            objc_setAssociatedObject(self, &EventEmitterObjectKey, eventEmitter, .OBJC_ASSOCIATION_RETAIN)
            return eventEmitter
        }
        return eventEmitter
    }

    public func subscribe(handler: @escaping () -> ()) -> StoreListenerToken {
        return eventEmitter.subscribe(self, handler: handler)
    }

    public func unsubscribe(listenerToken: StoreListenerToken) {
        eventEmitter.unsubscribe(self, listenerToken: listenerToken)
    }

    public func unsubscribeAll() {
        eventEmitter.unsubscribe(self)
    }

    public func emitChange()  {
        eventEmitter.emitChange(self)
    }
}

public protocol EventEmitter {
    func subscribe<T: Store>(_ store: T, handler: @escaping () -> ()) -> String
    func unsubscribe<T: Store>(_ store: T)
    func unsubscribe<T: Store>(_ store: T, listenerToken: StoreListenerToken)
    func emitChange<T: Store>(_ store: T)
}

public class DefaultEventEmitter: EventEmitter {
    private var eventListeners: [StoreListenerToken: EventListener] = [:]

    public init() {}
    deinit {
        eventListeners.removeAll()
    }

    public func subscribe<T: Store>(_ store: T, handler: @escaping () -> ()) -> StoreListenerToken {
        let nextListenerToken = NSUUID().uuidString
        eventListeners[nextListenerToken] = EventListener(store: store, handler: handler)
        return nextListenerToken
    }

    public func unsubscribe<T: Store>(_ store: T) {
        eventListeners.forEach { (token, listener) -> () in
            if (listener.store === store) {
                eventListeners.removeValue(forKey: token)
            }
        }
    }

    public func unsubscribe<T: Store>(_ store: T, listenerToken: StoreListenerToken) {
        eventListeners.removeValue(forKey: listenerToken)
    }

    public func emitChange<T: Store>(_ store: T) {
        eventListeners.forEach { (_, listener) -> () in
            if (listener.store === store) { listener.handler() }
        }
    }
}

private class EventListener {
    let store: Store
    let handler: () -> ()

    init(store: Store, handler: @escaping () -> ()) {
        self.store = store
        self.handler = handler
    }
}
