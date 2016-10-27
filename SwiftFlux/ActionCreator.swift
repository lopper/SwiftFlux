//
//  ActionCreator.swift
//  SwiftFlux
//

import Foundation

open class ActionCreator {
    private static let defaultDispatcher = DefaultDispatcher()
    open class var dispatcher: Dispatcher {
        return defaultDispatcher
    }

    open class func invoke<T: Action>(_ action: T) {
        action.invoke(dispatcher)
    }
}
