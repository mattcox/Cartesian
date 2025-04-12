//
//  Matrix.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that represents a matrix of arbitrary size.
///
/// A matrix is a two-dimensional grid of scalar values. While commonly used
/// for computing and storing transforms, matrices can also be applied to 
/// more complex tasks such as solving systems of linear equations.
///
/// The size of the matrix is implementation-defined, with a fixed number of 
/// rows and columns.
///
public protocol Matrix {
/// The scalar type used for specifying the matrix components.
///
	associatedtype Component: Numeric

/// The number of columns in the matrix.
///
	static var columns: Int { get }
	
/// The number of rows in the matrix.
///
	static var rows: Int { get }
	
/// Initialize an empty matrix.
///
	init()
	
/// Initialize the matrix with the values in another matrix.
///
/// The type of component for the two matrices must be the same, however
/// the number of columns and rows stored within the matrix can be
/// different.
///
/// - Parameters:
///   - matrix: The other matrix used to initialize this object.
///
	init<T: Matrix>(from matrix: T) where T.Component == Component
	
/// Access a matrix element at a specified column and row index.
///
/// - Parameters:
///   - column: The index of the column in the matrix.
///   - row: The index of the row in the matrix.
///
	subscript(_ column: Int, _ row: Int) -> Component { get set }
}

extension Matrix {
	public init<T: Matrix>(from matrix: T) where T.Component == Component {
		var matrix = Self()
		for row in 0..<(min(Self.rows, T.rows)) {
			for column in 0..<(min(Self.columns, T.columns)) {
				matrix[column, row] = matrix[column, row]
			}
		}
		self = matrix
	}
}
