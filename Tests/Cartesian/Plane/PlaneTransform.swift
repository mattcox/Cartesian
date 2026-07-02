import Testing
import RealModule
import Units
@testable import Cartesian

@Suite("Plane Transform")
struct PlaneTransformTests {
	private var rigid: RigidTransform3<Double> {
		RigidTransform3(rotation: Quaternion(withAxis: Vector3(0, 1, 0), angle: Angle(radians: 0.7)), translation: Vector3(1, 2, 3))
	}
	private var similarity: SimilarityTransform3<Double> {
		SimilarityTransform3(rotation: Quaternion(withAxis: Vector3(1, 0, 0), angle: Angle(radians: -0.4)), translation: Vector3(-2, 1, 0.5), scale: 2.0)
	}
	private var affine: AffineTransform3<Double> {
		var m = Matrix4x4(withQuaternion: Quaternion(withAxis: Vector3(0, 0, 1), angle: Angle(radians: 1.1)))
		m.scale = Vector3(1.5, 0.5, 2.0)
		m.translation = Vector3(4, -3, 2)
		return AffineTransform3(matrix: m)
	}

	/// A point lying on a plane must still lie on the plane after both are
	/// transformed by the same transform — including under non-uniform scale,
	/// which exercises the inverse-transpose used for the normal.
	@Test("points on a plane stay on the transformed plane")
	func onPlaneInvariant() async throws {
		let normal = Vector3<Double>(1, 2, 3).normalized
		let onPlane = Vector3<Double>(4, -1, 2)
		let plane = Plane(normal: normal, point: onPlane)

		// A second point on the plane, offset along a tangent direction.
		let tangent = normal.cross(Vector3(0, 0, 1)).normalized
		let onPlane2 = onPlane + tangent * 3.0

		func check<T: Transform3Protocol>(_ transform: T) where T.Component == Double {
			let transformedPlane = plane.transformed(by: transform)
			for point in [onPlane, onPlane2] {
				let transformedPoint = transform.apply(to: point)
				#expect(transformedPlane.signedDistance(to: transformedPoint).isApproximatelyEqual(to: 0, absoluteTolerance: 1e-9))
			}
			// The transformed normal should remain unit length.
			#expect(transformedPlane.normal.magnitude.isApproximatelyEqual(to: 1, absoluteTolerance: 1e-9))
		}

		check(rigid)
		check(similarity)
		check(affine)
	}

	@Test("mutating transform matches the returning form")
	func mutatingMatchesReturning() async throws {
		let plane = Plane(normal: Vector3<Double>(0, 1, 0), point: Vector3(0, 5, 0))
		var mutated = plane
		mutated.transform(by: rigid)
		let returned = plane.transformed(by: rigid)
		#expect(mutated == returned)
	}
}
