//
//  Handedness.swift
//  Cartesian
//
//  Created by Matt Cox on 23/07/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// The chirality of a 3D coordinate system.
///
/// Handedness describes how the positive z axis is oriented relative to the
/// plane formed by the positive x and y axes. It determines the direction a
/// camera faces along its local z axis, and which winding order is considered
/// front facing.
///
/// In a right handed system, curling the right hand's fingers from the positive
/// x axis toward the positive y axis leaves the thumb pointing along the
/// positive z axis, and a camera conventionally looks down the negative z axis.
/// In a left handed system the positive z axis is reversed, and a camera looks
/// down the positive z axis.
///
public enum Handedness: Sendable, Hashable, CaseIterable {
/// A right handed coordinate system, in which a camera looks down the
/// negative z axis.
///
	case rightHanded

/// A left handed coordinate system, in which a camera looks down the positive
/// z axis.
///
	case leftHanded
}
