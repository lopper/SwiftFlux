//
//  Action.swift
//  SwiftFlux
//
//  Created by Kenichi Yonekawa on 7/31/15.
//  Copyright (c) 2015 mog2dev. All rights reserved.
//

import Foundation

public protocol Action {
    associatedtype Payload
    associatedtype ErrorType: Error = NSError
    func invoke(_ dispatcher: Dispatcher)
}
