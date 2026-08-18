//
//  ComponentConversion.swift
//  Cartesian
//
//  Created by Matt Cox on 18/08/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian

@Suite("Vector component conversion")
struct VectorComponentConversionTests {
/// Tests narrowing a vector of `Double` into a vector of `Float` with a
/// matching component count.
///
	@Test("Narrowing, matching component count")
	func narrowingMatchingCount() async throws {
		let source = Vector3<Double>(x: 1.5, y: -2.25, z: 3.75)
		let result = Vector3<Float>(converting: source)
		#expect(result.x == 1.5)
		#expect(result.y == -2.25)
		#expect(result.z == 3.75)
	}

/// Tests widening a vector of `Float` into a vector of `Double`.
///
	@Test("Widening, matching component count")
	func wideningMatchingCount() async throws {
		let source = Vector3<Float>(x: 1.5, y: -2.25, z: 3.75)
		let result = Vector3<Double>(converting: source)
		#expect(result.x == 1.5)
		#expect(result.y == -2.25)
		#expect(result.z == 3.75)
	}

/// Tests converting into a vector with more components than the source,
/// which is expected to leave the trailing components zeroed.
///
	@Test("Converting into a larger vector")
	func convertingIntoLargerVector() async throws {
		let source = Vector2<Double>(x: 1.0, y: 2.0)
		let result = Vector4<Float>(converting: source)
		#expect(result.x == 1.0)
		#expect(result.y == 2.0)
		#expect(result.z == .zero)
		#expect(result.w == .zero)
	}

/// Tests converting into a vector with fewer components than the source,
/// which is expected to drop the trailing components.
///
	@Test("Converting into a smaller vector")
	func convertingIntoSmallerVector() async throws {
		let source = Vector4<Double>(x: 1.0, y: 2.0, z: 3.0, w: 4.0)
		let result = Vector2<Float>(converting: source)
		#expect(result.x == 1.0)
		#expect(result.y == 2.0)
	}

/// Tests that narrowing rounds to the nearest representable value, rather
/// than truncating.
///
	@Test("Narrowing rounds to nearest")
	func narrowingRoundsToNearest() async throws {
		let source = Vector3<Double>(x: 0.1, y: 1.0 / 3.0, z: .pi)
		let result = Vector3<Float>(converting: source)
		#expect(result.x == Float(0.1 as Double))
		#expect(result.y == Float(1.0 / 3.0 as Double))
		#expect(result.z == Float(Double.pi))
	}

/// Tests that a component outside the range of the destination type becomes
/// infinite, and that a zero component keeps its sign.
///
	@Test("Narrowing out of range components")
	func narrowingOutOfRange() async throws {
		let source = Vector3<Double>(x: .greatestFiniteMagnitude, y: -.greatestFiniteMagnitude, z: -0.0)
		let result = Vector3<Float>(converting: source)
		#expect(result.x == .infinity)
		#expect(result.y == -.infinity)
		#expect(result.z.sign == .minus)
	}

/// Tests converting between vectors that already share a component type,
/// which is expected to behave like ``init(from:)``.
///
	@Test("Converting between matching component types")
	func convertingMatchingComponentTypes() async throws {
		let source = Vector3<Double>(x: 1.5, y: -2.25, z: 3.75)
		let result = Vector3<Double>(converting: source)
		#expect(result == Vector3<Double>(from: source))
	}
}

@Suite("Matrix component conversion")
struct MatrixComponentConversionTests {
/// Tests narrowing a matrix of `Double` into a matrix of `Float` with
/// matching dimensions.
///
	@Test("Narrowing, matching dimensions")
	func narrowingMatchingDimensions() async throws {
		var source = Matrix4x4<Double>.identity
		for column in 0..<4 {
			for row in 0..<4 {
				source[column, row] = Double((column * 4) + row) + 0.5
			}
		}

		let result = Matrix4x4<Float>(converting: source)
		for column in 0..<4 {
			for row in 0..<4 {
				#expect(result[column, row] == Float((column * 4) + row) + 0.5)
			}
		}
	}

/// Tests widening a matrix of `Float` into a matrix of `Double`.
///
	@Test("Widening, matching dimensions")
	func wideningMatchingDimensions() async throws {
		var source = Matrix3x3<Float>.identity
		source[0, 1] = 2.5
		source[2, 0] = -4.25

		let result = Matrix3x3<Double>(converting: source)
		#expect(result[0, 0] == 1.0)
		#expect(result[0, 1] == 2.5)
		#expect(result[2, 0] == -4.25)
		#expect(result[2, 2] == 1.0)
	}

/// Tests converting into a matrix larger than the source, which is expected
/// to leave the elements outside the source zeroed.
///
	@Test("Converting into a larger matrix")
	func convertingIntoLargerMatrix() async throws {
		var source = Matrix3x3<Double>.identity
		source[1, 2] = 7.5

		let result = Matrix4x4<Float>(converting: source)
		#expect(result[0, 0] == 1.0)
		#expect(result[1, 2] == 7.5)
		#expect(result[3, 3] == .zero)
		#expect(result[0, 3] == .zero)
	}

/// Tests converting into a matrix smaller than the source, which is
/// expected to drop the trailing columns and rows.
///
	@Test("Converting into a smaller matrix")
	func convertingIntoSmallerMatrix() async throws {
		var source = Matrix4x4<Double>.identity
		source[1, 2] = 7.5
		source[3, 3] = 9.0

		let result = Matrix3x3<Float>(converting: source)
		#expect(result[0, 0] == 1.0)
		#expect(result[1, 2] == 7.5)
		#expect(Matrix3x3<Float>.columns == 3)
	}

/// Tests that narrowing rounds each element to the nearest representable
/// value.
///
	@Test("Narrowing rounds to nearest")
	func narrowingRoundsToNearest() async throws {
		var source = Matrix2x2<Double>()
		source[0, 0] = 0.1
		source[1, 1] = .pi

		let result = Matrix2x2<Float>(converting: source)
		#expect(result[0, 0] == Float(0.1 as Double))
		#expect(result[1, 1] == Float(Double.pi))
	}
}
