//
//  VectorEuclidianDistance.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

#if canImport(simd)
import simd
#endif

/// A ``Vector`` that can be used to measured the distance to another vector
/// in euclidian space.
///
/// This allows computing the straight-line (Euclidean) distance between two
/// vectors, typically representing points or positions in space.
///
public protocol VectorEuclidianDistance: Vector {
/// Computes the distance from this vector to another.
///
/// - Parameters:
///   - other: The vector to measure the distance to.
///
/// - Returns: The distance between the two vectors.
///
	func distance(to other: Self) -> Component
	
/// Computes the squared distance from this vector to another.
///
/// This skips the final square root calculation, and can be useful for
/// performing faster comparisons of distances where the relative distances
/// is important, but an accurate distance is unnecessary.
///
/// - Parameters:
///   - other: The vector to measure the distance to.
///
/// - Returns: The squared distance between the two vectors.
///
	func squaredDistance(to other: Self) -> Component
}

extension VectorEuclidianDistance {
/// Computes the distance from one vector to another.
///
/// - Parameters:
///   - one: The vector to measure the distance from.
///   - two: The vector to measure the distance to.
///
/// - Returns: The distance between the two vectors.
///
	public static func distance(between one: Self, and two: Self) -> Component {
		one.distance(to: two)
	}
	
/// Computes the squared distance from this vector to another.
///
/// This skips the final square root calculation, and can be useful for
/// performing faster comparisons of distances where the relative distances
/// is important, but an accurate distance is unnecessary.
///
/// - Parameters:
///   - one: The vector to measure the distance from.
///   - two: The vector to measure the distance to.
///
/// - Returns: The quared distance between the two vectors.
///
	public static func squaredDistance(between vectorA: Self, and vectorB: Self) -> Component {
		vectorA.squaredDistance(to: vectorB)
	}
}

#if canImport(simd)
extension VectorEuclidianDistance where Component: FloatingPoint {
	public func distance(to other: Self) -> Component {
		sqrt(squaredDistance(to: other))
	}
}
#endif
