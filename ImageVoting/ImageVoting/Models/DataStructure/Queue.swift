//
//  Queue.swift
//  ImageVoting
//
//  Created by Tomoki Takasawa on 12/26/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

public struct Queue<T> {
    
    fileprivate var list = LinkedList<T>()
    fileprivate var count: Int
    
    init(){
        self.count = 0
    }
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    public var length: Int {
        return count
    }
    
    public mutating func enqueue(_ element: T) {
        list.append(value: element)
        self.count = self.count + 1
    }
    
    public mutating func enqueue(_ array: [T]) {
        for item in array {
            list.append(value: item)
            self.count = self.count + 1
        }
    }
    
    public mutating func dequeue() -> T? {
        
        guard !list.isEmpty, let element = list.first else { return nil }
        _ = list.remove(node: element)
        self.count = self.count - 1
        return element.value
        
    }
    
    public func peek() -> T? {
        return list.first?.value
    }
}
