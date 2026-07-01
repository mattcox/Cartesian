//
//  Quaternion.swift
//  Cartesian
//
//  Created by Matt Cox on 30/06/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule
import Units

/// A unit quaternion representing a rotation in three-dimensional space.
///
/// A quaternion has a real (scalar) part and an imaginary (vector) part. For
/// rotation purposes the quaternion is expected to be of unit length; many
/// operations silently assume this and will produce incorrect results if the
/// quaternion is not normalized.
///
/// Quaternion multiplication is **non-commutative**: `a * b` and `b * a`
/// describe different combined rotations.
///
public struct Quaternion<Component: Real & SIMDScalar> {
	private typealias Storage = Vector4<Component>
	private var storage: Storage
}

extension Quaternion {
	public typealias Imaginary = Vector3<Component>
	public typealias Real = Component

/// The imaginary (vector) part of the quaternion, storing the X, Y and Z
/// components.
///
	public var imaginary: Imaginary {
		get {
			Vector3(storage[0], storage[1], storage[2])
		}
		set {
			storage[0] = newValue[0]
			storage[1] = newValue[1]
			storage[2] = newValue[2]
		}
	}

/// The real (scalar) part of the quaternion, stored as the W component.
///
	public var real: Real {
		get {
			storage[3]
		}
		set {
			storage[3] = newValue
		}
	}

	public init() {
		storage = Vector4()
	}

/// Initialize the quaternion with explicit imaginary and real parts.
///
/// - Parameters:
///   - imaginary: The imaginary (vector) part of the quaternion.
///   - real: The real (scalar) part of the quaternion.
///
	public init(imaginary: Imaginary, real: Real) {
		storage = Vector4(imaginary[0], imaginary[1], imaginary[2], real)
	}

/// Initialize the quaternion from a four-component vector.
///
/// The first three components of the vector map to the imaginary part and
/// the fourth component maps to the real part.
///
/// - Parameters:
///   - vector: A four-component vector whose components are used directly.
///
	public init(_ vector: Vector4<Component>) {
		storage = vector
	}
}

extension Quaternion where Component: BinaryFloatingPoint {
/// Initialize the quaternion representing a rotation by the given angle
/// around an arbitrary axis.
///
/// The axis is normalized internally before computing the quaternion.
///
/// - Parameters:
///   - axis: The axis of rotation. Must be non-zero.
///   - angle: The rotation angle.
///
	public init(withAxis axis: Vector3<Component>, angle: Angle<Component>) {
		let halfAngle = angle.radians * 0.5
		let sinHalf = Component.sin(halfAngle)
		let cosHalf = Component.cos(halfAngle)
		self.init(imaginary: axis.normalized * sinHalf, real: cosHalf)
	}
	
/// The axis of rotation represented by this quaternion.
///
/// - Note: The quaternion must be normalized. Results are undefined for
///   non-unit quaternions.
///
	public var axis: Vector3<Component> {
		get {
			let real = real.clamped(between: -1, and: 1)
			let sinHalfAngle = Component.sqrt(1 - real * real)
			if sinHalfAngle.isApproximatelyEqual(to: .zero) {
				return Vector3(1, 0, 0)
			}
			
			return imaginary / sinHalfAngle
		}
		set {
			self = Self(withAxis: newValue, angle: self.angle)
		}
	}
	
/// The angle of rotation represented by this quaternion.
///
/// - Note: The quaternion must be normalized. Results are undefined for
///   non-unit quaternions.
///
	public var angle: Angle<Component> {
		get {
			Angle(radians: 2 * Component.acos(real.clamped(between: -1, and: 1)))
		}
		set {
			self = Self(withAxis: self.axis, angle: newValue)
		}
	}
}

extension Quaternion where Component: BinaryFloatingPoint {
	public typealias Rotation = Units.Rotation<SIMD3<Component>>

/// Initialize the quaternion from Euler rotation angles.
///
/// Three axis-aligned quaternions are constructed from the individual Euler
/// angles and composed in the order dictated by the rotation order. The
/// result is normalized.
///
/// - Parameters:
///   - rotation: The Euler angles to encode.
///   - order: The order in which the individual axis rotations are applied.
///
	public init(withRotation rotation: Rotation, order: RotationOrder) {
		let x = Quaternion(withAxis: Vector3<Component>(1, 0, 0), angle: rotation[0])
		let y = Quaternion(withAxis: Vector3<Component>(0, 1, 0), angle: rotation[1])
		let z = Quaternion(withAxis: Vector3<Component>(0, 0, 1), angle: rotation[2])

		switch order {
			case .XYZ:
				self = z * y * x
			case .XZY:
				self = y * z * x
			case .YXZ:
				self = z * x * y
			case .YZX:
				self = x * z * y
			case .ZXY:
				self = y * x * z
			case .ZYX:
				self = x * y * z
		}
		
		self.normalize()
	}
	
/// Converts this quaternion to an Euler rotation for the given rotation order.
///
/// - Note: The quaternion must be normalized. Results are undefined for
///   non-unit quaternions.
///
	public func toRotation(order: RotationOrder) -> Rotation {
		let imaginary = self.imaginary
		let real = self.real

		let x = Component.pow(imaginary[0], 2)
		let y = Component.pow(imaginary[1], 2)
		let z = Component.pow(imaginary[2], 2)

		switch order {
			case .XYZ:
				// q = qz*qy*qx → M = R_z*R_y*R_x
				let t0 = 2 * (real * imaginary[0] + imaginary[1] * imaginary[2])
				let t1 = 1 - 2 * (x + y)
				let pitch = Component.atan2(y: t0, x: t1)

				let t2 = 2 * (real * imaginary[1] - imaginary[2] * imaginary[0])
				let yaw = Component.asin(t2.clamped(between: -1, and: 1))

				let t3 = 2 * (real * imaginary[2] + imaginary[0] * imaginary[1])
				let t4 = 1 - 2 * (y + z)
				let roll = Component.atan2(y: t3, x: t4)

				return [Angle(radians: pitch), Angle(radians: yaw), Angle(radians: roll)]

			case .XZY:
				// q = qy*qz*qx → M = R_y*R_z*R_x
				let t0 = 2 * (real * imaginary[0] - imaginary[1] * imaginary[2])
				let t1 = 1 - 2 * (x + z)
				let pitch = Component.atan2(y: t0, x: t1)

				let t2 = 2 * (real * imaginary[2] + imaginary[0] * imaginary[1])
				let roll = Component.asin(t2.clamped(between: -1, and: 1))

				let t3 = 2 * (real * imaginary[1] - imaginary[0] * imaginary[2])
				let t4 = 1 - 2 * (y + z)
				let yaw = Component.atan2(y: t3, x: t4)

				return [Angle(radians: pitch), Angle(radians: yaw), Angle(radians: roll)]

			case .YXZ:
				// q = qz*qx*qy → M = R_z*R_x*R_y
				let t0 = 2 * (real * imaginary[0] + imaginary[1] * imaginary[2])
				let pitch = Component.asin(t0.clamped(between: -1, and: 1))

				let t1 = 2 * (real * imaginary[1] - imaginary[0] * imaginary[2])
				let t2 = 1 - 2 * (x + y)
				let yaw = Component.atan2(y: t1, x: t2)

				let t3 = 2 * (real * imaginary[2] - imaginary[0] * imaginary[1])
				let t4 = 1 - 2 * (x + z)
				let roll = Component.atan2(y: t3, x: t4)

				return [Angle(radians: pitch), Angle(radians: yaw), Angle(radians: roll)]

			case .YZX:
				// q = qx*qz*qy → M = R_x*R_z*R_y (correct as-is)
				let t0 = 2 * (real * imaginary[1] + imaginary[2] * imaginary[0])
				let t1 = 1 - 2 * (y + z)
				let yaw = Component.atan2(y: t0, x: t1)

				let t2 = 2 * (real * imaginary[2] - imaginary[0] * imaginary[1])
				let roll = Component.asin(t2.clamped(between: -1, and: 1))

				let t3 = 2 * (real * imaginary[0] + imaginary[1] * imaginary[2])
				let t4 = 1 - 2 * (x + z)
				let pitch = Component.atan2(y: t3, x: t4)

				return [Angle(radians: pitch), Angle(radians: yaw), Angle(radians: roll)]

			case .ZXY:
				// q = qy*qx*qz → M = R_y*R_x*R_z
				let t0 = 2 * (real * imaginary[0] - imaginary[1] * imaginary[2])
				let pitch = Component.asin(t0.clamped(between: -1, and: 1))

				let t1 = 2 * (real * imaginary[1] + imaginary[0] * imaginary[2])
				let t2 = 1 - 2 * (x + y)
				let yaw = Component.atan2(y: t1, x: t2)

				let t3 = 2 * (real * imaginary[2] + imaginary[0] * imaginary[1])
				let t4 = 1 - 2 * (x + z)
				let roll = Component.atan2(y: t3, x: t4)

				return [Angle(radians: pitch), Angle(radians: yaw), Angle(radians: roll)]

			case .ZYX:
				// q = qx*qy*qz → M = R_x*R_y*R_z
				let t0 = 2 * (real * imaginary[2] - imaginary[0] * imaginary[1])
				let t1 = 1 - 2 * (y + z)
				let roll = Component.atan2(y: t0, x: t1)

				let t2 = 2 * (real * imaginary[1] + imaginary[0] * imaginary[2])
				let yaw = Component.asin(t2.clamped(between: -1, and: 1))

				let t3 = 2 * (real * imaginary[0] - imaginary[1] * imaginary[2])
				let t4 = 1 - 2 * (x + y)
				let pitch = Component.atan2(y: t3, x: t4)

				return [Angle(radians: pitch), Angle(radians: yaw), Angle(radians: roll)]
		}
	}
	
}

extension Quaternion {
/// The conjugate of the quaternion, with the sign of the imaginary part
/// negated.
///
/// For a unit quaternion the conjugate is equal to the inverse, making it a
/// cheap way to compute the opposite rotation.
///
	public var conjugate: Self {
		Self(imaginary: -self.imaginary, real: self.real)
	}
}

extension Quaternion where Component: BinaryFloatingPoint {
/// Computes the angle of the shortest-arc rotation between two quaternions.
///
/// The returned angle is always in the range 0...π, as the dot product is
/// made absolute to account for the double-cover property of quaternions.
///
/// - Parameters:
///   - from: The starting quaternion.
///   - to: The destination quaternion.
///
/// - Returns: The angular difference between the two quaternions.
///
	public static func angle(from: Quaternion, to: Quaternion) -> Angle<Component> {
		let dot = abs(from.dot(to)).clamped(between: -1, and: 1)
		return Angle(2 * Component.acos(dot), unit: .radians)
	}

/// Computes the angle of the shortest-arc rotation from this quaternion to
/// another.
///
/// - Parameters:
///   - to: The destination quaternion.
///
/// - Returns: The angular difference between the two quaternions.
///
	public func angle(to: Quaternion) -> Angle<Component> {
		Self.angle(from: self, to: to)
	}
}

extension Quaternion {
/// Adds two quaternions component-wise.
///
/// - Parameters:
///   - lhs: The first quaternion.
///   - rhs: The second quaternion.
///
/// - Returns: A quaternion containing the result of the addition.
///
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage + rhs.storage)
	}

/// Adds two quaternions component-wise, mutating the first quaternion.
///
/// - Parameters:
///   - lhs: The first quaternion. This will be updated with the result.
///   - rhs: The second quaternion.
///
	public static func += (lhs: inout Self, rhs: Self) {
		lhs.storage += rhs.storage
	}

/// Adds a scalar to every component of the quaternion.
///
/// - Parameters:
///   - lhs: The quaternion.
///   - rhs: The scalar to add to every component.
///
/// - Returns: A quaternion containing the result of the addition.
///
	public static func + (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage + rhs)
	}

/// Adds a scalar to every component of the quaternion, mutating the
/// quaternion.
///
/// - Parameters:
///   - lhs: The quaternion. This will be updated with the result.
///   - rhs: The scalar to add to every component.
///
	public static func += (lhs: inout Self, rhs: Component) {
		lhs.storage += rhs
	}

/// Subtracts one quaternion from another component-wise.
///
/// - Parameters:
///   - lhs: The quaternion to subtract from.
///   - rhs: The quaternion to subtract.
///
/// - Returns: A quaternion containing the result of the subtraction.
///
	public static func - (lhs: Self, rhs: Self) -> Self {
		Self(lhs.storage - rhs.storage)
	}

/// Subtracts one quaternion from another component-wise, mutating the first
/// quaternion.
///
/// - Parameters:
///   - lhs: The quaternion to subtract from. This will be updated with the
///   result.
///   - rhs: The quaternion to subtract.
///
	public static func -= (lhs: inout Self, rhs: Self) {
		lhs.storage -= rhs.storage
	}

/// Subtracts a scalar from every component of the quaternion.
///
/// - Parameters:
///   - lhs: The quaternion.
///   - rhs: The scalar to subtract from every component.
///
/// - Returns: A quaternion containing the result of the subtraction.
///
	public static func - (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage - rhs)
	}

/// Subtracts a scalar from every component of the quaternion, mutating the
/// quaternion.
///
/// - Parameters:
///   - lhs: The quaternion. This will be updated with the result.
///   - rhs: The scalar to subtract from every component.
///
	public static func -= (lhs: inout Self, rhs: Component) {
		lhs.storage -= rhs
	}

/// Returns the negation of the quaternion.
///
/// Negating a quaternion inverts the sign of each of its components. For a
/// unit quaternion this represents the same rotation as the original, because
/// quaternions have the double-cover property: q and -q encode the same
/// orientation.
///
/// - Parameters:
///   - vector: The quaternion to negate.
///
/// - Returns: The negated quaternion.
///
	public static prefix func - (vector: Self) -> Self {
		Self(-vector.storage)
	}

/// Composes two quaternions, returning the combined rotation.
///
/// Quaternion multiplication applies the rotation of _rhs_ followed by the
/// rotation of _lhs_. This operation is **non-commutative**: `a * b` and
/// `b * a` generally describe different rotations.
///
/// - Parameters:
///   - lhs: The first quaternion in the composition.
///   - rhs: The second quaternion in the composition.
///
/// - Returns: A quaternion encoding the combined rotation.
///
	public static func * (lhs: Self, rhs: Self) -> Self {
		let cross = lhs.imaginary.cross(rhs.imaginary)
		let imaginary = cross + (lhs.imaginary * rhs.real) + (rhs.imaginary * lhs.real)
		let real = (lhs.real * rhs.real) - lhs.imaginary.dot(rhs.imaginary)
		return Self(imaginary: imaginary, real: real)
	}
	
/// Composes two quaternions, mutating the first quaternion.
///
/// - Parameters:
///   - lhs: The first quaternion. This will be updated with the combined
///   rotation.
///   - rhs: The second quaternion.
///
	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = (lhs * rhs)
	}

/// Scales all components of the quaternion by a scalar value.
///
/// - Parameters:
///   - lhs: The quaternion to scale.
///   - rhs: The scalar value to multiply by.
///
/// - Returns: A quaternion with all components scaled.
///
	public static func * (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage * rhs)
	}

/// Scales all components of the quaternion by a scalar value.
///
/// - Parameters:
///   - lhs: The scalar value to multiply by.
///   - rhs: The quaternion to scale.
///
/// - Returns: A quaternion with all components scaled.
///
	public static func * (lhs: Component, rhs: Self) -> Self {
		Self(lhs * rhs.storage)
	}

/// Scales all components of the quaternion by a scalar value, mutating the
/// quaternion.
///
/// - Parameters:
///   - lhs: The quaternion to scale. This will be updated with the result.
///   - rhs: The scalar value to multiply by.
///
	public static func *= (lhs: inout Self, rhs: Component) {
		lhs.storage *= rhs
	}

/// Divides all components of the quaternion by a scalar value.
///
/// - Parameters:
///   - lhs: The quaternion to divide.
///   - rhs: The scalar value to divide by.
///
/// - Returns: A quaternion with all components divided.
///
	public static func / (lhs: Self, rhs: Component) -> Self {
		Self(lhs.storage / rhs)
	}

/// Divides all components of the quaternion by a scalar value, mutating the
/// quaternion.
///
/// - Parameters:
///   - lhs: The quaternion to divide. This will be updated with the result.
///   - rhs: The scalar value to divide by.
///
	public static func /= (lhs: inout Self, rhs: Component) {
		lhs.storage /= rhs
	}
}

extension Quaternion {
/// Initialize the quaternion from a 3×3 rotation matrix.
///
/// The matrix is assumed to be a pure rotation matrix (orthonormal columns
/// with no scale). The resulting quaternion is normalized.
///
/// - Parameters:
///   - matrix: A 3×3 rotation matrix.
///
	public init(withMatrix matrix: Matrix3x3<Component>) {
		let trace = matrix.trace
		if trace > .zero {
			let s = Component.sqrt(trace + 1) * 2
			let imaginary = Vector3(x: matrix[1][2] - matrix[2][1],
									y: matrix[2][0] - matrix[0][2],
									z: matrix[0][1] - matrix[1][0])
			let real = (Component(1) / Component(4))
			
			self = Quaternion(imaginary: imaginary / s, real: real * s)
		}
		else if (matrix[0][0] > matrix[1][1]) && (matrix[0][0] > matrix[2][2]) {
			let s = Component.sqrt(Component(1) + matrix[0][0] - matrix[1][1] - matrix[2][2]) * 2
			
			let x: Component = (Component(1) / Component(4)) * s
			let y: Component = (matrix[0][1] + matrix[1][0]) / s
			let z: Component = (matrix[0][2] + matrix[2][0]) / s
			let w: Component = (matrix[1][2] - matrix[2][1]) / s

			self = Quaternion(Vector4(x: x, y: y, z: z, w: w))
		}
		else if matrix[1][1] > matrix[2][2] {
			let s = Component.sqrt(Component(1) + matrix[1][1] - matrix[0][0] - matrix[2][2]) * 2
			
			let x: Component = (matrix[0][1] + matrix[1][0]) / s
			let y: Component = (Component(1) / Component(4)) * s
			let z: Component = (matrix[1][2] + matrix[2][1]) / s
			let w: Component = (matrix[2][0] - matrix[0][2]) / s

			self = Quaternion(Vector4(x: x, y: y, z: z, w: w))
		}
		else {
			let s = Component.sqrt(Component(1) + matrix[2][2] - matrix[0][0] - matrix[1][1]) * 2

			let x: Component = (matrix[0][2] + matrix[2][0]) / s
			let y: Component = (matrix[1][2] + matrix[2][1]) / s
			let z: Component = (Component(1) / Component(4)) * s
			let w: Component = (matrix[0][1] - matrix[1][0]) / s

			self = Quaternion(Vector4(x: x, y: y, z: z, w: w))
		}
		
		self.normalize()
	}
	
/// The rotation matrix equivalent of this quaternion.
///
/// - Note: The quaternion is normalized internally before conversion, so
///   non-unit quaternions are accepted but the scale information is discarded.
///
	public var matrix: Matrix3x3<Component> {
		get {
			let quaternion = self.normalized
			let imaginary = quaternion.imaginary
			let real = quaternion.real
			
			var matrix = Matrix3x3<Component>.identity
			
			matrix[0][0] = 1 - 2 * (imaginary[1] * imaginary[1] + imaginary[2] * imaginary[2])
			matrix[0][1] = 2 * (imaginary[0] * imaginary[1] + real * imaginary[2])
			matrix[0][2] = 2 * (imaginary[0] * imaginary[2] - real * imaginary[1])

			matrix[1][0] = 2 * (imaginary[0] * imaginary[1] - real * imaginary[2])
			matrix[1][1] = 1 - 2 * (imaginary[0] * imaginary[0] + imaginary[2] * imaginary[2])
			matrix[1][2] = 2 * (imaginary[1] * imaginary[2] + real * imaginary[0])

			matrix[2][0] = 2 * (imaginary[0] * imaginary[2] + real * imaginary[1])
			matrix[2][1] = 2 * (imaginary[1] * imaginary[2] - real * imaginary[0])
			matrix[2][2] = 1 - 2 * (imaginary[0] * imaginary[0] + imaginary[1] * imaginary[1])
			
			return matrix
		}
		set {
			self = Quaternion(withMatrix: newValue)
		}
	}
}

extension Quaternion {
/// Creates a rotation that orients an object so its local forward axis (+Z)
/// points toward `forward` in world space.
///
/// Returns `nil` if `forward` is parallel to `up`, which makes the right
/// axis undefined.
///
/// - Parameters:
///   - forward: The world-space direction to face. Must be non-zero.
///   - up: A hint for the world-space up direction. Must be non-zero and
///     not parallel to `forward`.
///
	public static func lookRotation(forward: Vector3<Component>, up: Vector3<Component>) -> Self? {
		let f = forward.normalized
		let right = up.cross(f)
		guard !right.magnitude.isApproximatelyEqual(to: .zero) else { return nil }
		let r = right.normalized
		let u = f.cross(r)
		return Self(withMatrix: Matrix3x3(columns: r, u, f))
	}

/// Creates a rotation that orients an object so its local forward axis (+Z)
/// points toward `forward` in world space, using world +Y as the up hint.
///
/// Returns `nil` if `forward` is parallel to world +Y.
///
/// - Parameters:
///   - forward: The world-space direction to face. Must be non-zero.
///
	public static func lookRotation(forward: Vector3<Component>) -> Self? {
		lookRotation(forward: forward, up: Vector3(0, 1, 0))
	}
}

extension Quaternion where Component: BinaryFloatingPoint {
/// Creates the shortest-arc rotation that rotates `from` onto `to`.
///
/// Both vectors are normalized internally. Returns the identity quaternion
/// when the vectors are identical, and a 180° rotation around an arbitrary
/// perpendicular axis when they are antiparallel.
///
/// - Parameters:
///   - from: The source direction. Must be non-zero.
///   - to: The target direction. Must be non-zero.
///
	public static func fromToRotation(from: Vector3<Component>, to: Vector3<Component>) -> Self {
		let a = from.normalized
		let b = to.normalized
		let d = a.dot(b)

		if d >= 1 - Component.ulpOfOne {
			return .identity
		}

		if d <= -1 + Component.ulpOfOne {
			var axis = Vector3<Component>(1, 0, 0).cross(a)
			if axis.magnitude.isApproximatelyEqual(to: .zero) {
				axis = Vector3<Component>(0, 1, 0).cross(a)
			}
			return Self(withAxis: axis.normalized, angle: Angle(radians: Component.pi))
		}

		let s = Component.sqrt((1 + d) * 2)
		return Self(imaginary: a.cross(b) / s, real: s / 2).normalized
	}
}

extension Quaternion {
/// Rotates a vector by this quaternion using the Rodrigues formula.
///
/// - Parameters:
///   - vector: The vector to rotate.
///
/// - Note: The quaternion must be normalized. Non-unit quaternions will
///   scale the result in addition to rotating it.
///
	public func rotate(vector: Vector3<Component>) -> Vector3<Component> {
		let imaginary = self.imaginary
		let real = self.real

		let t = 2 * imaginary.cross(vector)
		return vector + real * t + imaginary.cross(t)
	}
}

extension Quaternion: Blendable {
	public static func blend(from: Self, to: Self, by amount: Component) -> Self {
		Self.lerp(from: from, to: to, by: amount)
	}
	
	public mutating func blend(to other: Self, by amount: Component) {
		self.lerp(to: other, by: amount)
	}
	
/// Linearly interpolates between two quaternions and normalizes the result.
///
/// Automatically takes the shortest path by negating `to` when the dot
/// product is negative. For smooth angular interpolation prefer `slerp`.
///
/// - Note: Both quaternions must be normalized.
///
	public static func lerp(from: Self, to: Self, by amount: Component) -> Self {
		if from.dot(to) < .zero {
			return Self(Storage.blend(from: from.storage, to: (-to).storage, by: amount).normalized)
		}
		else {
			return Self(Storage.blend(from: from.storage, to: to.storage, by: amount).normalized)
		}
	}
	
/// Linearly interpolates this quaternion toward another, normalizing the
/// result.
///
/// - Parameters:
///   - other: The quaternion to interpolate toward.
///   - amount: The blend amount in the range 0...1.
///
	public mutating func lerp(to other: Self, by amount: Component) {
		self = Self.lerp(from: self, to: other, by: amount)
	}
	
/// Spherically interpolates between two quaternions along the shortest arc.
///
/// Falls back to `lerp` when the quaternions are nearly identical to avoid
/// numerical instability near zero angle. The result is always normalized.
///
/// - Note: Both quaternions must be normalized.
///
	public static func slerp(from: Self, to: Self, by amount: Component) -> Self {
		var to = to
		var cosTheta = from.dot(to)
		
		// Slerp across the shortest path.
		//
		if cosTheta < .zero {
			cosTheta = -cosTheta
			to = -to
		}
		
		// If the angle is very small, lerp instead of slerp.
		//
		if cosTheta > Component(1) - Component.ulpOfOne {
			return Self.lerp(from: from, to: to, by: amount)
		}
		
		let theta = Component.acos(cosTheta)
		let sinTheta = Component.sin(theta)
		
		let scale0 = Component.sin((1 - amount) * theta) / sinTheta
		let scale1 = Component.sin(amount * theta) / sinTheta
		
		// Compute the slerped quaternion.
		//
		var result = Self()

		result.storage[0] = scale0 * from.storage[0] + scale1 * to.storage[0]
		result.storage[1] = scale0 * from.storage[1] + scale1 * to.storage[1]
		result.storage[2] = scale0 * from.storage[2] + scale1 * to.storage[2]
		result.storage[3] = scale0 * from.storage[3] + scale1 * to.storage[3]
		
		return result
	}
	
/// Spherically interpolates this quaternion toward another along the
/// shortest arc.
///
/// - Parameters:
///   - other: The quaternion to interpolate toward.
///   - amount: The blend amount in the range 0...1.
///
	public mutating func slerp(to other: Self, by amount: Component) {
		self = Self.slerp(from: self, to: other, by: amount)
	}
}

extension Quaternion: Codable {
	private enum CodingKeys: CodingKey {
		case imaginary
		case real
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let imaginary = try container.decode(Imaginary.self, forKey: .imaginary)
		let real = try container.decode(Real.self, forKey: .real)
		self.storage = Vector4(imaginary[0], imaginary[1], imaginary[2], real)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.imaginary, forKey: .imaginary)
		try container.encode(self.real, forKey: .real)
	}
}

extension Quaternion: DotProduct {
	public func dot(_ other: Self) -> Component {
		storage.dot(other.storage)
	}
}

extension Quaternion: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"[ \(String(format: "%.3f", imaginary[0]))  \(String(format: "%.3f", imaginary[1]))  \(String(format: "%.3f", imaginary[2]))  \(String(format: "%.3f", real)) ]"
	}
}

extension Quaternion: Equatable {

}

extension Quaternion: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(simd)
	}
}

extension Quaternion: Identity {
/// The identity quaternion, representing no rotation.
///
/// The identity quaternion has a zero imaginary part and a real part of 1,
/// corresponding to a zero-degree rotation around any axis.
///
	public static var identity: Self {
		Self(imaginary: .zero, real: 1)
	}

	public var isIdentity: Bool {
		self == Self.identity
	}
	
	public mutating func toIdentity() {
		self = Self(imaginary: .zero, real: 1)
	}
}

extension Quaternion: Invertible {
/// The inverse of the quaternion, or `nil` if the quaternion has zero
/// magnitude.
///
/// Computed as the conjugate divided by the squared magnitude. For a unit
/// quaternion this is equivalent to the conjugate, which is cheaper to
/// compute directly.
///
	public var inverse: Self? {
		let magSquared = dot(self)
		guard !magSquared.isApproximatelyEqual(to: .zero) else { return nil }
		return conjugate * (1 / magSquared)
	}

	public mutating func invert() -> Bool {
		guard let inv = inverse else { return false }
		self = inv
		return true
	}
}

extension Quaternion: MagnitudeAdjustable {
	public var magnitude: Component {
		get {
			storage.magnitude
		}
		set {
			storage.magnitude = newValue
		}
	}
}

extension Quaternion: MagnitudeMeasurable {

}

extension Quaternion: Normalizable {
	public var normalized: Self {
		Self(storage.normalized)
	}
	
	public mutating func normalize() {
		storage.normalize()
	}
}

extension Quaternion: ExpressibleByArrayLiteral {
/// Initialize the quaternion from an array literal.
///
/// Elements map to `[imaginary.x, imaginary.y, imaginary.z, real]`, so the
/// identity quaternion is written as `[0, 0, 0, 1]`. Extra elements are
/// ignored; missing elements default to zero.
///
	public init(arrayLiteral elements: Component...) {
		var quaternion = Self()
		for i in 0..<Swift.min(4, elements.count) {
			quaternion.simd[i] = elements[i]
		}
		self = quaternion
	}
}

extension Quaternion: Sendable where SIMDRepresentation: Sendable {
	
}

extension Quaternion: SIMDConvertible {
	public typealias SIMDRepresentation = Vector4<Component>.SIMDRepresentation
	
	public init(_ simd: SIMDRepresentation) {
		self.storage = Vector4(simd)
	}
	
	public var simd: SIMDRepresentation {
		get {
			storage.simd
		}
		set {
			storage.simd = newValue
		}
	}
}
