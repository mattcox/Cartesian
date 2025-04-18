//
//  MatrixSub.swift
//  Cartesian
//
//  Created by Matt Cox on 18/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A matrix that can return a sub-matrix containing a subset of the matrix
/// components.
///
public protocol MatrixSub: MatrixProtocol {
/// The sub-matrix to return.
///
	associatedtype SubMatrix: MatrixProtocol where SubMatrix.Component == Self.Component

/// Get the matrix as a smaller matrix representation, specifying which
/// column and row to exclude.
///
/// - Parameters:
///   - excludingColumn: The column of the matrix to exclude.
///   - row: The row of the matrix to exclude.
///
/// - Returns: A containing only the included rows and columns.
///
	func subMatrix(excludingColumn column: Int, row: Int) -> SubMatrix
}
