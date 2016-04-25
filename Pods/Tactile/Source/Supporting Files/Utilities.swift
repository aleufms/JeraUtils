//
// Utilities.swift
//
// Copyright (c) 2015-2016 Damien (http://delba.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

extension UIControlEvents: Hashable {
    public var hashValue: Int { return Int(rawValue) }
}

internal extension UIGestureRecognizerState {
    static let all = [
        Possible, Began, Changed, Ended, Cancelled, Failed
    ]
}

internal extension UIGestureRecognizer {
    func clone() -> Self {
        let clone = self.dynamicType.init()
        
        downcast(self, and: clone, to: UILongPressGestureRecognizer.self) { a, b in
            b.numberOfTapsRequired    = a.numberOfTapsRequired
            b.numberOfTouchesRequired = a.numberOfTouchesRequired
            b.minimumPressDuration    = a.minimumPressDuration
            b.allowableMovement       = a.allowableMovement
        }
        
        downcast(self, and: clone, to: UIPanGestureRecognizer.self) { a, b in
            b.maximumNumberOfTouches = a.maximumNumberOfTouches
            b.minimumNumberOfTouches = a.minimumNumberOfTouches
        }
        
        downcast(self, and: clone, to: UIScreenEdgePanGestureRecognizer.self) { a, b in
            b.edges = a.edges
        }
        
        downcast(self, and: clone, to: UISwipeGestureRecognizer.self) { a, b in
            b.direction               = a.direction
            b.numberOfTouchesRequired = a.numberOfTouchesRequired
        }
        
        downcast(self, and: clone, to: UITapGestureRecognizer.self) { a, b in
            b.numberOfTapsRequired    = a.numberOfTapsRequired
            b.numberOfTouchesRequired = a.numberOfTouchesRequired
        }
        
        return clone
    }
    
    private func downcast<T, U>(a: T, and b: T, to: U.Type, block: (U, U) -> Void) {
        if let a = a as? U, b = b as? U {
            block(a, b)
        }
    }
}