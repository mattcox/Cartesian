//
//  Closest.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that can interrogated for it's closest value to another value.
///
public protocol Closest {
/// A type that defines both the lookup and return type.
///
	associatedtype Element

/// Returns the closest value to the provided element.
///
/// - Parameters:
///   - element: The element to lookup by.
///
/// - Returns: The closest value to the provided element, or nil.
///
	func closest(to element: Element) -> Element?
}
