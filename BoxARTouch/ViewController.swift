//
//  ViewController.swift
//  BoxARTouch
//
//  Created by 柳生宗矩 on 2021/09/06.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
//        boxの中身の記述。1で1m、chamferRadiusは角の丸み
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.name = "Color"
        material.diffuse.contents = UIColor.red //diffuse.contentsで色指定
        
//        Node作成
        let node = SCNNode()
        node.geometry = box                      //形をBOX（四角）に、スフィアで円
        node.geometry?.materials = [material]    //上のマテリアルを呼び出し
        node.position = SCNVector3(0, 0.2, -0.5) //3次元空間の座標指定 起動したiphoneから見た位置
        
        scene.rootNode.addChildNode(node)        //一番上のnodeに追加
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped)) //タップした時の挙動を指定
        self.sceneView.addGestureRecognizer(tapRecognizer)  //シーンビューにtapRecognizerを追加(add~でタップ時の挙動、内容をtapに指定)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    @objc func tapped(recognizer: UIGestureRecognizer) {            //42行目のtappedの関数を作成
        let sceneView = recognizer.view as! SCNView                 //タップされたオブジェクトのシーンを取得
        let touchLocation = recognizer.location(in: sceneView)      //タッチした座標を返す定数を定義、シーンビューの中でタッチされた座標
        let hitResults = sceneView.hitTest(touchLocation, options: [:]) //タッチしたデータを返す。ヒットメソッドで
        
        if !hitResults.isEmpty {                                    //hitResultsが空でなければ
            let node = hitResults[0].node                           //
            let material = node.geometry?.material(named: "Color")
            material?.diffuse.contents = UIColor.blue               //表面の色を指定
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
