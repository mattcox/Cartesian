//
//  QuaternionNormalizable.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Quaternion`` that can be normalized to have a magnitude of 1.0.
///
/// Normalization scales the quaternion so that its length becomes 1.0,
/// producing a unit quaternion suitable for representing rotation.
///
public protocol QuaternionNormalizable: Quaternion {
/// Normalizes the quaternion, setting its magnitude to 1.0.
///
/// This returns a unit quaternion that preserves the original rotation
/// but has a length of 1.0.
///
/// - Returns: A normalized quaternion with unit length.
///
/// - Warning: If the quaternion has zero length, the behavior of this
/// function is undefined.
/// 
	var normalized: Self { get }

/// Normalizes the quaternion, setting its magnitude to 1.0.
///
/// This operation modifies the quaternion in place, replacing its
/// components with a unit-length version that preserves the original
/// rotation.
///
/// - Warning: If the magnitude of the quaternion is zero, the behavior of
/// this function is undefined.
///
	mutating func normalize()
}
