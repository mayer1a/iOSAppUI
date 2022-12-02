//
//  FetchDataOperation.swift
//  VKApp
//
//  Created by Artem Mayer on 07.09.22.
//

import UIKit

// MARK: - Operation
class AsyncFetchOperation: Operation {
    
    // MARK: - State
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            "is"+rawValue.description.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        true
    }
    
    override var isReady: Bool {
        super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        state == .executing
    }
    
    override var isFinished: Bool {
        state == .finished
    }
    
    // MARK: - start
    override func start() {
        state = isCancelled ? .finished : .executing

        if state == .executing {
            main()
        }
    }
    
    // MARK: - cancel
    override func cancel() {
        super.cancel()
        state = .finished
    }
}
