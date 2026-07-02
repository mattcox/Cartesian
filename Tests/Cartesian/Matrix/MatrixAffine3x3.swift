import Testing
import Foundation
import RealModule
import Units
@testable import Cartesian

@Suite("MatrixAffine3x3")
struct MatrixAffine3x3Tests {
	private func approxEqual(_ a: Vector2<Double>, _ b: Vector2<Double>, tolerance: Double = 1e-9) -> Bool {
		a[0].isApproximatelyEqual(to: b[0], absoluteTolerance: tolerance) &&
		a[1].isApproximatelyEqual(to: b[1], absoluteTolerance: tolerance)
	}

	private func approxIdentity(_ m: MatrixAffine3x3<Double>) -> Bool {
		let identity = MatrixAffine3x3<Double>.identity
		for column in 0..<3 {
			for row in 0..<3 where !m[column, row].isApproximatelyEqual(to: identity[column, row], absoluteTolerance: 1e-9) {
				return false
			}
		}
		return true
	}

	@Test("identity leaves a point unchanged")
	func identity() async throws {
		let m = MatrixAffine3x3<Double>.identity
		#expect(m.isIdentity)
		#expect(approxEqual(m.transform(point: Point2(3, -4)), Vector2(3, -4)))
	}

	@Test("translation applies to points but not directions")
	func translation() async throws {
		let m = MatrixAffine3x3(translation: Vector2<Double>(5, -2))
		#expect(approxEqual(m.translation, Vector2(5, -2)))
		#expect(approxEqual(m.transform(point: Point2(1, 1)), Vector2(6, -1)))
		#expect(approxEqual(m.transform(direction: Vector2(1, 1)), Vector2(1, 1)))
	}

	@Test("rotation rotates a point about the origin")
	func rotation() async throws {
		let m = MatrixAffine3x3(rotation: Angle<Double>(radians: .pi / 2))
		#expect(m.rotation.radians.isApproximatelyEqual(to: .pi / 2, absoluteTolerance: 1e-9))
		// +90° maps (1, 0) -> (0, 1).
		#expect(approxEqual(m.transform(direction: Vector2(1, 0)), Vector2(0, 1)))
	}

	@Test("scale resizes each axis")
	func scale() async throws {
		let m = MatrixAffine3x3(scale: Vector2<Double>(2, 3))
		#expect(approxEqual(m.scale, Vector2(2, 3)))
		#expect(approxEqual(m.transform(direction: Vector2(1, 1)), Vector2(2, 3)))
	}

	@Test("setting rotation preserves scale")
	func rotationPreservesScale() async throws {
		var m = MatrixAffine3x3(scale: Vector2<Double>(2, 5))
		m.rotation = Angle(radians: 0.5)
		#expect(m.rotation.radians.isApproximatelyEqual(to: 0.5, absoluteTolerance: 1e-9))
		#expect(approxEqual(m.scale, Vector2(2, 5)))
	}

	@Test("determinant equals the product of the axis scales")
	func determinant() async throws {
		var m = MatrixAffine3x3(rotation: Angle<Double>(radians: 0.7))
		m.scale = Vector2(2, 5)
		#expect(m.determinant.isApproximatelyEqual(to: 10, absoluteTolerance: 1e-9))
	}

	@Test("composition matches sequential application")
	func composition() async throws {
		let a = MatrixAffine3x3(translation: Vector2<Double>(1, 2))
		var b = MatrixAffine3x3(rotation: Angle<Double>(radians: 0.4))
		b.scale = Vector2(2, 2)
		let point = Point2<Double>(3, -1)
		#expect(approxEqual((a * b).transform(point: point), a.transform(point: b.transform(point: point))))
	}

	@Test("inverse round-trips a transformed point")
	func inverse() async throws {
		var m = MatrixAffine3x3(rotation: Angle<Double>(radians: 0.9))
		m.scale = Vector2(2, 0.5)
		m.translation = Vector2(4, -3)
		let inverse = try #require(m.inverse)
		let point = Point2<Double>(2, 7)
		#expect(approxEqual(inverse.transform(point: m.transform(point: point)), point))
	}

	@Test("array literal reads two affine rows and fixes the bottom row")
	func arrayLiteral() async throws {
		let m: MatrixAffine3x3<Double> = [
			[1, 0, 4],
			[0, 1, 5]
		]
		#expect(approxEqual(m.translation, Vector2(4, 5)))
		#expect(m[2, 2].isApproximatelyEqual(to: 1, absoluteTolerance: 1e-12))
	}

	@Test("Codable round-trips")
	func codable() async throws {
		var m = MatrixAffine3x3(rotation: Angle<Double>(radians: 0.3))
		m.scale = Vector2(1.5, 2.5)
		m.translation = Vector2(-1, 6)
		let data = try JSONEncoder().encode(m)
		let decoded = try JSONDecoder().decode(MatrixAffine3x3<Double>.self, from: data)
		#expect(decoded == m)
	}
}
