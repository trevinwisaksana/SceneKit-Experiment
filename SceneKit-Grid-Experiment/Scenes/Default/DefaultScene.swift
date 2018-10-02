//
//  DefaultScene.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 25/03/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

protocol SceneEditorDelegate {
    func sceneEditor(_ controller: SceneEditorViewController, didFinishEditing scene: Scene)
    func sceneEditor(_ controller: SceneEditorViewController, didUpdateContent scene: Scene)
    
    func sceneEditor(_ controller: SceneEditorViewController, didBeginDraggingNode scene: Scene)
    func sceneEditor(_ controller: SceneEditorViewController, didFinishDraggingNode scene: Scene)
}

public class DefaultScene: SCNScene, SceneViewModel {
    
    // MARK: - Internal Properties
    
    private static let gridWidth: Int = 20
    private static let gridTileWidth: CGFloat = 1
    
    public var nodeSelected: SCNNode?
    public var lastNodeSelected: SCNNode?
    public var didSelectTargetNode: Bool = false
    
    public var cameraNode: SCNNode = SCNNode()
    public var testNode: SCNNode = SCNNode()
    public var floorNode: SCNNode = SCNNode()
    
    public var floorColor: UIColor? {
        return .gray
    }
    
    // MARK: - Setup
    
    override public init() {
        super.init()
        
        background.contents = UIColor.gray
        
        setup()
    }
    
    private func setup() {
        setupSCNBox()
//        setupCamera()
//        setupFloor()
        displayGrid()
    }
    
    private func setupSCNBox() {
        let testBox = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        testNode.geometry = testBox
        testNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        testNode.position = SCNVector3(0, 0, 0.5)
        testNode.name = "testNode"
        
        rootNode.addChildNode(testNode)
    }
    
    private func setupFloor() {
        // TODO: Add a grid texture to the SCNFloor
        let floorGeometry = SCNFloor()
        floorNode.geometry = floorGeometry
        floorNode.name = "Floor"
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        rootNode.addChildNode(floorNode)
    }
    
    private func setupCamera() {
        cameraNode.camera = SCNCamera()
        rootNode.addChildNode(cameraNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Node Insertion
    
    func insertBox() {
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        boxNode.position = SCNVector3(0, 0.5, 5)
        // TODO: Change the name
        boxNode.name = "testNode"
        
        rootNode.addChildNode(boxNode)
    }
    
    func insertPyramid() {
        let pyramid = SCNPyramid(width: 1, height: 1, length: 1)
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        pyramidNode.position = SCNVector3(0, 0.5, 5)
        // TODO: Change the name
        pyramidNode.name = "testNode"
        
        rootNode.addChildNode(pyramidNode)
    }
    
    // MARK: - Grid
    
    // TODO: Only display when moving nodes
    public func displayGrid() {
        for xIndex in 0...DefaultScene.gridWidth {
            for yIndex in 0...DefaultScene.gridWidth {
                let tileGeometry = SCNPlane(width: DefaultScene.gridTileWidth, height: DefaultScene.gridTileWidth)
                let tileNode = SCNNode(geometry: tileGeometry)
                tileNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear

                tileNode.position.x = Float(xIndex)
                tileNode.position.y = Float(yIndex)
                
                createBorder(for: tileNode)

                rootNode.addChildNode(tileNode)
            }
        }
    }
    
    private func createLineNode(fromPos origin: SCNVector3, toPos destination: SCNVector3, color: UIColor) -> SCNNode {
        let line = lineFrom(vector: origin, toVector: destination)

        let lineNode = SCNNode(geometry: line)
        lineNode.geometry?.firstMaterial?.diffuse.contents = color

        return lineNode
    }

    private func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]

        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [source], elements: [element])
    }
    
    // MARK: - Color
    
    public func modifyNode(color: UIColor) {
        guard let name = nodeSelected?.name else {
            return
        }
        
        let node = rootNode.childNode(withName: name, recursively: true)
        node?.color = color
    }

    private func createBorder(for node: SCNNode?) {
        guard let node = node else {
            return
        }

        let (min, max) = node.boundingBox
        let zCoord = node.position.z
        let topLeft = SCNVector3(min.x, max.y, zCoord)
        let bottomLeft = SCNVector3(min.x, min.y, zCoord)
        let topRight = SCNVector3(max.x, max.y, zCoord)
        let bottomRight = SCNVector3(max.x, min.y, zCoord)

        let bottomSide = createLineNode(fromPos: bottomLeft, toPos: bottomRight, color: .yellow)
        let leftSide = createLineNode(fromPos: bottomLeft, toPos: topLeft, color: .yellow)
        let rightSide = createLineNode(fromPos: bottomRight, toPos: topRight, color: .yellow)
        let topSide = createLineNode(fromPos: topLeft, toPos: topRight, color: .yellow)

        [bottomSide, leftSide, rightSide, topSide].forEach {
            $0.name = "highlightNode"
            node.addChildNode($0)
        }
    }
    
//     TODO: Move the node manipulation code elsewhere
//     TODO: Find solution that doesn't only work with boxes
//        private func highlight(_ nodeSelected: SCNNode?) {
//            if didHighlightNode {
//                return
//            }
//    
//            guard let nodeSelected = nodeSelected else {
//                return
//            }
//
//            // TODO: Make the dimensions the same with the node selected
//            let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
//    
//            let nodeHighlight = SCNNode(geometry: box)
//            nodeHighlight.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "box_wireframe")
//            nodeHighlight.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
//            nodeHighlight.name = "nodeHighlight"
//    
//            nodeSelected.addChildNode(nodeHighlight)
//    
//            didHighlightNode = true
//        }
//    
//        private func unhighlight(_ lastNodeSelected: SCNNode?) {
//            didHighlightNode = false
//
//            guard let node = lastNodeSelected else {
//                return
//            }
//    
//            let nodeHighlight = node.childNode(withName: "nodeHighlight", recursively: true)
//            nodeHighlight?.removeFromParentNode()
//        }

}
