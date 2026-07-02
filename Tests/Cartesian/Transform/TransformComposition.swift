import Testing
import RealModule
import Units
@testable import Cartesian

@Suite("Transform Composition")
struct TransformCompositionTests {
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

	// Sample 3D transforms of each class.
	private var rigid3: RigidTransform3<Double> {
		RigidTransform3(rotation: Quaternion(withAxis: Vector3(0, 1, 0), angle: Angle(radians: 0.7)), translation: Vector3(1, 2, 3))
	}
	private var similarity3: SimilarityTransform3<Double> {
		SimilarityTransform3(rotation: Quaternion(withAxis: Vector3(1, 0, 0), angle: Angle(radians: -0.4)), translation: Vector3(-2, 1, 0.5), scale: 2.0)
	}
	private var affine3: AffineTransform3<Double> {
		var matrix = Matrix4x4(withQuaternion: Quaternion(withAxis: Vector3(0, 0, 1), angle: Angle(radians: 1.1)))
		matrix.scale = Vector3(1.5, 0.5, 2.0)
		matrix.translation = Vector3(4, -3, 2)
		return AffineTransform3(matrix: matrix)
	}

	@Test("3D composition promotes to the join and matches the matrix product")
	func compose3D() async throws {
		let r = rigid3, s = similarity3, a = affine3

		let rr: RigidTransform3<Double> = r * r
		let ss: SimilarityTransform3<Double> = s * s
		let aa: AffineTransform3<Double> = a * a
		let rs: SimilarityTransform3<Double> = r * s
		let sr: SimilarityTransform3<Double> = s * r
		let ra: AffineTransform3<Double> = r * a
		let ar: AffineTransform3<Double> = a * r
		let sa: AffineTransform3<Double> = s * a
		let as_: AffineTransform3<Double> = a * s

		#expect(approxEqual(rr.matrix, r.matrix * r.matrix))
		#expect(approxEqual(ss.matrix, s.matrix * s.matrix))
		#expect(approxEqual(aa.matrix, a.matrix * a.matrix))
		#expect(approxEqual(rs.matrix, r.matrix * s.matrix))
		#expect(approxEqual(sr.matrix, s.matrix * r.matrix))
		#expect(approxEqual(ra.matrix, r.matrix * a.matrix))
		#expect(approxEqual(ar.matrix, a.matrix * r.matrix))
		#expect(approxEqual(sa.matrix, s.matrix * a.matrix))
		#expect(approxEqual(as_.matrix, a.matrix * s.matrix))
	}

	@Test("3D composition matches applying transforms in sequence")
	func composeApply3D() async throws {
		let r = rigid3, a = affine3
		let point = Vector3<Double>(2, -1, 4)
		let combined: AffineTransform3<Double> = r * a
		let sequential = r.apply(to: a.apply(to: point))
		let composed = combined.apply(to: point)
		#expect(composed[0].isApproximatelyEqual(to: sequential[0], absoluteTolerance: 1e-9))
		#expect(composed[1].isApproximatelyEqual(to: sequential[1], absoluteTolerance: 1e-9))
		#expect(composed[2].isApproximatelyEqual(to: sequential[2], absoluteTolerance: 1e-9))
	}

	// Sample 2D transforms of each class.
	private var rigid2: RigidTransform2<Double> {
		RigidTransform2(rotation: Angle(radians: 0.6), translation: Vector2(1, 2))
	}
	private var similarity2: SimilarityTransform2<Double> {
		SimilarityTransform2(rotation: Angle(radians: -0.3), translation: Vector2(-1, 3), scale: 1.5)
	}
	private var affine2: AffineTransform2<Double> {
		var matrix = MatrixAffine3x3(rotation: Angle(radians: 0.9))
		matrix.scale = Vector2(2.0, 0.5)
		matrix.translation = Vector2(3, -2)
		return AffineTransform2(matrix: matrix)
	}

	@Test("2D composition promotes to the join and matches the matrix product")
	func compose2D() async throws {
		let r = rigid2, s = similarity2, a = affine2

		let rr: RigidTransform2<Double> = r * r
		let ss: SimilarityTransform2<Double> = s * s
		let aa: AffineTransform2<Double> = a * a
		let rs: SimilarityTransform2<Double> = r * s
		let sr: SimilarityTransform2<Double> = s * r
		let ra: AffineTransform2<Double> = r * a
		let ar: AffineTransform2<Double> = a * r
		let sa: AffineTransform2<Double> = s * a
		let as_: AffineTransform2<Double> = a * s

		#expect(approxEqual(rr.matrix, r.matrix * r.matrix))
		#expect(approxEqual(ss.matrix, s.matrix * s.matrix))
		#expect(approxEqual(aa.matrix, a.matrix * a.matrix))
		#expect(approxEqual(rs.matrix, r.matrix * s.matrix))
		#expect(approxEqual(sr.matrix, s.matrix * r.matrix))
		#expect(approxEqual(ra.matrix, r.matrix * a.matrix))
		#expect(approxEqual(ar.matrix, a.matrix * r.matrix))
		#expect(approxEqual(sa.matrix, s.matrix * a.matrix))
		#expect(approxEqual(as_.matrix, a.matrix * s.matrix))
	}
}
