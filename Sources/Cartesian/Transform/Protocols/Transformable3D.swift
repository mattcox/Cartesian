//
//  Transformable3D.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A type that can be transformed by a Transform.
///
public protocol Transformable3D {
/// The scalar component type of the transforms this object can be transformed
/// by.
///
/// This is named distinctly from `Component` so it does not collide with the
/// `Component` of a conforming type that is itself a vector or matrix.
///
	associatedtype Scalar

/// Transform this object by the provided Transform, mutating this object.
///
/// - Parameters:
///   - transform: The Transform to transform by.
///
	mutating func transform<T: Transform3Protocol>(by transform: T) where T.Component == Scalar

/// Transform this object by the provided Transform, returning the
/// transformed object.
///
/// - Parameters:
///   - transform: The Transform to transform by.
///
/// - Returns: The transformed object.
///
	func transformed<T: Transform3Protocol>(by transform: T) -> Self where T.Component == Scalar
}
