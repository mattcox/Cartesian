import Testing
import RealModule
import Units
@testable import Cartesian

@Suite("Transform Blend")
struct TransformBlendTests {
	private func approxEqual(_ a: Matrix4x4<Double>, _ b: Matrix4x4<Double>) -> Bool {
		for column in 0..<4 {
			for row in 0..<4 where !a[column, row].isApproximatelyEqual(to: b[column, row], absoluteTolerance: 1e-9) {
				return false
			}
		}
		return true
	}

	private func approxEqual(_ a: MatrixAffine3x3<Double>, _ b: MatrixAffine3x3<Double>) -> Bool {
		for column in 0..<3 {
			for row in 0..<3 where !a[column, row].isApproximatelyEqual(to: b[column, row], absoluteTolerance: 1e-9) {
				return false
			}
		}
		return true
	}

	@Test("RigidTransform3 blend")
	func rigid3() async throws {
		let a = RigidTransform3(rotation: Quaternion(withAxis: Vector3(0, 1, 0), angle: Angle(radians: 0.2)), translation: Vector3(1, 0, 0))
		let b = RigidTransform3(rotation: Quaternion(withAxis: Vector3(0, 1, 0), angle: Angle(radians: 1.2)), translation: Vector3(3, 4, 5))
		#expect(approxEqual(RigidTransform3<Double>.blend(from: a, to: b, by: 0.0).matrix, a.matrix))
		#expect(approxEqual(RigidTransform3<Double>.blend(from: a, to: b, by: 1.0).matrix, b.matrix))
		let mid = a.blended(to: b, by: 0.5)
		#expect(mid.translation[0].isApproximatelyEqual(to: 2.0, absoluteTolerance: 1e-9))
		#expect(mid.translation[1].isApproximatelyEqual(to: 2.0, absoluteTolerance: 1e-9))
	}

	@Test("SimilarityTransform3 blend")
	func similarity3() async throws {
		let a = SimilarityTransform3(rotation: .identity, translation: Vector3(0, 0, 0), scale: 1.0)
		let b = SimilarityTransform3(rotation: .identity, translation: Vector3(2, 0, 0), scale: 3.0)
		#expect(approxEqual(SimilarityTransform3<Double>.blend(from: a, to: b, by: 0.0).matrix, a.matrix))
		#expect(approxEqual(SimilarityTransform3<Double>.blend(from: a, to: b, by: 1.0).matrix, b.matrix))
		let mid = a.blended(to: b, by: 0.5)
		#expect(mid.scale.isApproximatelyEqual(to: 2.0, absoluteTolerance: 1e-9))
	}

	@Test("RigidTransform2 blend takes the shortest rotation arc")
	func rigid2() async throws {
		let a = RigidTransform2(rotation: Angle(radians: 0.1), translation: Vector2(0, 0))
		let b = RigidTransform2(rotation: Angle(radians: 1.1), translation: Vector2(4, 2))
		#expect(approxEqual(RigidTransform2<Double>.blend(from: a, to: b, by: 0.0).matrix, a.matrix))
		#expect(approxEqual(RigidTransform2<Double>.blend(from: a, to: b, by: 1.0).matrix, b.matrix))
		let mid = a.blended(to: b, by: 0.5)
		#expect(mid.rotation.radians.isApproximatelyEqual(to: 0.6, absoluteTolerance: 1e-9))
		#expect(mid.translation[0].isApproximatelyEqual(to: 2.0, absoluteTolerance: 1e-9))

		// Shortest arc: blending from +170° to -170° passes through 180°, not 0°.
		let wrapA = RigidTransform2(rotation: Angle(degrees: 170))
		let wrapB = RigidTransform2(rotation: Angle(degrees: -170))
		let wrapMid = wrapA.blended(to: wrapB, by: 0.5)
		#expect(abs(wrapMid.rotation.radians).isApproximatelyEqual(to: Double.pi, absoluteTolerance: 1e-9))
	}

	@Test("SimilarityTransform2 blend")
	func similarity2() async throws {
		let a = SimilarityTransform2(rotation: Angle(radians: 0.0), translation: Vector2(0, 0), scale: 1.0)
		let b = SimilarityTransform2(rotation: Angle(radians: 0.8), translation: Vector2(2, 6), scale: 5.0)
		#expect(approxEqual(SimilarityTransform2<Double>.blend(from: a, to: b, by: 0.0).matrix, a.matrix))
		#expect(approxEqual(SimilarityTransform2<Double>.blend(from: a, to: b, by: 1.0).matrix, b.matrix))
		let mid = a.blended(to: b, by: 0.5)
		#expect(mid.scale.isApproximatelyEqual(to: 3.0, absoluteTolerance: 1e-9))
	}
}
