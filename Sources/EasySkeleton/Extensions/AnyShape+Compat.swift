//
//  AnyShape+Compat.swift
//  EasySkeleton
//
//  Provides a type-erased Shape wrapper for iOS 15 compatibility.
//

import SwiftUI

/// A type-erased shape that works on iOS 15+.
/// On iOS 16+, SwiftUI provides `AnyShape` natively; this serves as a backport.
public struct ErasedShape: Shape {
    private let _path: (CGRect) -> Path

    public init<S: Shape>(_ shape: S) {
        self._path = { rect in
            shape.path(in: rect)
        }
    }

    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
