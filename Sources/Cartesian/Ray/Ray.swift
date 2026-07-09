//
//  Ray.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A ray defined by an origin point and a direction vector.
///
/// A ray is a half-line starting at the origin and extending infinitely in the
/// direction. The direction is typically a unit vector, in which case the
/// parameter `t` in `point(at:)` directly represents distance from the origin.
///
/// The vector type determines the dimensionality of the ray. For example:
/// ```swift
/// let ray2D = Ray(origin: Vector2<Double>.zero, direction: Vector2(x: 1.0, y: 0.0))
/// let ray3D = Ray(origin: Vector3<Float>.zero, direction: Vector3(x: 0.0, y: 0.0, z: 1.0))
/// ```
///
public struct Ray<Vector: VectorMath> {
/// The point at which the ray originates.
///
	public var origin: Vector

/// The direction the ray travels in.
///
/// - Note: The direction is typically a unit vector. If the direction has
/// a magnitude other than 1.0, the parameter `t` in `point(at:)` will not
/// represent a true distance.
///
	public var direction: Vector

/// Initialize a ray from an origin point and a direction vector.
///
/// - Parameters:
///   - origin: The point at which the ray originates.
///   - direction: The direction the ray travels in. This is typically a unit
///   vector.
///
	@inlinable
	public init(origin: Vector, direction: Vector) {
		self.origin = origin
		self.direction = direction
	}
}

extension Ray {
/// Returns the position along the ray at parameter `t`.
///
/// - Parameters:
///   - t: The parameter value along the ray. If the direction is a unit
///   vector, `t` represents the distance from the origin.
///
/// - Returns: The point at parameter `t` along the ray.
///
	@inlinable
	public func point(at t: Vector.Component) -> Vector {
		origin + direction * t
	}
}

extension Ray where Vector.Component: FloatingPoint {
/// The component-wise reciprocal of the direction vector.
///
/// This is useful for efficient axis-aligned bounding box intersection tests
/// using the slab method, avoiding repeated division per test.
///
	@inlinable
	public var inverseDirection: Vector {
		var result = Vector()
		for i in 0..<Vector.count {
			result[i] = 1 / direction[i]
		}
		return result
	}
}

extension Ray: Codable where Vector: Codable {
	@inlinable
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		self.origin = try container.decode(Vector.self)
		self.direction = try container.decode(Vector.self)
	}

	@inlinable
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		try container.encode(origin)
		try container.encode(direction)
	}
}

extension Ray: CustomStringConvertible where Vector: CustomStringConvertible {
	public var description: String {
		"Ray(origin: \(origin), direction: \(direction))"
	}
}

extension Ray: Equatable where Vector: Equatable {

}

extension Ray: Sendable where Vector: Sendable {

}

extension Ray: Transformable2D where Vector: Transformable2D {
	public typealias Scalar = Vector.Scalar

	@inlinable
	public mutating func transform<T>(by transform: T) where T: Transform2Protocol, T.Component == Vector.Scalar {
		self = self.transformed(by: transform)
	}

/// Transform the ray, mapping its origin as a point and its direction as a
/// direction.
///
/// The origin is transformed as a point and the direction as a direction, so
/// the ray's parameterization is preserved: the transformed ray passes through
/// the transformed image of every point on the original ray. The direction is
/// recovered as the difference between the transformed tip and the transformed
/// origin, which cancels the translation for any affine transform.
///
/// - Parameters:
///   - transform: The transform to apply.
///
/// - Returns: The transformed ray.
///
	@inlinable
	public func transformed<T>(by transform: T) -> Ray where T: Transform2Protocol, T.Component == Vector.Scalar {
		let transformedOrigin = origin.transformed(by: transform)
		let transformedDirection = (origin + direction).transformed(by: transform) - transformedOrigin
		return Ray(origin: transformedOrigin, direction: transformedDirection)
	}
}

extension Ray: Transformable3D where Vector: Transformable3D {
	public typealias Scalar = Vector.Scalar

	@inlinable
	public mutating func transform<T>(by transform: T) where T: Transform3Protocol, T.Component == Vector.Scalar {
		self = self.transformed(by: transform)
	}

/// Transform the ray, mapping its origin as a point and its direction as a
/// direction.
///
/// The origin is transformed as a point and the direction as a direction, so
/// the ray's parameterization is preserved: the transformed ray passes through
/// the transformed image of every point on the original ray. The direction is
/// recovered as the difference between the transformed tip and the transformed
/// origin, which cancels the translation for any affine transform.
///
/// - Parameters:
///   - transform: The transform to apply.
///
/// - Returns: The transformed ray.
///
	@inlinable
	public func transformed<T>(by transform: T) -> Ray where T: Transform3Protocol, T.Component == Vector.Scalar {
		let transformedOrigin = origin.transformed(by: transform)
		let transformedDirection = (origin + direction).transformed(by: transform) - transformedOrigin
		return Ray(origin: transformedOrigin, direction: transformedDirection)
	}
}
