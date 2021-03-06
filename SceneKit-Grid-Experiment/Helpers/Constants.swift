//
//  Constants.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 23/06/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit

struct Constants {
    struct Controller {
        static let objectCatalog = "ObjectCatalogController"
        static let popoverMenu = "PopoverMenuController"
        static let objectAttribute = "ObjectAttributeController"
        static let utilities = "UtilitiesController"
    }
    
    struct Node {
        static let highlight = "nodeHightlight"
        static let floor = "floorNode"
        static let tileBorder = "tileBorderNode"
        static let tileFloor = "tileFloorNode"
        
        static let camera = "cameraNode"
        static let cameraOrbit = "cameraOrbit"
        static let gridContainer = "gridContainer"
        static let presentationNodeContainer = "presentationNodeContainer"
        
        static let speechBubble = "speechBubbleNode"
        static let car = "carNode"
        static let house = "houseNode"
        static let tree = "treeNode"
    }
    
    struct UserState {
        static let didDisplayPresentationOnboarding = "didDisplayPresentationOnboarding"
    }
    
    struct Value {
        /// Maximum camera field of view is 5.0
        static let maximumZoomFieldOfView: CGFloat = 5.0
        /// Maximum camera field of view is 47.0
        static let minimumZoomFieldOfView: CGFloat = 47.0
    }
}

struct NotificationKey {
    static let hasDisplayedObjectCatalogTipView = "hasDisplayedObjectCatalogTipView"
    static let hasDisplayedLongPressGestureTipView = "hasDisplayedPressLongGestureTipView"
    static let hasDisplayedObjectAttributesTipView = "hasDisplayedObjectAttributesTipView"
    static let hasDisplayedTap3DModelTipView = "hasDisplayedTap3DModelTipView"
}

public enum Action: String {
    case cut
    case copy
    case delete
    case paste
    case move
    case pin
    case animate
    
    var capitalized: String {
        return rawValue.capitalized
    }
}

public enum Animation: String {
    case move
    case delay
    case rotate
    case speechBubble
    case jump
    case `default`
    
    var capitalized: String {
        return rawValue.capitalized
    }
}

public enum AnimationType: String {
    case SCNActionMove
    case SCNActionWait
    case SCNActionRotate
    case SCNActionSpeechBubble
    case SCNActionFade
    case `default`
    
    var string: String {
        return rawValue
    }
}
