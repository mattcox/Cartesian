import Testing
import Foundation
import RealModule
import Units
@testable import Cartesian

@Suite("Transform Types")
struct TransformTypesTests {
	private func approxEqual(_ a: Vector3<Double>, _ b: Vector3<Double>) -> Bool {
		(0..<3).allSatisfy { a[$0].isApproximatelyEqual(to: b[$0], absoluteTolerance: 1e-9) }
	}

	private func approxEqual(_ a: Vector2<Double>, _ b: Vector2<Double>) -> Bool {
		(0..<2).allSatisfy { a[$0].isApproximatelyEqual(to: b[$0], absoluteTolerance: 1e-9) }
	}

	private func approxEqual(_ a: Matrix4x4<Double>, _ b: Matrix4x4<Double>) -> Bool {
		for c in 0..<4 { for r in 0..<4 where !a[c, r].isApproximatelyEqual(to: b[c, r], absoluteTolerance: 1e-9) { return false } }
		return true
	}

	private func approxEqual(_ a: MatrixAffine3x3<Double>, _ b: MatrixAffine3x3<Double>) -> Bool {
		for c in 0..<3 { for r in 0..<3 where !a[c, r].isApproximatelyEqual(to: b[c, r], absoluteTolerance: 1e-9) { return false } }
		return true
	}

	// Sample transforms.
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

	// MARK: - Identity

	@Test("identity is identity and leaves points unchanged")
	func identity() async throws {
		#expect(RigidTransform3<Double>.identity.isIdentity)
		#expect(SimilarityTransform3<Double>.identity.isIdentity)
		#expect(AffineTransform3<Double>.identity.isIdentity)
		#expect(RigidTransform2<Double>.identity.isIdentity)
		#expect(SimilarityTransform2<Double>.identity.isIdentity)
		#expect(AffineTransform2<Double>.identity.isIdentity)
		#expect(approxEqual(RigidTransform3<Double>.identity.apply(to: Point3(4, 5, 6)), Vector3(4, 5, 6)))
		#expect(approxEqual(AffineTransform2<Double>.identity.apply(to: Point2(4, 5)), Vector2(4, 5)))
	}

	// MARK: - apply matches the matrix representation

	@Test("apply matches the transform's matrix (3D)")
	func applyMatchesMatrix3D() async throws {
		let p = Point3<Double>(2, -1, 4)
		#expect(approxEqual(rigid3.apply(to: p), rigid3.matrix.transform(point: p)))
		#expect(approxEqual(similarity3.apply(to: p), similarity3.matrix.transform(point: p)))
		#expect(approxEqual(affine3.apply(to: p), affine3.matrix.transform(point: p)))
	}

	@Test("apply matches the transform's matrix (2D)")
	func applyMatchesMatrix2D() async throws {
		let p = Point2<Double>(2, -1)
		#expect(approxEqual(rigid2.apply(to: p), rigid2.matrix.transform(point: p)))
		#expect(approxEqual(similarity2.apply(to: p), similarity2.matrix.transform(point: p)))
		#expect(approxEqual(affine2.apply(to: p), affine2.matrix.transform(point: p)))
	}

	// MARK: - Inverse

	@Test("inverse round-trips a transformed point (3D)")
	func inverse3D() async throws {
		let p = Point3<Double>(3, -2, 1)
		#expect(approxEqual(try #require(rigid3.inverse).apply(to: rigid3.apply(to: p)), p))
		#expect(approxEqual(try #require(similarity3.inverse).apply(to: similarity3.apply(to: p)), p))
		#expect(approxEqual(try #require(affine3.inverse).apply(to: affine3.apply(to: p)), p))
	}

	@Test("inverse round-trips a transformed point (2D)")
	func inverse2D() async throws {
		let p = Point2<Double>(3, -2)
		#expect(approxEqual(try #require(rigid2.inverse).apply(to: rigid2.apply(to: p)), p))
		#expect(approxEqual(try #require(similarity2.inverse).apply(to: similarity2.apply(to: p)), p))
		#expect(approxEqual(try #require(affine2.inverse).apply(to: affine2.apply(to: p)), p))
	}

	@Test("similarity inverse is nil when scale is zero")
	func singularInverse() async throws {
		#expect(SimilarityTransform3(rotation: .identity, translation: .zero, scale: 0).inverse == nil)
		#expect(SimilarityTransform2(rotation: Angle(radians: 0), translation: .zero, scale: 0).inverse == nil)
	}

	// MARK: - Accessors

	@Test("accessors read back the encoded components")
	func accessors() async throws {
		#expect(approxEqual(rigid3.translation, Vector3(1, 2, 3)))
		#expect(similarity3.scale.isApproximatelyEqual(to: 2.0, absoluteTolerance: 1e-9))
		#expect(approxEqual(affine3.scale, Vector3(1.5, 0.5, 2.0)))
		#expect(rigid2.rotation.radians.isApproximatelyEqual(to: 0.6, absoluteTolerance: 1e-9))
		#expect(similarity2.scale.isApproximatelyEqual(to: 1.5, absoluteTolerance: 1e-9))
		#expect(approxEqual(affine2.translation, Vector2(3, -2)))
	}

	// MARK: - Equatable

	@Test("equatable")
	func equatable() async throws {
		#expect(rigid3 == rigid3)
		#expect(rigid3 != RigidTransform3<Double>.identity)
		#expect(affine2 == affine2)
		#expect(affine2 != AffineTransform2<Double>.identity)
	}

	// MARK: - Codable

	@Test("Codable round-trips every class")
	func codable() async throws {
		#expect(try JSONDecoder().decode(RigidTransform3<Double>.self, from: JSONEncoder().encode(rigid3)) == rigid3)
		#expect(try JSONDecoder().decode(SimilarityTransform3<Double>.self, from: JSONEncoder().encode(similarity3)) == similarity3)
		#expect(try JSONDecoder().decode(AffineTransform3<Double>.self, from: JSONEncoder().encode(affine3)) == affine3)
		#expect(try JSONDecoder().decode(RigidTransform2<Double>.self, from: JSONEncoder().encode(rigid2)) == rigid2)
		#expect(try JSONDecoder().decode(SimilarityTransform2<Double>.self, from: JSONEncoder().encode(similarity2)) == similarity2)
		#expect(try JSONDecoder().decode(AffineTransform2<Double>.self, from: JSONEncoder().encode(affine2)) == affine2)
	}

	// MARK: - Promotions

	@Test("promotions preserve the transform (3D)")
	func promotions3D() async throws {
		#expect(approxEqual(SimilarityTransform3(rigid3).matrix, rigid3.matrix))
		#expect(approxEqual(AffineTransform3(rigid3).matrix, rigid3.matrix))
		#expect(approxEqual(AffineTransform3(similarity3).matrix, similarity3.matrix))
	}

	@Test("promotions preserve the transform (2D)")
	func promotions2D() async throws {
		#expect(approxEqual(SimilarityTransform2(rigid2).matrix, rigid2.matrix))
		#expect(approxEqual(AffineTransform2(rigid2).matrix, rigid2.matrix))
		#expect(approxEqual(AffineTransform2(similarity2).matrix, similarity2.matrix))
	}

	// MARK: - Euler convenience (3D rotatable)

	@Test("Euler round-trips through the quaternion rotation")
	func euler() async throws {
		let euler: Units.Rotation<SIMD3<Double>> = [.radians(0.3), .radians(0.2), .radians(-0.4)]
		let reference = RigidTransform3(rotation: Quaternion(withRotation: euler, order: .XYZ), translation: .zero)

		let recovered = reference.toEulerRotation(order: .XYZ)
		var rebuilt = RigidTransform3<Double>()
		rebuilt.fromEulerRotation(recovered, order: .XYZ)
		#expect(approxEqual(rebuilt.matrix, reference.matrix))
	}
}
