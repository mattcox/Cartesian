//
//  MatrixScale.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Matrix`` that supports scaling transformations.
///
/// A scalable matrix allows its components to be adjusted proportionally 
/// along one or more axes, typically used to represent uniform or 
/// non-uniform scaling in space.
/// 
public protocol MatrixScale: Matrix {
/// The vector storing the scale information.
///
	associatedtype Scale: Vector where Scale.Component == Component

/// Initializes the matrix with a scalar value encoding uniform scale
/// in all axis.
///
/// This creates a scaling matrix where the same scalar value is applied
/// along all axes.
///
/// - Parameters:
///   - scale: The uniform scale value to store in the matrix.
///
	init(withScale scale: Component)
	
/// Initializes the matrix with a vector encoding scale in each axis.
///
/// - Parameters:
///   - scale: The scale values for each axis of the matrix.
///
	init(withScale scale: Scale)

/// The scale components of the matrix.
///
/// Represents the amount of scaling applied independently to each axis.
/// For uniform scaling, all three components will have the same value.
///
	var scale: Scale { get set }
}
