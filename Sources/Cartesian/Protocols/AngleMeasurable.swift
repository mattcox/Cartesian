//
//  AngleMeasurable.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import Units

/// A type that can form an angle with another of this type.
///
public protocol AngleMeasurable: VectorProtocol {
/// The scalar storing the angle information.
///
	associatedtype AngleUnit: BinaryFloatingPoint
	
/// The type of the object used as a pivot.
///
	associatedtype Pivot

/// Computes the angle between two objects.
///
/// An optional third object can be provided describing the pivot the angle
/// is measured at.
///
/// - Parameters:
///   - from: The incoming object in the angle measurement.
///   - to: The outgoing object in the angle measurement.
///   - by: An optional object describing the position the angle should
///   be measured.
///
/// - Returns: The angle formed by the objects.
///
	static func angle(from: Self, to: Self, by: Pivot?) -> Angle<AngleUnit>
}
