//
//  Magnitude.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that has a magnitude or length that can be measured.
///
/// Conforming types expose a value representing their magnitude
/// (e.g. length, modulus, or amplitude).
///
public protocol MagnitudeMeasurable {
/// The type of value measuring the magnitude.
///
	associatedtype Magnitude

/// The magnitude or length of the object.
///
	var magnitude: Magnitude { get }
}

/// A type that has a magnitude or length that can be adjusted.
///
/// Conforming types allow setting a new magnitude, which usually implies
/// scaling the value proportionally to match the new magnitude.
///
public protocol MagnitudeAdjustable: MagnitudeMeasurable {
/// The length or magnitude of the object.
///
	var magnitude: Magnitude { get set }
}
