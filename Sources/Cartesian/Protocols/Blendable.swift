//
//  Blendable.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that can perform a linear blend from one value to another, returning
/// an interpolated value.
///
public protocol Blendable {
/// The type must specify the scalar value type that is used for
/// interpolating between the two values.
///
	associatedtype Blend: Numeric

/// Blend between two values of the same type, by the specified blend
/// amount.
///
/// - Parameters:
///   - from: The value to blend from.
///   - to: The value to blend to.
///   - amount: The blend amount in the range 0...1. A blend amount of 0
///   will return the _from_ value, and a value of 1 will return the _to_
///   value.
///
/// - Returns: An interpolated value in the range _from_..._to_.
///
	static func blend(from: Self, to: Self, by amount: Blend) -> Self
	
/// Blend this value into another value of the same type, by the specified
/// blend amount.
///
/// - Parameters:
///   - other: The other attribute value to blend towards.
///   - amount: The blend amount in the range 0...1. A blend amount of 0
///   will return the _from_ value, and a value of 1 will return the _to_
///   value.
///
	mutating func blend(to other: Self, by amount: Blend)
	
/// Blend this value into another value of the same type, by the specified
/// blend amount, returning the interpolated value.
///
/// - Parameters:
///   - other: The other attribute value to blend towards.
///   - amount: The blend amount in the range 0...1. A blend amount of 0
///   will return the _from_ value, and a value of 1 will return the _to_
///   value.
///
/// - Returns: An interpolated value in the range _from_..._to_.
///
	func blended(to other: Self, by amount: Blend) -> Self
}

extension Blendable {
	public func blended(to other: Self, by amount: Blend) -> Self {
		Self.blend(from: self, to: other, by: amount)
	}
}
