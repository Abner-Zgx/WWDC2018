/*:
 Welcome to the world with doughnuts and chocolate bars.
 
 Firstly, let's have a look at what is Hanoi.
 
 Tip：
 
 run my code
 
 when you find a plane, tap it
 
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(description, show, "setupAR()")
import UIKit
import SceneKit
import ARKit
import PlaygroundSupport
import AVFoundation

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
    var numberOfDoughnuts = 4
    var scale = 1
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
        //#-end-hidden-code
        //#-editable-code
        setupAR()
        //#-end-editable-code
        //#-hidden-code
        
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
        // sceneView.autoenablesDefaultLighting = true
        sceneView.delegate = self
        
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
            var speed = 0.5
            scene.duration = TimeInterval(speed)
            var doughnutColors = [#colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)]
            scene.scale = CGFloat(scale)
            scene.doughnutColors = doughnutColors
            scene.setupDoughnuts(withFocus: HanoiPosition) //要先设置doughtnuts控制bars的间隙
            scene.setupBars(withFocus: HanoiPosition)
            scene.hanoiSolver?.moves = []
            hanoi(numberOfDoughnuts: numberOfDoughnuts, from: 0, dependOn: 1, to: 2)
            scene.recursiveAnimation(index: 0, withFocus: HanoiPosition) // 然后开始执行动画
            isSetupHanoi = true
            self.focusFrame.hide()
            PlaygroundPage.current.assessmentStatus = .pass(message: "WoW! Is Hanoi amazing?\n\n[Let's learn how to play it in 2D](@next)")
        }
    }
    //recursive
    func hanoi(numberOfDoughnuts: Int, from: Int, dependOn: Int, to: Int) {
        if numberOfDoughnuts == 1 {
            move(from: from, to: to)
        } else {
            hanoi(numberOfDoughnuts: numberOfDoughnuts - 1, from: from, dependOn: to, to: dependOn)
            
            move(from: from, to: to)
            hanoi(numberOfDoughnuts: numberOfDoughnuts - 1, from: dependOn, dependOn: from, to: to)
        }
    }
    
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


