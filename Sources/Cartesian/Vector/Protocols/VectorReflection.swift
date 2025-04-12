//
//  VectorReflection.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Vector`` that can be reflected across a surface defined by another
/// vector.
///
/// Reflection is computed relative to the surface normal, producing a new
/// vector that mirrors the original direction across the surface plane.
/// 
public protocol VectorReflection: Vector {
/// A scalar value representing the index of refraction.
///
	associatedtype IndexOfRefraction: Numeric

/// Computes the reflection of the vector off a surface defined by a normal.
///
/// - Parameters:
///   - normal: A vector describing the normal of a surface to reflect
///   against.
///
/// - Returns: The vector reflected on the surface.
///
	func reflection(withNormal normal: Self) -> Self

/// Computes the refraction of the vector through a surface defined by a
/// normal and an index of refraction.
///
/// This calculates the refracted direction of the vector as it passes
/// through a surface boundary, based on the provided surface normal and
/// index of refraction. If total internal reflection occurs (i.e., the
/// incident angle is too steep), the function returns a zero vector.
///
/// - Parameters:
///   - normal: A vector describing the normal of a surface to refract
///   through.
///   - indexOfRefraction: The relative index of refraction between the
///   two media.
///
/// - Returns: A new vector representing the refracted direction, or a
/// zero vector if total internal reflection occurs.
///
	func refraction(withNormal normal: Self, indexOfRefraction: IndexOfRefraction) -> Self
}
