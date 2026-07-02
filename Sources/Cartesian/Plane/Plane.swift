//
//  Plane.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule

/// A plane in 3D space defined by a surface normal and a signed distance from
/// the origin.
///
/// The plane satisfies the equation `normal · p = distance` for all points `p`
/// on the plane, where `·` denotes the dot product. The normal is typically a
/// unit vector; operations that measure distance will be scaled by the magnitude
/// of the normal if it is not normalized.
///
public struct Plane<Component: Real & SIMDScalar> {
/// The surface normal of the plane.
///
/// - Note: The normal is typically a unit vector. Signed distance
/// calculations will be scaled by the magnitude of the normal if it is
/// not normalized.
///
	public var normal: Vector3<Component>

/// The signed distance from the origin to the plane, measured along the
/// normal.
///
/// Points on the plane satisfy `normal · p = distance`.
///
	public var distance: Component
}

extension Plane {
/// Initialize the plane from a normal and a point known to lie on the
/// plane.
///
/// - Parameters:
///   - normal: The surface normal of the plane.
///   - point: A point on the plane.
///
	public init(normal: Vector3<Component>, point: Vector3<Component>) {
		self.normal = normal
		self.distance = normal.dot(point)
	}

/// The signed distance from the plane to the provided point.
///
/// - A positive value indicates the point is on the same side as the
/// normal (the front).
/// - A negative value indicates the point is on the opposite side (the
/// back).
/// - A value of zero indicates the point lies on the plane.
///
/// - Parameters:
///   - point: The point to measure the signed distance to.
///
/// - Returns: The signed distance from the plane to the point.
///
	public func signedDistance(to point: Vector3<Component>) -> Component {
		normal.dot(point) - distance
	}

/// The unsigned perpendicular distance from the plane to the provided
/// point.
///
/// - Parameters:
///   - point: The point to measure the distance to.
///
/// - Returns: The distance from the plane to the point.
///
	public func distance(to point: Vector3<Component>) -> Component {
		Swift.abs(signedDistance(to: point))
	}

/// Returns true if the point lies approximately on the plane.
///
/// - Parameters:
///   - point: The point to test.
///
/// - Returns: True if the point lies on the plane within the default
/// tolerance.
///
	public func contains(_ point: Vector3<Component>) -> Bool {
		signedDistance(to: point).isApproximatelyEqual(to: .zero)
	}

/// Returns which side of the plane the point is on.
///
/// - Parameters:
///   - point: The point to test.
///
/// - Returns: The side of the plane the point is on.
///
	public func side(of point: Vector3<Component>) -> Side {
		let d = signedDistance(to: point)
		if d.isApproximatelyEqual(to: .zero) {
			return .on
		}
		return d > .zero ? .front : .back
	}
}

extension Plane {
/// The side of a plane that a point occupies.
///
	public enum Side {
	/// The point is on the same side as the plane normal.
	///
		case front

	/// The point is on the opposite side from the plane normal.
	///
		case back

	/// The point lies on the plane.
	///
		case on
	}
}

extension Plane.Side: Equatable {

}

extension Plane.Side: Hashable {

}

extension Plane.Side: Sendable {

}

extension Plane: Codable {
	public init(from decoder: Decoder) throws {
		let values = try Array<Component>(from: decoder)
		if values.count != 4 {
			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid number of values to decode"))
		}
		self.normal = Vector3(values[0], values[1], values[2])
		self.distance = values[3]
	}

	public func encode(to encoder: Encoder) throws {
		let values: [Component] = [normal.x, normal.y, normal.z, distance]
		try values.encode(to: encoder)
	}
}

extension Plane: CustomStringConvertible where Component: CVarArg {
	public var description: String {
		"Plane(normal: \(normal), distance: \(String(format: "%.3f", distance)))"
	}
}

extension Plane: Equatable {

}

extension Plane: Sendable where Vector3<Component>: Sendable, Component: Sendable {

}

extension Plane: Transformable3D {
	public typealias Scalar = Component

	public mutating func transform<T>(by transform: T) where T: Transform3Protocol, Component == T.Component {
		self = self.transformed(by: transform)
	}

/// Transform the plane by the provided transform, returning the transformed
/// plane.
///
/// A plane is transformed using the inverse-transpose of the transform's
/// matrix, so that the normal remains perpendicular to the plane even under
/// non-uniform scale or shear. The resulting normal is renormalized. If the
/// transform is singular, the plane is returned unchanged.
///
/// - Parameters:
///   - transform: The transform to apply.
///
/// - Returns: The transformed plane.
///
	public func transformed<T>(by transform: T) -> Plane where T: Transform3Protocol, Component == T.Component {
		guard let inverse = transform.matrix.inverse else {
			return self
		}
		let plane = inverse.transposed * Vector4(normal.x, normal.y, normal.z, -distance)
		let transformedNormal = Vector3(plane[0], plane[1], plane[2])
		let length = transformedNormal.magnitude
		guard !length.isApproximatelyEqual(to: .zero) else {
			return self
		}
		return Plane(normal: transformedNormal / length, distance: -plane[3] / length)
	}
}
