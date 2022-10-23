//
//  GameClasses.swift
//  Abuse Helper
//
//  Created by Alex Hynds on 10/21/22.
//

import Foundation
import UIKit
import SpriteKit


class Tile: Equatable {
    
    var size: Double! = 5.0
    
    let id: Int!
    
    public init(_ value: Int, board: Board) {
        self.value = value
        self.size = (board.scene.size.width)/CGFloat(4)
        id = Int.random(in: 0...Int.max)
    }
    
    public init(_ value: Int) {
        self.value = value
        id = Int.random(in: 0...Int.max)
    }
    
    var value: Int = 2
    
    func node() -> SKShapeNode {
        let shape = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: CGFloat(size) * 0.1)
        shape.fillColor = .clear
        shape.strokeColor = .clear
        
        let shape2 = SKShapeNode(rect: CGRect(x: size*0.075, y: size*0.075, width: size*0.85, height: size*0.85), cornerRadius: CGFloat(size)*0.1)
        shape2.fillColor = color()
        shape2.strokeColor = .clear
        
        shape.addChild(shape2)
        
        let text = SKLabelNode(fontNamed: "Kollektif")
        text.text = String(describing: value)
        text.verticalAlignmentMode = .center
        text.horizontalAlignmentMode = .center
        text.fontSize = 30
        text.position = CGPoint(x: size/2.0, y: size/2.0)
        shape.addChild(text)
        return shape
    }
    
    func color() -> UIColor {
        
        switch (value) {
        case(2):
            return UIColor(named: "lvl1")!
        case(4):
            return UIColor(named: "lvl2")!
        case(8):
            return UIColor(named: "lvl3")!
        case(16):
            return UIColor(named: "lvl4")!
        case(32):
            return UIColor(named: "lvl5")!
        case(64):
            return UIColor(named: "lvl1")!
        case(128):
            return UIColor(named: "lvl2")!
        case(256):
            return UIColor(named: "lvl3")!
        case(512):
            return UIColor(named: "lvl4")!
        case(1024):
            return UIColor(named: "lvl5")!
        case(2048):
            return UIColor(named: "lvl1")!
        default:
            break
        }
        
        return UIColor(named: "lvl1")!
        
    }
    
    static func == (t1: Tile, t2: Tile) -> Bool {
        return t1.id == t2.id
    }
    
    
}

class Board {
    
    var scene: SKScene!
    var size: CGSize!
    
    public init(size: CGSize) {
        self.size = size
        self.scene = makeScene(size)
    }
    
    private func makeScene(_ size: CGSize) -> SKScene {
        let scene = SKScene(size: size)
        scene.backgroundColor = UIColor(named: "background")!
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        return scene
    }
    
    var positions: [[Tile?]] = [[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil]]
    
    func swipe(direction: Direction) {
        
        print("SWIPE")
        
        let snapshot = positions
        
        switch(direction) {
        case(.left):
            swipeLeft(combine: true)
            break
        case(.right):
            rotateLeft()
            rotateLeft()
            swipeLeft(combine: true)
            rotateLeft()
            rotateLeft()
            break
        case(.up):
            rotateLeft()
            swipeLeft(combine: true)
            rotateRight()
            break
        case(.down):
            rotateRight()
            swipeLeft(combine: true)
            rotateLeft()
            break
        }
        
        if (snapshot != positions) {
            addRandomTile()
        }
        
//        animate(before: snapshot, after: positions, direction: dire)
        update()
        
    }
    
    private func swipeLeft(combine: Bool) {
        
        for i in 0...positions.count-1 {
            var j = 1;
            while(j<positions[i].count) {
                if(positions[i][j] != nil) {
                    if(positions[i][j-1] == nil) {
                        // Switch
                        positions[i][j-1] = positions[i][j]
                        positions[i][j] = nil
                        j = 0
                    } else if (positions[i][j-1]?.value == positions[i][j]?.value) {
                        // Combine
                        if(combine) {
                            positions[i][j-1]?.value = (positions[i][j-1]?.value ?? 0)*2
                            positions[i][j] = nil
                            j = 0
                        }
                    }
                }
                
                j += 1
            }
        }
        
        if(combine) {
            for _ in 0...3 {
                swipeLeft(combine: false)
            }
        }
        
    }
    
    private func rotateLeft() {
        let w = positions.count
        let h = positions[0].count
        var ret: [[Tile?]] = [[Tile(0),Tile(0),Tile(0),Tile(0)],[Tile(0),Tile(0),Tile(0),Tile(0)],[Tile(0),Tile(0),Tile(0),Tile(0)],[Tile(0),Tile(0),Tile(0),Tile(0)]]
        for i in 0...h-1 {
            for j in 0...w-1 {
                ret[i][j] = positions[j][h-i-1] ?? nil
            }
        }
        
        positions = ret
    }

    private func rotateRight() {
        let w = positions.count
        let h = positions[0].count
        var ret: [[Tile?]] = [[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil]]
        for i in 0...h-1 {
            for j in 0...w-1 {
                ret[i][j] = positions[w-j-1][i] ?? nil
            }
        }
        
        positions = ret
    }
    
    
    enum Direction {
        case left, right, up, down
    }
    
    public func setPositions(_ positions: [[Tile?]]) {
        self.positions = positions
//        rotateRight()
    }
    
    
    // Display functions
    
    public func update() {
        print("UPDATING")
        print(positions)
        scene = makeScene(self.size)
        for i in 0...positions.count-1 {
            print("I is \(i)")
            for j in 0...positions[i].count-1 {
                print("J is \(j)")
                if(positions[i][j] != nil) {
                    let x = (j-2)*(Int(size.width)/4)
                    let y = (1-i)*(Int(size.height)/4)
                    displayTile(positions[i][j]!, position: CGPoint(x: Int(x), y: Int(y)))
                }
            }
        }
        
    }
    
    private func displayTile(_ tile: Tile, position: CGPoint) {
        print("Displaying a tile at position (\(position.x),\(position.y))")
        let node = tile.node()
        node.position = position
        print(node.position)
        scene.addChild(node)
    }
    
    
    public func startingBoard() {
        
        let first = 2
        let second = Double.random(in: 0.0...1.0)<0.67 ? 2 : 4
        
        var keepGoing = true
        var x1 = 0
        var x2 = 0
        var y1 = 0
        var y2 = 0
        while(keepGoing) {
            x1 = Int.random(in: 0...3)
            x2 = Int.random(in: 0...3)
            y1 = Int.random(in: 0...3)
            y2 = Int.random(in: 0...3)
            
            if(x1 != x2 || y1 != y2) {
                keepGoing = false
            }
        }
        
        var positions: [[Tile?]] = [[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil]]
        
        positions[x1][y1] = Tile(first, board: self)
        positions[x2][y2] = Tile(second, board: self)
        
        setPositions(positions)
        
    }
    
    private func addRandomTile() {
        
        let value = Double.random(in: 0.0...1.0)<0.67 ? 2 : 4
        var i = Int.random(in: 0...3)
        var j = Int.random(in: 0...3)
        while(positions[i][j] != nil) {
            i = Int.random(in: 0...3)
            j = Int.random(in: 0...3)
        }
        
        positions[i][j] = Tile(value, board: self)
        
    }
    
    public func checkForWin() -> Bool {
        for row in positions {
            for tile in row {
                if tile?.value ?? 0 >= 2048 {
                    return true
                }
            }
        }
        return false
    }
    
    public func score() -> Int {
        var count = 0
        for row in positions{
            for tile in row{
                count += tile?.value ?? 0
            }
        }
        return count
    }
    
    func animate(before: [[Tile?]], after: [[Tile?]], direction: Direction) {
        
        // Make a list of the ones that went away
        
        var beforeIDs: [Int] = []
        for row in before {
            for bTile in row {
                if let tile = bTile {
                    beforeIDs.append(tile.id)
                }
            }
        }
        
        var afterIDs: [Int] = []
        for row in after {
            for aTile in row {
                if let tile = aTile {
                    afterIDs.append(tile.id)
                }
            }
        }
        
        var removedIDs: [Int] = []
        
        removedIDs = beforeIDs.filter { !afterIDs.contains($0) }
        
        print("Removed these IDs: \(removedIDs)")
        
    }
    
}
