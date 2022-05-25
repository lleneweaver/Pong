//
//  GameScene.swift
//  Pong
//
//  Created by  on 5/16/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var ball = SKSpriteNode()
    var paddle = SKSpriteNode()
    var compPaddle = SKSpriteNode()
    var bottom = SKSpriteNode()
    var top = SKSpriteNode()
    
    // didMove is similar to viewDidLoad
    override func didMove(to view: SKView)
    {
        ball = childNode(withName: "ball") as! SKSpriteNode
        paddle = childNode(withName: "paddle") as! SKSpriteNode
        createComputerPaddle()
        createTopAndBottom()
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        
        self.physicsBody = borderBody
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 9.8)
        physicsWorld.contactDelegate = self
        
        ball.physicsBody?.categoryBitMask = 1
        paddle.physicsBody?.categoryBitMask = 2
        compPaddle.physicsBody?.categoryBitMask = 3
        top.physicsBody?.categoryBitMask = 4
        bottom.physicsBody?.categoryBitMask = 5
        
        ball.physicsBody?.contactTestBitMask = 2 | 3 | 4 | 5
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        let location = contact.contactPoint
        print(location)
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 4
        {
            // ball hit the top
            print("Ball hit top. Player scored!")
        }
        if contact.bodyA.categoryBitMask == 4 && contact.bodyB.categoryBitMask == 1
        {
            // ball hit the top
            print("Ball hit top. Player scored!")
        }
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 5
        {
            // ball hit the top
            print("Ball hit bottom. Computer scored!")
        }
        if contact.bodyA.categoryBitMask == 5 && contact.bodyB.categoryBitMask == 1
        {
            // ball hit the top
            print("Ball hit bottom. Computer scored!")
        }
    }
    
    func createTopAndBottom()
    {
        top = SKSpriteNode(color: UIColor.systemGreen, size: CGSize(width: self.frame.width, height: 10))
        top.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.98)
        addChild(top)
        top.physicsBody = SKPhysicsBody(rectangleOf: top.frame.size)
        top.physicsBody?.isDynamic = false
        
        bottom = SKSpriteNode(color: UIColor.systemGreen, size: CGSize(width: self.frame.width, height: 10))
        bottom.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.02)
        addChild(bottom)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.frame.size)
        bottom.physicsBody?.isDynamic = false
    }
    
    
    func createComputerPaddle()
    {
        compPaddle = SKSpriteNode(color: UIColor.systemPink, size: CGSize(width: 150, height: 50))
        compPaddle.position = CGPoint(x: frame.width/2, y: frame.height*0.9)
        addChild(compPaddle)
        
        // add physics
        compPaddle.physicsBody = SKPhysicsBody(rectangleOf: compPaddle.frame.size)
        compPaddle.physicsBody?.allowsRotation = false
        compPaddle.physicsBody?.friction = 0
        compPaddle.physicsBody?.affectedByGravity = false
        compPaddle.physicsBody?.isDynamic = false
        
        let follow = SKAction.repeatForever(SKAction.sequence([
            SKAction.run(followBall),
            SKAction.wait(forDuration: 0.2)
        ]))
       
        run(follow)
    }
    
    func followBall()
    {
        let move = SKAction.moveTo(x: ball.position.x, duration: 0.2)
        compPaddle.run(move)
    }
    
//    override func update(_ currentTime: TimeInterval)
//    {
//        compPaddle.position = CGPoint(x: ball.position.x, y: compPaddle.position.y)
//    }
    
    var isTouchingPaddle = false
    // this method gets called everytime i touch my screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first!.location(in: self)
        if paddle.frame.contains(location)
        {
           isTouchingPaddle = true
        }
        
        if isTouchingPaddle == true
        {
            paddle.position = CGPoint(x: location.x, y: paddle.position.y)
        }
        
  //      makeNewBall(touchLocation: location)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first!.location(in: self)
        if isTouchingPaddle == true
        {
        paddle.position = CGPoint(x: location.x, y: paddle.position.y)
        }
    }
    
    func makeNewBall(touchLocation: CGPoint)
    {
        var newBall = SKSpriteNode(imageNamed: "dog")
        newBall.size = CGSize(width: 100, height: 100)
        newBall.position = touchLocation
        
        addChild(newBall)
        
        // give the object physics
        newBall.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        
        newBall.physicsBody?.restitution = 1
        newBall.physicsBody?.allowsRotation = false
        newBall.physicsBody?.affectedByGravity = false
        newBall.physicsBody?.applyImpulse(CGVector(dx: 500, dy: 500))
        
    }
    
}
