//
//  Transform3Protocol.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule

/// A transform that operates within a three-dimensional Cartesian coordinate
/// space.
///
/// This protocol refines ``TransformProtocol`` to fix the dimensionality of the
/// transform, mapping positions expressed as a ``Vector3`` and producing an
/// equivalent ``Matrix4x4`` affine matrix. It carries no requirements of its
/// own beyond those it inherits; its purpose is to allow code to be written
/// generically over any class of three-dimensional transform - rigid,
/// similarity or affine - without binding to a specific concrete type.
///
/// For example, a function can accept any three-dimensional transform:
/// ```swift
/// func place(_ transform: some Transform3Protocol) { ... }
/// ```
///
public protocol Transform3Protocol: TransformProtocol where Component: Real & SIMDScalar, Vector == Vector3<Component>, Matrix == Matrix4x4<Component> {

}
