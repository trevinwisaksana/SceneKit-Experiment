//
//  NodeInspectorView.swift
//  SceneKit-Grid-Experiment
//
//  Created by Trevin Wisaksana on 27/07/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import SceneKit

public protocol NodeInspectorViewDelegate: NSObjectProtocol {
    func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didSelectItemAtIndexPath indexPath: IndexPath)
    func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didUpdateNodePosition position: SCNVector3)
    func nodeInspectorView(_ nodeInspectorView: NodeInspectorView, didAngleNodePosition angle: Float)
    
    func planeNodeInspectorView(_ planeNodeInspectorView: PlaneNodeInspectorView, didUpdatePlaneWidth width: CGFloat)
    func planeNodeInspectorView(_ planeNodeInspectorView: PlaneNodeInspectorView, didUpdatePlaneLength length: CGFloat)
}

public protocol NodeInspectorViewDataSource: NSObjectProtocol {
    func viewModel(inNodeInspectorView nodeInspectorView: NodeInspectorView) -> NodeInspectorViewModel?
}

public class NodeInspectorView: UIView {
    
    // MARK: - Internal properties
    
    private static let cellHeight: CGFloat = 60.0
    var numberOfRowsInSection: Int = 4
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    weak var delegate: NodeInspectorViewDelegate?
    weak var dataSource: NodeInspectorViewDataSource?
    
    // MARK: - Setup
    
    public init(delegate: NodeInspectorViewDelegate, dataSource: NodeInspectorViewDataSource) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        self.dataSource = dataSource
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        tableView.register(cell: NodeColorCell.self)
        tableView.register(cell: NodePositionCell.self)
        tableView.register(cell: NodeAngleCell.self)
        tableView.register(cell: AnimationCell.self)
        addSubview(tableView)
        tableView.fillInSuperview()
    }
    
    // MARK: - Public
    
    public func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate

extension NodeInspectorView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.nodeInspectorView(self, didSelectItemAtIndexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension NodeInspectorView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setupCell(forRowAtIndex: indexPath.row)
    }
    
    private func setupCell(forRowAtIndex index: Int) -> UITableViewCell {
        switch index {
        case 0:
            let cell: NodeColorCell = tableView.dequeueReusableCell()
            
            if let model = dataSource?.viewModel(inNodeInspectorView: self) {
                cell.model = model
            }
            
            return cell
            
        case 1:
            let cell: NodePositionCell = tableView.dequeueReusableCell()
            
            if let model = dataSource?.viewModel(inNodeInspectorView: self) {
                cell.model = model
                cell.delegate = self
            }
            
            return cell
            
        case 2:
            let cell: NodeAngleCell = tableView.dequeueReusableCell()
            
            if let model = dataSource?.viewModel(inNodeInspectorView: self) {
                cell.model = model
                cell.delegate = self
            }
            
            return cell
            
        case 3:
            let cell: AnimationCell = tableView.dequeueReusableCell()
            
            return cell
            
        default:
            fatalError("Index out of range.")
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NodeInspectorView.cellHeight
    }
}

// MARK: - NodePositionCellDelegate

extension NodeInspectorView: NodePositionCellDelegate {
    public func nodePositionCell(_ nodePositionCell: NodePositionCell, didUpdateNodePosition position: SCNVector3) {
        delegate?.nodeInspectorView(self, didUpdateNodePosition: position)
    }
}

// MARK: - NodeAngleCellDelegate

extension NodeInspectorView: NodeAngleCellDelegate {
    public func nodeAngleCell(_ nodeAngleCell: NodeAngleCell, didUpdateRotationAngle angle: Float) {
        delegate?.nodeInspectorView(self, didAngleNodePosition: angle)
    }
}
