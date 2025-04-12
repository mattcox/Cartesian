//
//  MatrixTranslation.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A ``Matrix`` that can store translation information.
///
/// Translation matrices encode positional offsets along the axes, allowing
/// objects to be moved in space without altering their scale or rotation.
///
public protocol MatrixTranslation: Matrix {
/// The vector storing the translation information.
///
	associatedtype Translation: Vector where Translation.Component == Component

/// Initializes the matrix with a vector encoding translation in each axis.
///
/// - Parameters:
///   - translation: The translation values to store for each axis.
///
	init(withTranslation translation: Translation)
	
/// The translation components of the matrix.
///
	var translation: Translation { get set }
}
