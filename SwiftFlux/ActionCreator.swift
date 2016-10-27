//
//  ActionCreator.swift
//  SwiftFlux
//
//  Created by 江尻 幸生 on 2016/10/27.
//  Copyright © 2016年 mog2dev. All rights reserved.
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
