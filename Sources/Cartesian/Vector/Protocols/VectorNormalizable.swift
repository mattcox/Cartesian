//
//  VectorNormalizable.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Vector`` that can be normalized to have a magnitude of 1.0.
///
/// Normalization scales the vector so that its length becomes 1.0, producing a 
/// unit vector that retains the original direction.
///
public protocol VectorNormalizable: Vector {
/// Normalizes the vector, setting its magnitude to 1.0.
///
/// Returns a unit vector that maintains the same direction as the original 
/// but has a length of 1.0.
///
/// - Warning: If the vector has zero length, the behavior of this function
/// is undefined.
///
	var normalized: Self { get }

/// Normalizes the vector, setting its magnitude to 1.0.
///
/// This operation modifies the vector in place, scaling its components 
/// so that the resulting vector has unit length and retains the original
/// direction.
///
/// - Warning: If the vector has zero length, the behavior of this function
/// is undefined.
///
	mutating func normalize()
}

extension VectorMagnitude where Self: VectorMath & VectorNormalizable, Component: Comparable {
	public var normalized: Self {
		let magnitude = self.magnitude
		precondition(magnitude > .zero, "The magnitude of the vector is zero")
		return self / magnitude
	}
	
	public mutating func normalize() {
		let magnitude = self.magnitude
		precondition(magnitude > .zero, "The magnitude of the vector is zero")
		return self /= magnitude
	}
}
