//
//  Plane.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian
import Units

@Suite("Plane")
struct PlaneTests {
/// Tests the memberwise init(normal:distance:) stores components correctly.
///
/// Input:
/// ```swift
/// normal: (0.0, 1.0, 0.0), distance: 3.0
/// ```
///
/// Output:
/// ```swift
/// normal.y == 1.0, distance == 3.0
/// ```
///
	@Test("Memberwise Initializer")
	func memberwiseInitializer() async throws {
		let plane = Plane<Double>(
			normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
			distance: 3.0
		)

		#expect(plane.normal.x == 0.0)
		#expect(plane.normal.y == 1.0)
		#expect(plane.normal.z == 0.0)
		#expect(plane.distance == 3.0)
	}

/// Tests init(normal:point:) computes distance as normal.dot(point).
///
/// Input:
/// ```swift
/// normal: (0.0, 1.0, 0.0), point: (0.0, 5.0, 0.0)
/// ```
///
/// Output:
/// ```swift
/// distance == 5.0
/// ```
///
	@Test("Point Initializer")
	func pointInitializer() async throws {
		let normal = Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)
		let point = Vector3<Double>(x: 0.0, y: 5.0, z: 0.0)
		let plane = Plane<Double>(normal: normal, point: point)

		#expect(plane.normal.x == 0.0)
		#expect(plane.normal.y == 1.0)
		#expect(plane.normal.z == 0.0)
		#expect(plane.distance.isApproximatelyEqual(to: 5.0))
	}

/// Tests init(normal:point:) with a non-axis-aligned point.
///
/// Input:
/// ```swift
/// normal: (1.0, 0.0, 0.0), point: (7.0, 3.0, 2.0)
/// ```
///
/// Output:
/// ```swift
/// distance == 7.0  // normal.dot(point) = 1*7 + 0*3 + 0*2 = 7
/// ```
///
	@Test("Point Initializer Non-Axis-Aligned")
	func pointInitializerNonAxisAligned() async throws {
		let normal = Vector3<Double>(x: 1.0, y: 0.0, z: 0.0)
		let point = Vector3<Double>(x: 7.0, y: 3.0, z: 2.0)
		let plane = Plane<Double>(normal: normal, point: point)

		#expect(plane.distance.isApproximatelyEqual(to: 7.0))
	}

/// Tests that two equal planes compare as equal and two different planes
/// compare as not equal.
///
	@Test("Equatable")
	func equatable() async throws {
		let plane = Plane<Double>(
			normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
			distance: 0.0
		)

		let same = Plane<Double>(
			normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
			distance: 0.0
		)

		let different = Plane<Double>(
			normal: Vector3<Double>(x: 1.0, y: 0.0, z: 0.0),
			distance: 5.0
		)

		#expect(plane == same)
		#expect(plane != different)
	}

/// Attempt to encode and decode a plane as JSON.
///
/// The normal and distance should survive the round-trip unchanged.
///
	@Test("Serialization")
	func serialization() async throws {
		let plane = Plane<Double>(
			normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
			distance: 4.5
		)

		let encoded = try JSONEncoder().encode(plane)
		let decoded = try JSONDecoder().decode(Plane<Double>.self, from: encoded)

		#expect(decoded.normal.x == plane.normal.x)
		#expect(decoded.normal.y == plane.normal.y)
		#expect(decoded.normal.z == plane.normal.z)
		#expect(decoded.distance == plane.distance)
	}
}

extension PlaneTests {
	@Suite("Signed Distance")
	struct SignedDistance {
	/// Tests signedDistance(to:) is positive for a point on the front side.
	///
	/// The XZ plane (normal: +Y, distance: 0). A point above (positive Y) is
	/// on the front side and should return a positive signed distance.
	///
	/// Input:
	/// ```swift
	/// plane: normal=(0,1,0) distance=0, point=(0,3,0)
	/// ```
	///
	/// Output:
	/// ```swift
	/// 3.0
	/// ```
	///
		@Test("positive (front side)")
		func positiveFrontSide() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			let d = plane.signedDistance(to: Vector3<Double>(x: 0.0, y: 3.0, z: 0.0))

			#expect(d.isApproximatelyEqual(to: 3.0))
		}

	/// Tests signedDistance(to:) is negative for a point on the back side.
	///
	/// Input:
	/// ```swift
	/// plane: normal=(0,1,0) distance=0, point=(0,-2,0)
	/// ```
	///
	/// Output:
	/// ```swift
	/// -2.0
	/// ```
	///
		@Test("negative (back side)")
		func negativeBackSide() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			let d = plane.signedDistance(to: Vector3<Double>(x: 0.0, y: -2.0, z: 0.0))

			#expect(d.isApproximatelyEqual(to: -2.0))
		}

	/// Tests signedDistance(to:) is zero for a point on the plane.
	///
	/// Input:
	/// ```swift
	/// plane: normal=(0,1,0) distance=0, point=(5,0,-3)
	/// ```
	///
	/// Output:
	/// ```swift
	/// 0.0
	/// ```
	///
		@Test("zero (on plane)")
		func zeroOnPlane() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			let d = plane.signedDistance(to: Vector3<Double>(x: 5.0, y: 0.0, z: -3.0))

			#expect(d.isApproximatelyEqual(to: 0.0))
		}

	/// Tests signedDistance(to:) accounts for a non-zero plane distance.
	///
	/// Plane at y=2 (normal: +Y, distance: 2). A point at y=5 is 3 units above.
	///
	/// Input:
	/// ```swift
	/// plane: normal=(0,1,0) distance=2, point=(0,5,0)
	/// ```
	///
	/// Output:
	/// ```swift
	/// 3.0
	/// ```
	///
		@Test("non-zero plane distance")
		func nonZeroPlaneDist() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 2.0
			)

			let d = plane.signedDistance(to: Vector3<Double>(x: 0.0, y: 5.0, z: 0.0))

			#expect(d.isApproximatelyEqual(to: 3.0))
		}

	/// Tests that signedDistance scales with normal magnitude when the normal
	/// is not unit length.
	///
	/// Plane with normal=(0,2,0) distance=0. For a point at (0,3,0):
	/// signedDistance = normal.dot(point) - distance = 2*3 - 0 = 6.
	///
	/// Input:
	/// ```swift
	/// plane: normal=(0,2,0) distance=0, point=(0,3,0)
	/// ```
	///
	/// Output:
	/// ```swift
	/// 6.0
	/// ```
	///
		@Test("scales with non-unit normal magnitude")
		func scalesWithNonUnitNormal() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 2.0, z: 0.0),
				distance: 0.0
			)

			let d = plane.signedDistance(to: Vector3<Double>(x: 0.0, y: 3.0, z: 0.0))

			#expect(d.isApproximatelyEqual(to: 6.0))
		}
	}
}

extension PlaneTests {
	@Suite("Distance")
	struct Distance {
	/// Tests that distance(to:) is always non-negative.
	///
	/// For a point on the front side the result matches signedDistance.
	/// For a point on the back side the result is the absolute value.
	///
		@Test("always non-negative")
		func alwaysNonNegative() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			let front = plane.distance(to: Vector3<Double>(x: 0.0, y: 3.0, z: 0.0))
			let back = plane.distance(to: Vector3<Double>(x: 0.0, y: -2.0, z: 0.0))

			#expect(front.isApproximatelyEqual(to: 3.0))
			#expect(back.isApproximatelyEqual(to: 2.0))
			#expect(front >= 0.0)
			#expect(back >= 0.0)
		}

	/// Tests that a point on the plane has distance zero.
	///
		@Test("zero for on-plane point")
		func zeroForOnPlane() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			let d = plane.distance(to: Vector3<Double>(x: 1.0, y: 0.0, z: -1.0))

			#expect(d.isApproximatelyEqual(to: 0.0))
		}
	}
}

extension PlaneTests {
	@Suite("Contains")
	struct Contains {
	/// Tests that contains(_:) returns true for a point on the plane.
	///
		@Test("point on plane returns true")
		func pointOnPlane() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			#expect(plane.contains(Vector3<Double>(x: 3.0, y: 0.0, z: -7.0)) == true)
		}

	/// Tests that contains(_:) returns false for a point off the plane.
	///
		@Test("point off plane returns false")
		func pointOffPlane() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			#expect(plane.contains(Vector3<Double>(x: 0.0, y: 1.0, z: 0.0)) == false)
		}
	}
}

extension PlaneTests {
	@Suite("Side")
	struct SideTests {
	/// Tests that side(of:) returns .front for a point on the normal side.
	///
		@Test("front side")
		func frontSide() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			let result = plane.side(of: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0))

			#expect(result == .front)
		}

	/// Tests that side(of:) returns .back for a point on the opposite side.
	///
		@Test("back side")
		func backSide() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			let result = plane.side(of: Vector3<Double>(x: 0.0, y: -1.0, z: 0.0))

			#expect(result == .back)
		}

	/// Tests that side(of:) returns .on for a point lying on the plane.
	///
		@Test("on plane")
		func onPlane() async throws {
			let plane = Plane<Double>(
				normal: Vector3<Double>(x: 0.0, y: 1.0, z: 0.0),
				distance: 0.0
			)

			let result = plane.side(of: Vector3<Double>(x: 5.0, y: 0.0, z: -3.0))

			#expect(result == .on)
		}

	/// Tests the Side enum cases are Equatable and Hashable.
	///
		@Test("Side Equatable and Hashable")
		func sideEquatableAndHashable() async throws {
			let front = Plane<Double>.Side.front
			let back = Plane<Double>.Side.back
			let on = Plane<Double>.Side.on

			#expect(front == .front)
			#expect(back == .back)
			#expect(on == .on)
			#expect(front != back)
			#expect(front != on)
			#expect(back != on)

			// Verify they work as dictionary keys (requires Hashable).
			var dict: [Plane<Double>.Side: Int] = [:]
			dict[.front] = 1
			dict[.back] = 2
			dict[.on] = 3
			#expect(dict[.front] == 1)
			#expect(dict[.back] == 2)
			#expect(dict[.on] == 3)
		}
	}
}
