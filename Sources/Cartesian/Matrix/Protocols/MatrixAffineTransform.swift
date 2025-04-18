//
//  MatrixAffineTransform.swift
//  Cartesian
//
//  Created by Matt Cox on 18/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A matrix that represents affine transformations in a Cartesian coordinate
/// space.
///
/// Conforming types support transformations that may include translation, in
/// addition to linear effects such as rotation and scaling. These
/// transformations do not preserve the origin and are typically used to
/// position, orient, and size objects within a space.
///
/// Affine transformations can be composed using matrix multiplication and
/// applied to position vectors to produce translated and transformed results
/// within the same space.
/// 
public protocol MatrixAffineTransform: MatrixLinearTransform {
/// A vector representing the translation or displacement encoded in the
/// matrix.
///
	associatedtype Translation: VectorProtocol
	
/// Checks if the matrix is affine.
///
	var isAffine: Bool { get }

/// The translation of the matrix.
///
	var translation: Translation { get set }
	
/// Initializes the matrix, encoding translation in each axis.
///
/// - Parameters:
///   - translation: The translation values to store for each axis.
///
	init(withTranslation translation: Translation)
}
