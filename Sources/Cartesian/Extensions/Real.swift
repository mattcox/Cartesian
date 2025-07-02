//
//  Real.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule

extension Real {
/// Clamp the value between the provided minimum and maximum values.
///
/// - Parameters:
///   - minimum: The minimum value permitted.
///   - maximum: The maximum value permitted.
///
/// - Returns: The clamped value.
///
	@inline(__always)
	internal func clamped(between minimum: Self, and maximum: Self) -> Self {
		min(max(self, minimum), maximum)
	}

/// Clamp the value between the provided minimum and maximum values,
/// mutating the value.
///
/// - Parameters:
///   - minimum: The minimum value permitted.
///   - maximum: The maximum value permitted.
///
	@inline(__always)
	internal mutating func clamp(between minimum: Self, and maximum: Self) {
		self = min(max(self, minimum), maximum)
	}
	
/// Clamp the value to be within the provided range of values.
///
/// - Parameters:
///   - range: The range of permitted values.
///
/// - Returns: The clamped value.
///
	@inline(__always)
	internal func clamped(in range: ClosedRange<Self>) -> Self {
		min(max(self, range.lowerBound), range.upperBound)
	}

/// Clamp the value to be within the provided range of values, mutating the
/// value.
///
/// - Parameters:
///   - range: The range of permitted values.
///
	@inline(__always)
	internal mutating func clamp(in range: ClosedRange<Self>) {
		self = min(max(self, range.lowerBound), range.upperBound)
	}
}
