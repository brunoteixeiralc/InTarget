//
//  Box.swift
//  InTarget
//
//  Created by Bruno Corrêa on 07/07/21.
//

import Foundation

///Boxing: Using property observers to notify observers that a value has changed.
final class Box<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet{
            listener?(value)
        }
    }
    
    init(_ value:T){
        self.value = value
    }
    
    func bind(listener:Listener?){
        self.listener = listener
        listener?(value)
    }
}
