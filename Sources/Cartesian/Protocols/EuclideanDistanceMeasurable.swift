//
//  EuclideanDistanceMeasurable.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that can be used to measured the distance to another of this type
/// in 3D space.
///
public protocol EuclideanDistanceMeasurable {
/// The type of value measuring the distance.
///
	associatedtype Distance

/// Computes the distance from this object to another.
///
/// - Parameters:
///   - other: The object to measure the distance to.
///
/// - Returns: The distance between the two object.
///
	func distance(to other: Self) -> Distance
	
/// Computes the squared distance from this object to another.
///
/// This skips the final square root calculation, and can be useful for
/// performing faster comparisons of distances where the relative distances
/// is important, but an accurate distance is unnecessary.
///
/// - Parameters:
///   - other: The object to measure the distance to.
///
/// - Returns: The squared distance between the two object.
///
	func squaredDistance(to other: Self) -> Distance
}

extension EuclideanDistanceMeasurable {
/// Computes the distance from one object to another.
///
/// - Parameters:
///   - one: The object to measure the distance from.
///   - two: The object to measure the distance to.
///
/// - Returns: The distance between the two object.
///
	public static func distance(between one: Self, and two: Self) -> Distance {
		one.distance(to: two)
	}
	
/// Computes the squared distance from this object to another.
///
/// This skips the final square root calculation, and can be useful for
/// performing faster comparisons of distances where the relative distances
/// is important, but an accurate distance is unnecessary.
///
/// - Parameters:
///   - one: The object to measure the distance from.
///   - two: The object to measure the distance to.
///
/// - Returns: The quared distance between the two object.
///
	public static func squaredDistance(between one: Self, and two: Self) -> Distance {
		one.squaredDistance(to: two)
	}
}
