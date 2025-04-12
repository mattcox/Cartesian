//
//  VectorMagnitude.swift
//  Cartesian
//
//  Created by Matt Cox on 04/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Vector`` that has a magnitude or length.
///
/// The magnitude represents the distance from the origin to the point defined
/// by the vector in Euclidean space.
///
public protocol VectorMagnitude: Vector {
/// The magnitude or length of the vector.
///
	var magnitude: Component { get set }
}
