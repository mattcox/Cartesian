//
//  Ray.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian
import Units

@Suite("Ray")
struct RayTests {
/// Tests the memberwise initializer stores origin and direction correctly.
///
/// Input:
/// ```swift
/// origin: (1.0, 2.0, 3.0), direction: (0.0, 0.0, 1.0)
/// ```
///
/// Output:
/// ```swift
/// origin.x == 1.0, origin.y == 2.0, origin.z == 3.0
/// direction.x == 0.0, direction.y == 0.0, direction.z == 1.0
/// ```
///
	@Test("Initializer")
	func initializer() async throws {
		let ray = Ray(
			origin: Vector3<Double>(x: 1.0, y: 2.0, z: 3.0),
			direction: Vector3<Double>(x: 0.0, y: 0.0, z: 1.0)
		)
		#expect(ray.origin.x == 1.0)
		#expect(ray.origin.y == 2.0)
		#expect(ray.origin.z == 3.0)
		#expect(ray.direction.x == 0.0)
		#expect(ray.direction.y == 0.0)
		#expect(ray.direction.z == 1.0)
	}

/// Test that two equal rays compare as equal and two different rays compare
/// as not equal.
///
	@Test("Equatable")
	func equatable() async throws {
		let ray = Ray(
			origin: Vector3<Double>(x: 1.0, y: 2.0, z: 3.0),
			direction: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
		)

		let same = Ray(
			origin: Vector3<Double>(x: 1.0, y: 2.0, z: 3.0),
			direction: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
		)

		let different = Ray(
			origin: Vector3<Double>(x: 0.0, y: 0.0, z: 0.0),
			direction: Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
		)

		#expect(ray == same)
		#expect(ray != different)
	}

/// Attempt to encode and decode a ray as JSON.
///
/// The origin and direction should survive the round-trip unchanged.
///
	@Test("Serialization")
	func serialization() async throws {
		let ray = Ray(
			origin: Vector3<Double>(x: 1.0, y: 2.0, z: 3.0),
			direction: Vector3<Double>(x: 0.0, y: 0.0, z: 1.0)
		)

		let encoded = try JSONEncoder().encode(ray)
		let decoded = try JSONDecoder().decode(Ray<Vector3<Double>>.self, from: encoded)

		#expect(decoded.origin.x == ray.origin.x)
		#expect(decoded.origin.y == ray.origin.y)
		#expect(decoded.origin.z == ray.origin.z)
		#expect(decoded.direction.x == ray.direction.x)
		#expect(decoded.direction.y == ray.direction.y)
		#expect(decoded.direction.z == ray.direction.z)
	}
}

extension RayTests {
	@Suite("Point At")
	struct PointAt {
	/// Tests that point(at: 5.0) returns origin + direction * 5.
	///
	/// Input:
	/// ```swift
	/// origin: (1.0, 2.0, 3.0), direction: (0.0, 0.0, 1.0), t: 5.0
	/// ```
	///
	/// Output:
	/// ```swift
	/// (1.0, 2.0, 8.0)
	/// ```
	///
		@Test("point(at:) positive t")
		func pointAt_positiveT() async throws {
			let ray = Ray(
				origin: Vector3<Double>(x: 1.0, y: 2.0, z: 3.0),
				direction: Vector3<Double>(x: 0.0, y: 0.0, z: 1.0)
			)

			let point = ray.point(at: 5.0)

			#expect(point.x.isApproximatelyEqual(to: 1.0))
			#expect(point.y.isApproximatelyEqual(to: 2.0))
			#expect(point.z.isApproximatelyEqual(to: 8.0))
		}

	/// Tests that point(at: 0) returns the origin exactly.
	///
	/// Input:
	/// ```swift
	/// origin: (1.0, 2.0, 3.0), direction: (0.0, 0.0, 1.0), t: 0.0
	/// ```
	///
	/// Output:
	/// ```swift
	/// (1.0, 2.0, 3.0)
	/// ```
	///
		@Test("point(at: 0) equals origin")
		func pointAtZero() async throws {
			let origin = Vector3<Double>(x: 1.0, y: 2.0, z: 3.0)
			let ray = Ray(
				origin: origin,
				direction: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
			)

			let point = ray.point(at: 0.0)

			#expect(point.x.isApproximatelyEqual(to: origin.x))
			#expect(point.y.isApproximatelyEqual(to: origin.y))
			#expect(point.z.isApproximatelyEqual(to: origin.z))
		}

	/// Tests that point(at: 1) returns origin + direction.
	///
	/// Input:
	/// ```swift
	/// origin: (1.0, 2.0, 3.0), direction: (4.0, 5.0, 6.0), t: 1.0
	/// ```
	///
	/// Output:
	/// ```swift
	/// (5.0, 7.0, 9.0)
	/// ```
	///
		@Test("point(at: 1) equals origin plus direction")
		func pointAtOne() async throws {
			let ray = Ray(
				origin: Vector3<Double>(x: 1.0, y: 2.0, z: 3.0),
				direction: Vector3<Double>(x: 4.0, y: 5.0, z: 6.0)
			)

			let point = ray.point(at: 1.0)

			#expect(point.x.isApproximatelyEqual(to: 5.0))
			#expect(point.y.isApproximatelyEqual(to: 7.0))
			#expect(point.z.isApproximatelyEqual(to: 9.0))
		}
	}
}

extension RayTests {
	@Suite("Inverse Direction")
	struct InverseDirection {
	/// Tests that inverseDirection is the component-wise reciprocal.
	///
	/// Input:
	/// ```swift
	/// direction: (2.0, 4.0, 8.0)
	/// ```
	///
	/// Output:
	/// ```swift
	/// inverseDirection: (0.5, 0.25, 0.125)
	/// ```
	///
		@Test("component-wise reciprocal")
		func componentWiseReciprocal() async throws {
			let ray = Ray(
				origin: Vector3<Double>(x: 0.0, y: 0.0, z: 0.0),
				direction: Vector3<Double>(x: 2.0, y: 4.0, z: 8.0)
			)

			let inv = ray.inverseDirection

			#expect(inv.x.isApproximatelyEqual(to: 0.5))
			#expect(inv.y.isApproximatelyEqual(to: 0.25))
			#expect(inv.z.isApproximatelyEqual(to: 0.125))
		}

	/// Tests that a unit direction along X gives (1, +inf, +inf).
	///
	/// Input:
	/// ```swift
	/// direction: (1.0, 0.0, 0.0)
	/// ```
	///
	/// Output:
	/// ```swift
	/// inverseDirection.x == 1.0, inverseDirection.y == +inf, inverseDirection.z == +inf
	/// ```
	///
		@Test("axis-aligned unit direction")
		func axisAlignedUnitDirection() async throws {
			let ray = Ray(
				origin: Vector3<Double>(x: 0.0, y: 0.0, z: 0.0),
				direction: Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
			)

			let inv = ray.inverseDirection

			#expect(inv.x.isApproximatelyEqual(to: 1.0))
			#expect(inv.y == .infinity)
			#expect(inv.z == .infinity)
		}
	}
}

extension RayTests {
	@Suite("2D Ray")
	struct Ray2D {
	/// Tests that Ray<Vector2> works correctly with point(at:).
	///
	/// Input:
	/// ```swift
	/// origin: (3.0, 1.0), direction: (1.0, 0.0), t: 4.0
	/// ```
	///
	/// Output:
	/// ```swift
	/// (7.0, 1.0)
	/// ```
	///
		@Test("point(at:) in 2D")
		func pointAt2D() async throws {
			let ray = Ray(
				origin: Vector2<Double>(x: 3.0, y: 1.0),
				direction: Vector2<Double>(x: 1.0, y: 0.0)
			)

			let point = ray.point(at: 4.0)

			#expect(point.x.isApproximatelyEqual(to: 7.0))
			#expect(point.y.isApproximatelyEqual(to: 1.0))
		}

	/// Tests that inverseDirection works correctly in 2D.
	///
	/// Input:
	/// ```swift
	/// direction: (2.0, 5.0)
	/// ```
	///
	/// Output:
	/// ```swift
	/// inverseDirection: (0.5, 0.2)
	/// ```
	///
		@Test("inverseDirection in 2D")
		func inverseDirection2D() async throws {
			let ray = Ray(
				origin: Vector2<Double>(x: 0.0, y: 0.0),
				direction: Vector2<Double>(x: 2.0, y: 5.0)
			)

			let inv = ray.inverseDirection

			#expect(inv.x.isApproximatelyEqual(to: 0.5))
			#expect(inv.y.isApproximatelyEqual(to: 0.2))
		}
	}
}
