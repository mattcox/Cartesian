import Testing
import RealModule
import Units
@testable import Cartesian

@Suite("Matrix4x4 Transform")
struct Matrix4x4TransformTests {
	private func approxEqual(_ a: Vector3<Double>, _ b: Vector3<Double>, tolerance: Double = 1e-9) -> Bool {
		a[0].isApproximatelyEqual(to: b[0], absoluteTolerance: tolerance) &&
		a[1].isApproximatelyEqual(to: b[1], absoluteTolerance: tolerance) &&
		a[2].isApproximatelyEqual(to: b[2], absoluteTolerance: tolerance)
	}

	@Test("translation applies to points but not directions")
	func translation() async throws {
		let m = Matrix4x4(withTranslation: Vector3<Double>(5, -2, 3))
		#expect(approxEqual(m.transform(point: Point3(1, 1, 1)), Vector3(6, -1, 4)))
		#expect(approxEqual(m.transform(direction: Vector3(1, 1, 1)), Vector3(1, 1, 1)))
	}

	@Test("rotation applies equally to points and directions")
	func rotation() async throws {
		let m = Matrix4x4(withQuaternion: Quaternion(withAxis: Vector3<Double>(0, 0, 1), angle: Angle(radians: .pi / 2)))
		// +90° about Z maps (1, 0, 0) -> (0, 1, 0).
		#expect(approxEqual(m.transform(point: Point3(1, 0, 0)), Vector3(0, 1, 0)))
		#expect(approxEqual(m.transform(direction: Vector3(1, 0, 0)), Vector3(0, 1, 0)))
	}

	@Test("rotation then translation: point includes translation, direction does not")
	func rotationAndTranslation() async throws {
		var m = Matrix4x4(withQuaternion: Quaternion(withAxis: Vector3<Double>(0, 0, 1), angle: Angle(radians: .pi / 2)))
		m.translation = Vector3(10, 20, 30)
		#expect(approxEqual(m.transform(point: Point3(1, 0, 0)), Vector3(10, 21, 30)))
		#expect(approxEqual(m.transform(direction: Vector3(1, 0, 0)), Vector3(0, 1, 0)))
	}

	@Test("transform(point:) performs the perspective divide")
	func perspectiveDivide() async throws {
		// A matrix that yields w = 2 for any point; the result should be halved.
		var m = Matrix4x4<Double>.identity
		m[3, 3] = 2
		#expect(approxEqual(m.transform(point: Point3(2, 4, 6)), Vector3(1, 2, 3)))
	}
}
