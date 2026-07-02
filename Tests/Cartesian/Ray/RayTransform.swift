import Testing
import RealModule
import Units
@testable import Cartesian

@Suite("Ray Transform")
struct RayTransformTests {
	private func approxEqual(_ a: Vector3<Double>, _ b: Vector3<Double>) -> Bool {
		(0..<3).allSatisfy { a[$0].isApproximatelyEqual(to: b[$0], absoluteTolerance: 1e-9) }
	}

	private func approxEqual(_ a: Vector2<Double>, _ b: Vector2<Double>) -> Bool {
		(0..<2).allSatisfy { a[$0].isApproximatelyEqual(to: b[$0], absoluteTolerance: 1e-9) }
	}

	// Sample 3D transforms.
	private var rigid3: RigidTransform3<Double> {
		RigidTransform3(rotation: Quaternion(withAxis: Vector3(0, 1, 0), angle: Angle(radians: 0.7)), translation: Vector3(1, 2, 3))
	}
	private var similarity3: SimilarityTransform3<Double> {
		SimilarityTransform3(rotation: Quaternion(withAxis: Vector3(1, 0, 0), angle: Angle(radians: -0.4)), translation: Vector3(-2, 1, 0.5), scale: 2.0)
	}
	private var affine3: AffineTransform3<Double> {
		var m = Matrix4x4(withQuaternion: Quaternion(withAxis: Vector3(0, 0, 1), angle: Angle(radians: 1.1)))
		m.scale = Vector3(1.5, 0.5, 2.0)
		m.translation = Vector3(4, -3, 2)
		return AffineTransform3(matrix: m)
	}

	// Sample 2D transforms.
	private var rigid2: RigidTransform2<Double> {
		RigidTransform2(rotation: Angle(radians: 0.6), translation: Vector2(1, 2))
	}
	private var similarity2: SimilarityTransform2<Double> {
		SimilarityTransform2(rotation: Angle(radians: -0.3), translation: Vector2(-1, 3), scale: 1.5)
	}
	private var affine2: AffineTransform2<Double> {
		var m = MatrixAffine3x3(rotation: Angle(radians: 0.9))
		m.scale = Vector2(2.0, 0.5)
		m.translation = Vector2(3, -2)
		return AffineTransform2(matrix: m)
	}

	@Test("transformed 3D ray passes through the transformed image of every point")
	func transform3D() async throws {
		let ray = Ray(origin: Vector3<Double>(1, 2, 3), direction: Vector3(0, 0, 1))

		func check<T: Transform3Protocol>(_ transform: T) where T.Component == Double {
			let transformed = ray.transformed(by: transform)
			for s in [0.0, 1.0, 2.5, -1.5] {
				#expect(approxEqual(transformed.point(at: s), transform.apply(to: ray.point(at: s))))
			}
		}

		check(rigid3)
		check(similarity3)
		check(affine3)
	}

	@Test("transformed 2D ray passes through the transformed image of every point")
	func transform2D() async throws {
		let ray = Ray(origin: Vector2<Double>(1, 2), direction: Vector2(1, 0))

		func check<T: Transform2Protocol>(_ transform: T) where T.Component == Double {
			let transformed = ray.transformed(by: transform)
			for s in [0.0, 1.0, 2.5, -1.5] {
				#expect(approxEqual(transformed.point(at: s), transform.apply(to: ray.point(at: s))))
			}
		}

		check(rigid2)
		check(similarity2)
		check(affine2)
	}

	@Test("rigid transform preserves the direction magnitude")
	func rigidPreservesDirection() async throws {
		let ray = Ray(origin: Vector3<Double>(0, 0, 0), direction: Vector3(0, 0, 1))
		let transformed = ray.transformed(by: rigid3)
		#expect(transformed.direction.magnitude.isApproximatelyEqual(to: 1, absoluteTolerance: 1e-9))
	}

	@Test("mutating transform matches the returning form")
	func mutatingMatchesReturning() async throws {
		let ray = Ray(origin: Vector3<Double>(1, 2, 3), direction: Vector3(0, 1, 0))
		var mutated = ray
		mutated.transform(by: rigid3)
		let returned = ray.transformed(by: rigid3)
		#expect(approxEqual(mutated.origin, returned.origin))
		#expect(approxEqual(mutated.direction, returned.direction))
	}
}
