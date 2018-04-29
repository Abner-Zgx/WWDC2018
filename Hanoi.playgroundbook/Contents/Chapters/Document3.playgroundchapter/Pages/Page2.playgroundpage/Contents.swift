/*:
 customize your own Hanoi into reality, and use recursion play it
 
 You can change the parameters and learn the recursion
 */
//#-hidden-code
//#-code-completion(everything, hide)

import UIKit
import SceneKit
import ARKit
import PlaygroundSupport

@objc(GameViewController)
class GameViewController: UIViewController, ARSCNViewDelegate {
    
    var sceneView: VirtualObjectARView!
    var focusFrame = FocusFrame() // 实例化聚焦节点
    var screenCenter: CGPoint!
    var tip: UILabel!
    
    // 添加或移除节点的串行队列
    let updateQueue = DispatchQueue(label: "updateQueue")
   
    // 快捷访问方式,访问ARSCNView的session
    var session: ARSession {
        return sceneView.session
    }
    
    var isSetupHanoi = false
//#-end-hidden-code
var numberOfDoughnuts = /*#-editable-code*/4/*#-end-editable-code*/
//#-hidden-code
//#-end-hidden-code
var scale = /*#-editable-code*/1/*#-end-editable-code*/
//#-hidden-code
    var doughnutHeight: Float = 0
    var chocolateBarHeight: CGFloat = 0
    var doughnutColors = [UIColor]()
    
    // 汉诺塔逻辑
    var hanoiSolver: HanoiSolver?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds = view.bounds
        screenCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        setupScene()
        setupAR()
        setupCamera()
        sceneView.scene.rootNode.addChildNode(focusFrame)
        sceneView.scene.rootNode.scale = sceneView.scene.rootNode.scale * CGFloat(scale)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 点击提示
        tip = UILabel(frame: CGRect(x: 30, y: 80, width: 200, height: 30))
        tip.backgroundColor = UIColor.white
        tip.text = "Pull into full screen"
        tip.textAlignment = .center
        tip.textColor = UIColor.black
        tip.isHidden = false
        sceneView.addSubview(tip)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        
    }
    
    //画面旋转后重新加载view
    override public func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        let bounds = view.bounds
        screenCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
}

// MARK: - setupView
extension GameViewController {
    func setupScene() {
        
        // 设置 ARSCNViewDelegate——此协议会提供回调来处理新创建的几何体
        sceneView = VirtualObjectARView(frame: view.bounds)
        view.addSubview(sceneView)
        sceneView.autoenablesDefaultLighting = true
        sceneView.delegate = self
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // 实例化scene
        let scene = HanoiScene()
        sceneView.scene = scene
        
        // 添加手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addHanoi))
        sceneView.addGestureRecognizer(tapGesture)
        
    }
    
    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else { return }
        
        camera.wantsHDR = true // 启用HDR可以让场景光照,物体材质更真实
        camera.exposureOffset = 0 // 曝光值偏压
        camera.minimumExposure = 0 // 最小曝光
        camera.maximumExposure = 0 // 最大曝光
    }
    
    func setupAR() {
        
        let configuration = ARWorldTrackingConfiguration() // 创建 session 配置（configuration）实例
        configuration.planeDetection = .horizontal // 设置该属性后，就会开始收到 ARSCNViewDelegate 协议 delegate 方法的回调
        sceneView.session.run(configuration) // 运行 view 的 session
    }
    
    // 更新聚焦框的状态和位置
    func updateFocusFrame() {
        guard let (worldPosition, planeAnchor, _) = sceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusFrame.lastPosition) else {
            updateQueue.async {
                self.focusFrame.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusFrame)
            }
            return
        }
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(self.focusFrame)
            let camera = self.session.currentFrame?.camera
            
            if let planeAnchor = planeAnchor {
                
                DispatchQueue.main.async {
                    self.tip.text = "Tap your screen"
                }
            
                self.focusFrame.state = .planeDetected(anchorPosition: worldPosition, planeAnchor: planeAnchor, camera: camera)
                
            } else {
                self.focusFrame.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
            }
        }
    }
    
    @objc func addHanoi() {
        
        if self.focusFrame.isPlaneDetected && !isSetupHanoi {
            let HanoiPosition = focusFrame.position
            print(HanoiPosition)
            let scene = sceneView.scene as! HanoiScene
            scene.numberOfDoughnuts = self.numberOfDoughnuts // 要最先赋值
            scene.hanoiSolver = HanoiSolver(numberOfDoughnuts: numberOfDoughnuts)
//#-end-hidden-code
var speed = /*#-editable-code*/1/*#-end-editable-code*/
//#-hidden-code
            scene.duration = TimeInterval(speed)
//#-end-hidden-code
var doughnutColors = [/*#-editable-code*/#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)/*#-end-editable-code*/]
//#-hidden-code
            scene.scale = CGFloat(scale)
            scene.doughnutColors = doughnutColors
//#-end-hidden-code
var particleColor = /*#-editable-code*/#colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)/*#-end-editable-code*/
//#-hidden-code
            scene.particleColor = particleColor
//#-end-hidden-code
var particleSize = /*#-editable-code*/0.01/*#-end-editable-code*/
//#-hidden-code
            scene.particleSize = CGFloat(particleSize)
            scene.setupDoughnuts(withFocus: HanoiPosition) //要先设置doughtnuts控制bars的间隙
            scene.setupBars(withFocus: HanoiPosition)
            scene.hanoiSolver?.moves = []
//#-end-hidden-code

//recursive
hanoi(numberOfDoughnuts: numberOfDoughnuts, from: 0, dependOn: 1, to: 2)
//#-hidden-code
            scene.recursiveAnimation(index: 0, withFocus: HanoiPosition) // 然后开始执行动画
            //scene.startToAnimation(withFocus: HanoiPosition)
            isSetupHanoi = true
            self.focusFrame.hide()
            PlaygroundPage.current.assessmentStatus = .pass(message: "You're very smart \n\n I hope you'll get to know more about the algorithms in the future")
        }
    }
//#-end-hidden-code
func hanoi(numberOfDoughnuts: Int, from: Int, dependOn: Int, to: Int) {
    if numberOfDoughnuts == 1 {
        move(from: from, to: to)
    } else {
        hanoi(numberOfDoughnuts: numberOfDoughnuts - 1, from: /*#-editable-code*/from/*#-end-editable-code*/, dependOn: /*#-editable-code*/to/*#-end-editable-code*/, to: /*#-editable-code*/dependOn/*#-end-editable-code*/)
        
        move(from: from, to: to)
        hanoi(numberOfDoughnuts: numberOfDoughnuts - 1, from: /*#-editable-code*/dependOn/*#-end-editable-code*/, dependOn: /*#-editable-code*/from/*#-end-editable-code*/, to: /*#-editable-code*/to/*#-end-editable-code*/)
    }
}
//#-hidden-code
    // 移动的逻辑部分
    func move(from: Int, to: Int) {
        let hanoiScene = sceneView.scene  as! HanoiScene
        let hanoiSolver = hanoiScene.hanoiSolver
        let doughnut = hanoiSolver?.popDoughnut(bar: from) // 取出from圆盘
        let doughnutIndex = doughnut // 记录初始圆盘
        let destinationDoughnutCount = hanoiSolver?.bars[to].count // 目标柱子的圆盘数量
        
        hanoiSolver?.pushDoughnut(doughnut: doughnut!, bar: to) // 目标柱子加入圆盘
        
        let move = DoughnutMove(doughtnutIndex: doughnutIndex!, destinationDoughnutCount: destinationDoughnutCount!, destinationBarIndex: to) // 初始化HanoiMove
        hanoiSolver?.moves.append(move)
    }
    
}


// MARK:- SCNSceneRendererDelegate
extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.updateFocusFrame()
    }
}

let gameViewController = GameViewController()
PlaygroundPage.current.liveView = gameViewController

//#-end-hidden-code
