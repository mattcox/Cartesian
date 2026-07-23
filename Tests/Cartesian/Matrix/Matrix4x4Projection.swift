//
//  Matrix4x4Projection.swift
//  Cartesian
//
//  Created by Matt Cox on 23/07/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian
import Units

// The projection and view matrices bake in coordinate-system conventions, so
// the expected values here are computed from the closed-form projection maths
// rather than a reference library (simd provides no equivalents). Each test
// verifies both the raw matrix entries and the way known points project.
//

@Suite("Matrix4x4 Projection")
struct Matrix4x4ProjectionTests {
	private static let tolerance = 1e-12

/// A right handed perspective projection into the `[0, 1]` depth range should
/// place the near plane at depth `0`, the far plane at depth `1`, and map the
/// frustum's half extents to `±1`. With a 90° vertical field of view and unit
/// aspect ratio the diagonal x and y scales are both `1`.
///
	@Test("Perspective, Right Handed, Zero to One")
	func perspectiveRightHandedZeroToOne() async throws {
		let matrix = Matrix4x4<Double>.perspective(
			fieldOfView: Angle(degrees: 90.0),
			aspectRatio: 1.0,
			near: 1.0,
			far: 101.0,
			handedness: .rightHanded,
			depthRange: .zeroToOne
		)

		// Diagonal scales, the perspective depth terms, and the w row.
		#expect(matrix[0, 0].isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
		#expect(matrix[1, 1].isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
		#expect(matrix[2, 2].isApproximatelyEqual(to: -1.01, absoluteTolerance: Self.tolerance))
		#expect(matrix[3, 2].isApproximatelyEqual(to: -1.01, absoluteTolerance: Self.tolerance))
		#expect(matrix[2, 3].isApproximatelyEqual(to: -1.0, absoluteTolerance: Self.tolerance))
		#expect(matrix[3, 3].isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))

		// A point on the near plane projects to depth 0.
		let near = matrix.transform(point: Point3(0.0, 0.0, -1.0))
		#expect(near.z.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))

		// A point on the far plane projects to depth 1.
		let far = matrix.transform(point: Point3(0.0, 0.0, -101.0))
		#expect(far.z.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))

		// The frustum half extents map to the edges of the ±1 square.
		let corner = matrix.transform(point: Point3(1.0, 1.0, -1.0))
		#expect(corner.x.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
		#expect(corner.y.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
	}

/// A right handed perspective projection into the `[-1, 1]` depth range should
/// place the near plane at depth `-1` and the far plane at depth `1`, while the
/// x and y mapping is unchanged from the `[0, 1]` variant.
///
	@Test("Perspective, Right Handed, Negative One to One")
	func perspectiveRightHandedNegativeOneToOne() async throws {
		let matrix = Matrix4x4<Double>.perspective(
			fieldOfView: Angle(degrees: 90.0),
			aspectRatio: 1.0,
			near: 1.0,
			far: 101.0,
			handedness: .rightHanded,
			depthRange: .negativeOneToOne
		)

		#expect(matrix[2, 2].isApproximatelyEqual(to: -1.02, absoluteTolerance: Self.tolerance))
		#expect(matrix[3, 2].isApproximatelyEqual(to: -2.02, absoluteTolerance: Self.tolerance))
		#expect(matrix[2, 3].isApproximatelyEqual(to: -1.0, absoluteTolerance: Self.tolerance))

		let near = matrix.transform(point: Point3(0.0, 0.0, -1.0))
		#expect(near.z.isApproximatelyEqual(to: -1.0, absoluteTolerance: Self.tolerance))

		let far = matrix.transform(point: Point3(0.0, 0.0, -101.0))
		#expect(far.z.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
	}

/// A left handed perspective projection looks down the positive z axis, so
/// points in front of the camera have positive z. The near and far planes
/// should still map to `0` and `1` in the `[0, 1]` depth range.
///
	@Test("Perspective, Left Handed, Zero to One")
	func perspectiveLeftHandedZeroToOne() async throws {
		let matrix = Matrix4x4<Double>.perspective(
			fieldOfView: Angle(degrees: 90.0),
			aspectRatio: 1.0,
			near: 1.0,
			far: 101.0,
			handedness: .leftHanded,
			depthRange: .zeroToOne
		)

		// The w row looks down +z, and the depth scale flips sign relative to
		// the right handed case.
		#expect(matrix[2, 3].isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
		#expect(matrix[2, 2].isApproximatelyEqual(to: 1.01, absoluteTolerance: Self.tolerance))

		let near = matrix.transform(point: Point3(0.0, 0.0, 1.0))
		#expect(near.z.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))

		let far = matrix.transform(point: Point3(0.0, 0.0, 101.0))
		#expect(far.z.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
	}

/// An aspect ratio other than `1` should scale the x axis by the reciprocal of
/// the ratio, leaving the y axis scale determined solely by the field of view.
///
	@Test("Perspective, Aspect Ratio")
	func perspectiveAspectRatio() async throws {
		let matrix = Matrix4x4<Double>.perspective(
			fieldOfView: Angle(degrees: 90.0),
			aspectRatio: 2.0,
			near: 1.0,
			far: 101.0,
			handedness: .rightHanded,
			depthRange: .zeroToOne
		)

		#expect(matrix[0, 0].isApproximatelyEqual(to: 0.5, absoluteTolerance: Self.tolerance))
		#expect(matrix[1, 1].isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
	}

/// A right handed orthographic projection into the `[0, 1]` depth range should
/// map the right/top/near corner of the view box to `(1, 1, 0)` and the
/// left/bottom/far corner to `(-1, -1, 1)`.
///
	@Test("Orthographic, Right Handed, Zero to One")
	func orthographicRightHandedZeroToOne() async throws {
		let matrix = Matrix4x4<Double>.orthographic(
			left: -2.0,
			right: 2.0,
			bottom: -1.0,
			top: 1.0,
			near: 1.0,
			far: 101.0,
			handedness: .rightHanded,
			depthRange: .zeroToOne
		)

		#expect(matrix[0, 0].isApproximatelyEqual(to: 0.5, absoluteTolerance: Self.tolerance))
		#expect(matrix[1, 1].isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
		#expect(matrix[3, 3].isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))

		let maxCorner = matrix.transform(point: Point3(2.0, 1.0, -1.0))
		#expect(maxCorner.x.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
		#expect(maxCorner.y.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
		#expect(maxCorner.z.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))

		let minCorner = matrix.transform(point: Point3(-2.0, -1.0, -101.0))
		#expect(minCorner.x.isApproximatelyEqual(to: -1.0, absoluteTolerance: Self.tolerance))
		#expect(minCorner.y.isApproximatelyEqual(to: -1.0, absoluteTolerance: Self.tolerance))
		#expect(minCorner.z.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
	}

/// A right handed orthographic projection into the `[-1, 1]` depth range should
/// map the near plane to depth `-1` and the far plane to depth `1`.
///
	@Test("Orthographic, Negative One to One")
	func orthographicNegativeOneToOne() async throws {
		let matrix = Matrix4x4<Double>.orthographic(
			left: -1.0,
			right: 1.0,
			bottom: -1.0,
			top: 1.0,
			near: 1.0,
			far: 101.0,
			handedness: .rightHanded,
			depthRange: .negativeOneToOne
		)

		let near = matrix.transform(point: Point3(0.0, 0.0, -1.0))
		#expect(near.z.isApproximatelyEqual(to: -1.0, absoluteTolerance: Self.tolerance))

		let far = matrix.transform(point: Point3(0.0, 0.0, -101.0))
		#expect(far.z.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
	}

/// A right handed view matrix should place the camera at the view space origin,
/// position the point it looks at along the negative z axis at the eye
/// distance, and keep world space +x aligned with view space +x.
///
	@Test("Look At, Right Handed")
	func lookAtRightHanded() async throws {
		let matrix = Matrix4x4<Double>.lookAt(
			eye: Point3(0.0, 0.0, 5.0),
			center: Point3(0.0, 0.0, 0.0),
			up: Vector3(0.0, 1.0, 0.0),
			handedness: .rightHanded
		)

		// The eye maps to the view space origin.
		let eye = matrix.transform(point: Point3(0.0, 0.0, 5.0))
		#expect(eye.x.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))
		#expect(eye.y.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))
		#expect(eye.z.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))

		// The look-at target lies in front of the camera, down -z.
		let target = matrix.transform(point: Point3(0.0, 0.0, 0.0))
		#expect(target.z.isApproximatelyEqual(to: -5.0, absoluteTolerance: Self.tolerance))

		// World +x remains view +x (the camera's right).
		let right = matrix.transform(point: Point3(1.0, 0.0, 0.0))
		#expect(right.x.isApproximatelyEqual(to: 1.0, absoluteTolerance: Self.tolerance))
		#expect(right.z.isApproximatelyEqual(to: -5.0, absoluteTolerance: Self.tolerance))
	}

/// A left handed view matrix looks down the positive z axis, so the point the
/// camera looks at should have positive view space z.
///
	@Test("Look At, Left Handed")
	func lookAtLeftHanded() async throws {
		let matrix = Matrix4x4<Double>.lookAt(
			eye: Point3(0.0, 0.0, 5.0),
			center: Point3(0.0, 0.0, 0.0),
			up: Vector3(0.0, 1.0, 0.0),
			handedness: .leftHanded
		)

		let target = matrix.transform(point: Point3(0.0, 0.0, 0.0))
		#expect(target.z.isApproximatelyEqual(to: 5.0, absoluteTolerance: Self.tolerance))
	}

/// A view and a projection matrix should compose (`projection * view`) to carry
/// a world space point through to normalized device coordinates. The look-at
/// target sits at the centre of the near plane, so it should land at the centre
/// of the near clip face — `(0, 0, 0)` for a right handed `[0, 1]` pipeline.
///
	@Test("View-Projection Composition")
	func viewProjectionComposition() async throws {
		let view = Matrix4x4<Double>.lookAt(
			eye: Point3(0.0, 0.0, 1.0),
			center: Point3(0.0, 0.0, 0.0),
			up: Vector3(0.0, 1.0, 0.0),
			handedness: .rightHanded
		)
		let projection = Matrix4x4<Double>.perspective(
			fieldOfView: Angle(degrees: 90.0),
			aspectRatio: 1.0,
			near: 1.0,
			far: 101.0,
			handedness: .rightHanded,
			depthRange: .zeroToOne
		)

		// The target is one unit in front of the eye, i.e. exactly on the near
		// plane, so it maps to the centre of the near clip face.
		let clip = (projection * view).transform(point: Point3(0.0, 0.0, 0.0))
		#expect(clip.x.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))
		#expect(clip.y.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))
		#expect(clip.z.isApproximatelyEqual(to: 0.0, absoluteTolerance: Self.tolerance))
	}
}
