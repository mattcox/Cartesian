//
//  VectorReflectable.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A vector that can be reflected across a surface defined by another
/// vector.
///
/// Reflection is computed relative to the surface normal, producing a new
/// vector that mirrors the original direction across the surface plane.
/// 
public protocol VectorReflectable: VectorProtocol {
/// Computes the reflection of the vector off a surface defined by a normal.
///
/// - Parameters:
///   - normal: A vector describing the normal of a surface to reflect
///   against.
///
/// - Returns: The vector reflected on the surface.
///
	func reflection(withNormal normal: Self) -> Self
}
