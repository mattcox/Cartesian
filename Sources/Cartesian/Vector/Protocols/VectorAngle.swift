//
//  VectorAngle.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Units

/// A ``Vector`` that can form an angle with another vector.
///
public protocol VectorAngle: Vector {
/// The scalar storing the angle information.
///
	associatedtype AngleRepresentation: BinaryFloatingPoint

/// Computes the angle between two vectors.
///
/// An optional third vector can be provided describing the pivot the angle
/// is measured at. If this is undefined, a pivot vector of zero is used.
///
/// - Parameters:
///   - from: The incoming vector in the angle measurement.
///   - to: The outgoing vector in the angle measurement.
///   - by: An optional vector describing the position the angle should
///   be measured.
///
/// - Returns: The angle formed by the vectors.
///
	static func angle(from: Self, to: Self, by: Self?) -> Angle<AngleRepresentation>
}
