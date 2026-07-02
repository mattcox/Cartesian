//
//  Transformable.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2026.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that can be transformed by a Transform.
///
public protocol Transformable2D {
	associatedtype Component

/// Transform this object by the provided Transform, mutating this object.
///
/// - Parameters:
///   - transform: The Transform to transform by.
///
	mutating func transform<T: Transform2Protocol>(by transform: T) where T.Component == Component
	
/// Transform this object by the provided Transform, returning the
/// transformed object.
///
/// - Parameters:
///   - transform: The Transform to transform by.
///
/// - Returns: The transformed object.
///
	func transform<T: Transform2Protocol>(by transform: T) -> Self where T.Component == Component
}
