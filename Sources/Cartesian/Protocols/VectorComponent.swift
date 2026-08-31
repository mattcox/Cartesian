//
//  VectorComponent.swift
//  Cartesian
//
//  Created by Matt Cox on 25/08/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import Foundation

/// A scalar type that can be stored in a vector or matrix.
///
/// `VectorComponent` provides the small set of arithmetic operations that the
/// SIMD-backed vector and matrix types build upon. It exists so that these
/// types can support both floating-point and integer components from a single
/// implementation.
///
/// The Swift standard library deliberately does not vend the checked `+`, `-`
/// and `*` operators (or `sum()`) for integer SIMD vectors, requiring the
/// wrapping `&+`, `&-`, `&*` and `wrappedSum()` variants instead. Because Swift
/// also forbids overlapping conditional conformances, a type cannot simply
/// conform to the vector protocols one way for floating-point scalars and
/// another way for integers. Instead, the arithmetic is funnelled through the
/// requirements below, which are dispatched to the correct standard library
/// operation based on the concrete component type.
///
/// Conforming a custom scalar type is usually as simple as declaring the
/// conformance; default implementations are provided for any type that is also
/// `FloatingPoint` or `FixedWidthInteger`.
///
public protocol VectorComponent: Codable, Comparable, Hashable, SIMDScalar, SignedNumeric {
/// Adds two SIMD vectors of this component together.
///
/// - Parameters:
///   - lhs: The first vector in the addition.
///   - rhs: The second vector in the addition.
///
/// - Returns: The result of adding the two vectors.
///
	static func vectorAdd<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self

/// Subtracts one SIMD vector of this component from another.
///
/// - Parameters:
///   - lhs: The first vector in the subtraction.
///   - rhs: The second vector in the subtraction.
///
/// - Returns: The result of subtracting the second vector from the first.
///
	static func vectorSubtract<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self

/// Multiplies two SIMD vectors of this component together.
///
/// - Parameters:
///   - lhs: The first vector in the multiplication.
///   - rhs: The second vector in the multiplication.
///
/// - Returns: The result of multiplying the two vectors.
///
	static func vectorMultiply<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self

/// Divides one SIMD vector of this component by another.
///
/// - Parameters:
///   - lhs: The vector to be divided.
///   - rhs: The vector to divide by.
///
/// - Returns: The result of dividing the first vector by the second.
///
	static func vectorDivide<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self

/// Negates a SIMD vector of this component.
///
/// - Parameters:
///   - value: The vector to negate.
///
/// - Returns: The negated vector.
///
	static func vectorNegate<Storage: SIMD>(_ value: Storage) -> Storage where Storage.Scalar == Self

/// Computes the sum of all lanes in a SIMD vector of this component.
///
/// - Parameters:
///   - value: The vector to sum.
///
/// - Returns: The sum of all lanes in the vector.
///
	static func vectorSum<Storage: SIMD>(_ value: Storage) -> Self where Storage.Scalar == Self

/// Divides one scalar by another.
///
/// - Parameters:
///   - lhs: The value to be divided.
///   - rhs: The value to divide by.
///
/// - Returns: The result of the division.
///
	static func / (lhs: Self, rhs: Self) -> Self

/// Divides one scalar by another, mutating the first.
///
/// - Parameters:
///   - lhs: The value to be divided. This is updated with the result.
///   - rhs: The value to divide by.
///
	static func /= (lhs: inout Self, rhs: Self)

/// Creates a component value from an integer count.
///
/// This is used to convert a number of components into the component type,
/// for operations such as computing an average.
///
/// - Parameters:
///   - count: The count to convert.
///
	init(vectorCount count: Int)

/// A textual representation of the component, used when describing a vector
/// or matrix that contains it.
///
/// A default implementation is provided that produces a natural description
/// for most types, with floating-point components formatted to three decimal
/// places. Conforming types may override this to customize their formatting.
///
	var vectorDescription: String { get }
}

extension VectorComponent {
	@inlinable
	public var vectorDescription: String {
		String(describing: self)
	}
}

extension VectorComponent where Self: FloatingPoint & CVarArg {
	@inlinable
	public var vectorDescription: String {
		String(format: "%.3f", self)
	}
}

extension VectorComponent where Self: FloatingPoint {
	@inlinable @inline(__always)
	public static func vectorAdd<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self {
		lhs + rhs
	}

	@inlinable @inline(__always)
	public static func vectorSubtract<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self {
		lhs - rhs
	}

	@inlinable @inline(__always)
	public static func vectorMultiply<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self {
		lhs * rhs
	}

	@inlinable @inline(__always)
	public static func vectorDivide<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self {
		lhs / rhs
	}

	@inlinable @inline(__always)
	public static func vectorNegate<Storage: SIMD>(_ value: Storage) -> Storage where Storage.Scalar == Self {
		-value
	}

	@inlinable @inline(__always)
	public static func vectorSum<Storage: SIMD>(_ value: Storage) -> Self where Storage.Scalar == Self {
		value.sum()
	}

	@inlinable @inline(__always)
	public init(vectorCount count: Int) {
		self = Self(count)
	}
}

extension VectorComponent where Self: FixedWidthInteger {
	@inlinable @inline(__always)
	public static func vectorAdd<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self {
		lhs &+ rhs
	}

	@inlinable @inline(__always)
	public static func vectorSubtract<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self {
		lhs &- rhs
	}

	@inlinable @inline(__always)
	public static func vectorMultiply<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self {
		lhs &* rhs
	}

	@inlinable @inline(__always)
	public static func vectorDivide<Storage: SIMD>(_ lhs: Storage, _ rhs: Storage) -> Storage where Storage.Scalar == Self {
		lhs / rhs
	}

	@inlinable @inline(__always)
	public static func vectorNegate<Storage: SIMD>(_ value: Storage) -> Storage where Storage.Scalar == Self {
		Storage() &- value
	}

	@inlinable @inline(__always)
	public static func vectorSum<Storage: SIMD>(_ value: Storage) -> Self where Storage.Scalar == Self {
		value.wrappedSum()
	}

	@inlinable @inline(__always)
	public init(vectorCount count: Int) {
		self = Self(count)
	}
}

extension Double: VectorComponent {}
extension Float: VectorComponent {}

extension Int: VectorComponent {}
extension Int8: VectorComponent {}
extension Int16: VectorComponent {}
extension Int32: VectorComponent {}
extension Int64: VectorComponent {}
