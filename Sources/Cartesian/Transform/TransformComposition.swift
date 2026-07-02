//
//  TransformComposition.swift
//  Cartesian
//
//  Created by Matt Cox on 02/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import RealModule

// MARK: - Three-dimensional promotions

extension SimilarityTransform3 {
/// Promote a rigid transform to an equivalent similarity transform with a
/// unit scale.
///
/// - Parameters:
///   - transform: The rigid transform to promote.
///
	public init(_ transform: RigidTransform3<Component>) {
		self.init(rotation: transform.rotation, translation: transform.translation, scale: 1)
	}
}

extension AffineTransform3 {
/// Promote a rigid transform to an equivalent affine transform.
///
/// - Parameters:
///   - transform: The rigid transform to promote.
///
	public init(_ transform: RigidTransform3<Component>) {
		self.init(matrix: transform.matrix)
	}

/// Promote a similarity transform to an equivalent affine transform.
///
/// - Parameters:
///   - transform: The similarity transform to promote.
///
	public init(_ transform: SimilarityTransform3<Component>) {
		self.init(matrix: transform.matrix)
	}
}

// MARK: - Three-dimensional composition

/// Concatenate two rigid transforms, producing a rigid transform.
///
public func * <Component>(lhs: RigidTransform3<Component>, rhs: RigidTransform3<Component>) -> RigidTransform3<Component> {
	lhs.concatenated(with: rhs)
}

/// Concatenate two similarity transforms, producing a similarity transform.
///
public func * <Component>(lhs: SimilarityTransform3<Component>, rhs: SimilarityTransform3<Component>) -> SimilarityTransform3<Component> {
	lhs.concatenated(with: rhs)
}

/// Concatenate two affine transforms, producing an affine transform.
///
public func * <Component>(lhs: AffineTransform3<Component>, rhs: AffineTransform3<Component>) -> AffineTransform3<Component> {
	lhs.concatenated(with: rhs)
}

/// Concatenate a rigid transform with a similarity transform, promoting the
/// result to a similarity transform.
///
public func * <Component>(lhs: RigidTransform3<Component>, rhs: SimilarityTransform3<Component>) -> SimilarityTransform3<Component> {
	SimilarityTransform3(lhs).concatenated(with: rhs)
}

/// Concatenate a similarity transform with a rigid transform, promoting the
/// result to a similarity transform.
///
public func * <Component>(lhs: SimilarityTransform3<Component>, rhs: RigidTransform3<Component>) -> SimilarityTransform3<Component> {
	lhs.concatenated(with: SimilarityTransform3(rhs))
}

/// Concatenate a rigid transform with an affine transform, promoting the result
/// to an affine transform.
///
public func * <Component>(lhs: RigidTransform3<Component>, rhs: AffineTransform3<Component>) -> AffineTransform3<Component> {
	AffineTransform3(lhs).concatenated(with: rhs)
}

/// Concatenate an affine transform with a rigid transform, promoting the result
/// to an affine transform.
///
public func * <Component>(lhs: AffineTransform3<Component>, rhs: RigidTransform3<Component>) -> AffineTransform3<Component> {
	lhs.concatenated(with: AffineTransform3(rhs))
}

/// Concatenate a similarity transform with an affine transform, promoting the
/// result to an affine transform.
///
public func * <Component>(lhs: SimilarityTransform3<Component>, rhs: AffineTransform3<Component>) -> AffineTransform3<Component> {
	AffineTransform3(lhs).concatenated(with: rhs)
}

/// Concatenate an affine transform with a similarity transform, promoting the
/// result to an affine transform.
///
public func * <Component>(lhs: AffineTransform3<Component>, rhs: SimilarityTransform3<Component>) -> AffineTransform3<Component> {
	lhs.concatenated(with: AffineTransform3(rhs))
}

// MARK: - Two-dimensional promotions

extension SimilarityTransform2 {
/// Promote a rigid transform to an equivalent similarity transform with a
/// unit scale.
///
/// - Parameters:
///   - transform: The rigid transform to promote.
///
	public init(_ transform: RigidTransform2<Component>) {
		self.init(rotation: transform.rotation, translation: transform.translation, scale: 1)
	}
}

extension AffineTransform2 {
/// Promote a rigid transform to an equivalent affine transform.
///
/// - Parameters:
///   - transform: The rigid transform to promote.
///
	public init(_ transform: RigidTransform2<Component>) {
		self.init(matrix: transform.matrix)
	}

/// Promote a similarity transform to an equivalent affine transform.
///
/// - Parameters:
///   - transform: The similarity transform to promote.
///
	public init(_ transform: SimilarityTransform2<Component>) {
		self.init(matrix: transform.matrix)
	}
}

// MARK: - Two-dimensional composition

/// Concatenate two rigid transforms, producing a rigid transform.
///
public func * <Component>(lhs: RigidTransform2<Component>, rhs: RigidTransform2<Component>) -> RigidTransform2<Component> {
	lhs.concatenated(with: rhs)
}

/// Concatenate two similarity transforms, producing a similarity transform.
///
public func * <Component>(lhs: SimilarityTransform2<Component>, rhs: SimilarityTransform2<Component>) -> SimilarityTransform2<Component> {
	lhs.concatenated(with: rhs)
}

/// Concatenate two affine transforms, producing an affine transform.
///
public func * <Component>(lhs: AffineTransform2<Component>, rhs: AffineTransform2<Component>) -> AffineTransform2<Component> {
	lhs.concatenated(with: rhs)
}

/// Concatenate a rigid transform with a similarity transform, promoting the
/// result to a similarity transform.
///
public func * <Component>(lhs: RigidTransform2<Component>, rhs: SimilarityTransform2<Component>) -> SimilarityTransform2<Component> {
	SimilarityTransform2(lhs).concatenated(with: rhs)
}

/// Concatenate a similarity transform with a rigid transform, promoting the
/// result to a similarity transform.
///
public func * <Component>(lhs: SimilarityTransform2<Component>, rhs: RigidTransform2<Component>) -> SimilarityTransform2<Component> {
	lhs.concatenated(with: SimilarityTransform2(rhs))
}

/// Concatenate a rigid transform with an affine transform, promoting the result
/// to an affine transform.
///
public func * <Component>(lhs: RigidTransform2<Component>, rhs: AffineTransform2<Component>) -> AffineTransform2<Component> {
	AffineTransform2(lhs).concatenated(with: rhs)
}

/// Concatenate an affine transform with a rigid transform, promoting the result
/// to an affine transform.
///
public func * <Component>(lhs: AffineTransform2<Component>, rhs: RigidTransform2<Component>) -> AffineTransform2<Component> {
	lhs.concatenated(with: AffineTransform2(rhs))
}

/// Concatenate a similarity transform with an affine transform, promoting the
/// result to an affine transform.
///
public func * <Component>(lhs: SimilarityTransform2<Component>, rhs: AffineTransform2<Component>) -> AffineTransform2<Component> {
	AffineTransform2(lhs).concatenated(with: rhs)
}

/// Concatenate an affine transform with a similarity transform, promoting the
/// result to an affine transform.
///
public func * <Component>(lhs: AffineTransform2<Component>, rhs: SimilarityTransform2<Component>) -> AffineTransform2<Component> {
	lhs.concatenated(with: AffineTransform2(rhs))
}
