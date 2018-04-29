/*:
 **Target：use the pattern to move an even number of doughnuts**
 
 Note：If you have an odd number of doughnuts, it is carried out by the following two steps
 
 * Step1 move the smallest doughnut from now to the next bar by the cyclic order of A➔C➔B➔A
 
 * Step2 move the movable(top) doughnut which is the seceond smallest one
 
 Hint：Change the speed of doughnut by modifying the code
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(description, show, "moveDoughtnut(from: ChocolateBarTag, to: ChocolateBarTag)")
//#-code-completion(identifier, show, A, B, C)
import PlaygroundSupport
import UIKit
import AVFoundation

@objc(GameViewController)
public class GameViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    //添加一个AVAudioPlayer类型的播放器变量
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet var safeArea: UIView!
    @IBOutlet weak var gameContainer: UIView!
    
    //定义ABC
    let A = ChocolateBarTag.A
    let B = ChocolateBarTag.B
    let C = ChocolateBarTag.C
    
    //起点
    var fromBarUp = [UIImageView]()
    var fromBarDown = [UIImageView]()
    //终点
    var toBarUp = [UIImageView]()
    var toBarDown = [UIImageView]()
    
    //巧克力棒定义
    let chocolateBarA = UIImageView()
    let chocolateBarB = UIImageView()
    let chocolateBarC = UIImageView()
    var chocolateBarW: CGFloat!
    var chocolateBarH: CGFloat!
    var barPositionY: CGFloat!
    var positionCenterX1: CGFloat!
    var positionCenterX2: CGFloat!
    var positionCenterX3: CGFloat!
    
    //巧克力棒数组
    var barAUp = [UIImageView]()
    var barBUp = [UIImageView]()
    var barCUp = [UIImageView]()
    var barADown = [UIImageView]()
    var barBDown = [UIImageView]()
    var barCDown = [UIImageView]()
    
    //巧克力棒定义
    let wordA = UILabel()
    let wordB = UILabel()
    let wordC = UILabel()
    
    //甜甜圈
    var doughnut1Up = UIImageView()
    var doughnut1Down = UIImageView()
    var doughnut2Up = UIImageView()
    var doughnut2Down = UIImageView()
    var doughnut3Up = UIImageView()
    var doughnut3Down = UIImageView()
    var doughnut4Up = UIImageView()
    var doughnut4Down = UIImageView()
    var doughnut5Up = UIImageView()
    var doughnut5Down = UIImageView()
    var doughnut6Up = UIImageView()
    var doughnut6Down = UIImageView()
    
    //甜甜圈定义
    var doughnutCenterX: CGFloat!
    var doughnutCenterY: CGFloat!
    var doughnutW: CGFloat!
    var doughnutH: CGFloat!
    let doughtnutSpace: CGFloat = 1 //甜甜圈距离
    
    //上升y值
    var upSpace: CGFloat!
    
    //延迟时间
    var delayTime: TimeInterval = 0
    
    //闪烁计时器
    var timerA: Timer!
    var timerB: Timer!
    var timerC: Timer!
    
    //闪烁步骤判断是否正确
    var isTrue = true
    
    //进度
    var progress = 0
    
    //完成计时器
    var timerFinished: Timer!
    
    //提示文字
    var hint1 = UILabel()
    var hint2 = UILabel()
    var hint3 = UILabel()
    var hint4 = UILabel()
    var hint5 = UILabel()
    var hint6 = UILabel()
    var hint7 = UILabel()
    var hint8 = UILabel()
    var hint9 = UILabel()
    var hint10 = UILabel()
    var hint11 = UILabel()
    var hint12 = UILabel()
    var hint13 = UILabel()
    var hint14 = UILabel()
    var hint15 = UILabel()
    var hint16 = UILabel()
    var hint17 = UILabel()
    var hint18 = UILabel()
    var hint19 = UILabel()
    var hint20 = UILabel()
    var hint21 = UILabel()
    var hint22 = UILabel()
    var hint23 = UILabel()
    var hint24 = UILabel()
    var hint25 = UILabel()
    var hint26 = UILabel()
    var hint27 = UILabel()
    var hint28 = UILabel()
    var hint29 = UILabel()
    var hint30 = UILabel()
    var hint31 = UILabel()
    var hintCenterX: CGFloat!
    var hintCenterY: CGFloat!

    //MARK:- 修改处1
    //MARK:- 甜甜圈数量
    var doughtnutNumber: Int = 5
    //#-end-hidden-code
    // speed of doughnut
    // the smaller number, move faster
    var speed: TimeInterval = /*#-editable-code*/1/*#-end-editable-code*/
    //#-hidden-code
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        //让所有的巧克力棒数组有tag=0的imageView初值
        let zeroImageViewUp = UIImageView()
        zeroImageViewUp.tag = 0
        let zeroImageViewDown = UIImageView()
        zeroImageViewDown.tag = 0
        barAUp.append(zeroImageViewUp)
        barBUp.append(zeroImageViewUp)
        barCUp.append(zeroImageViewUp)
        barADown.append(zeroImageViewDown)
        barBDown.append(zeroImageViewDown)
        barCDown.append(zeroImageViewDown)
        
    }
    
    //MARK:自适应
    //画面出现后重新加载view
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //UI界面
        setupUI()
    }
    
    //画面旋转后重新加载view
    override public func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        //MARK:- 修改处2
        doughnut1Up.layer.removeAllAnimations()
        doughnut1Down.layer.removeAllAnimations()
        doughnut2Up.layer.removeAllAnimations()
        doughnut2Down.layer.removeAllAnimations()
        doughnut3Up.layer.removeAllAnimations()
        doughnut3Down.layer.removeAllAnimations()
        doughnut4Up.layer.removeAllAnimations()
        doughnut4Down.layer.removeAllAnimations()
        doughnut5Up.layer.removeAllAnimations()
        doughnut5Down.layer.removeAllAnimations()
        
        setupUI()

    }

@IBAction func start(_ sender: UIButton)
{
    //#-end-hidden-code
    //#-editable-code
    //#-end-editable-code
    //#-hidden-code
    sender.isUserInteractionEnabled = false
    }
    
}

//MARK:- setupUI
public extension GameViewController {
    
    public func setupUI(){
        
        //重置延时
        delayTime = 0
        //重置胜利计时器
        timerFinished?.fireDate = Date.distantFuture
        //重置按钮有效性
        button.isUserInteractionEnabled = true
        //重置进度
        progress = 0
        
        //MARK:- 定义赋值
        upSpace = gameContainer.bounds.height / 5 //上升y值
        doughnutH = gameContainer.bounds.width / 22 //甜甜圈高度固定值
        //巧克力棒固定值赋值
        chocolateBarW = gameContainer.bounds.width / 22
        chocolateBarH = gameContainer.bounds.height * 3 / 5
        barPositionY = gameContainer.bounds.height / 2
        positionCenterX1 = gameContainer.bounds.width / 4
        positionCenterX2 = gameContainer.bounds.width * 2 / 4
        positionCenterX3 = gameContainer.bounds.width * 3 / 4
        
        //safeArea约束
        NSLayoutConstraint.activate([
            safeArea.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 20),
            safeArea.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
            ])
        
        //gameContainer约束
        gameContainer.constrainToCenterOfParent(withAspectRatio: 1.0)
        
        //甜甜圈靠外
        doughnutUp(number: doughtnutNumber)
        
        //巧克力棒
        setupBar()
        
        //甜甜圈靠内
        doughnutDown(number: doughtnutNumber)
        
        //字母
        setupWord()
        
        //提示
        setupHint()
    }
    
    //MARK:- 巧克力棒
    public func setupBar() {
        
        //巧克力棒A
        chocolateBarA.frame = CGRect(x: 0, y: 0, width: chocolateBarW, height: chocolateBarH)
        chocolateBarA.center = CGPoint(x: positionCenterX1, y: barPositionY)
        chocolateBarA.image = UIImage(named: "chocolateBar")
        gameContainer.addSubview(chocolateBarA)
        
        //巧克力棒B
        chocolateBarB.frame = CGRect(x: 0, y: 0, width: chocolateBarW, height: chocolateBarH)
        chocolateBarB.center = CGPoint(x: positionCenterX2, y: barPositionY)
        chocolateBarB.image = UIImage(named: "chocolateBar")
        gameContainer.addSubview(chocolateBarB)
        
        //巧克力棒C
        chocolateBarC.frame = CGRect(x: 0, y: 0, width: chocolateBarW, height: chocolateBarH)
        chocolateBarC.center = CGPoint(x: positionCenterX3, y: barPositionY)
        chocolateBarC.image = UIImage(named: "chocolateBar")
        gameContainer.addSubview(chocolateBarC)
        
    }
    
    //MARK:- 甜甜圈
    //上半部分
    func doughnutUp(number: Int) {
        
        //重制UI时重制数组
        barAUp.removeAll()
        barBUp.removeAll()
        barCUp.removeAll()
        let zeroImageViewUp = UIImageView()
        zeroImageViewUp.tag = 0
        barAUp.append(zeroImageViewUp)
        barBUp.append(zeroImageViewUp)
        barCUp.append(zeroImageViewUp)
        
        //记录数量
        for i in 1...number {
            
            //甜甜圈固定值(i越小,越底层,tag越大)
            let doughnutW: CGFloat = gameContainer.frame.width / 8 + CGFloat((number - i) * 6)
            doughnutCenterX = positionCenterX1
            let originCenterY = barPositionY + chocolateBarH * 4.0 / 11.0
            doughnutCenterY = originCenterY - doughnutH / 2.0 - CGFloat(i-1) * (doughnutH + doughtnutSpace) //巧克力部分9/10 露出的棍1/10;上半部分 - doughnutW / 2
            
            //加入数组和显示
            if i == 1 {
                //甜甜圈
                doughnut1Up.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut1Up.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut1Up.image = UIImage(named: "doughnut\(i)_1")
                doughnut1Up.tag = number - (i - 1)
                gameContainer.addSubview(doughnut1Up)
                barAUp.append(doughnut1Up)
            }else if (i == 2){
                doughnut2Up.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut2Up.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut2Up.image = UIImage(named: "doughnut\(i)_1")
                doughnut2Up.tag = number - (i - 1)
                gameContainer.addSubview(doughnut2Up)
                barAUp.append(doughnut2Up)
            }else if (i == 3){
                doughnut3Up.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut3Up.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut3Up.image = UIImage(named: "doughnut\(i)_1")
                doughnut3Up.tag = number - (i - 1)
                gameContainer.addSubview(doughnut3Up)
                barAUp.append(doughnut3Up)
            }else if (i == 4){
                doughnut4Up.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut4Up.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut4Up.image = UIImage(named: "doughnut\(i)_1")
                doughnut4Up.tag = number - (i - 1)
                gameContainer.addSubview(doughnut4Up)
                barAUp.append(doughnut4Up)
            }else if (i == 5){
                doughnut5Up.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut5Up.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut5Up.image = UIImage(named: "doughnut\(i)_1")
                doughnut5Up.tag = number - (i - 1)
                gameContainer.addSubview(doughnut5Up)
                barAUp.append(doughnut5Up)
            }else if (i == 6){
                doughnut6Up.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut6Up.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut6Up.image = UIImage(named: "doughnut\(i)_1")
                doughnut6Up.tag = number - (i - 1)
                gameContainer.addSubview(doughnut6Up)
                barAUp.append(doughnut6Up)
            }
            
            
        }
        
        
    }
    
    //下半部分
    func doughnutDown(number: Int) {
        
        //重制UI时重制数组
        barADown.removeAll()
        barBDown.removeAll()
        barCDown.removeAll()
        let zeroImageViewDown = UIImageView()
        zeroImageViewDown.tag = 0
        barADown.append(zeroImageViewDown)
        barBDown.append(zeroImageViewDown)
        barCDown.append(zeroImageViewDown)
        
        //记录数量
        for i in 1...number {
            
            //甜甜圈固定值
            let doughnutW: CGFloat = gameContainer.frame.width / 8 + CGFloat((number - i) * 6)
            doughnutCenterX = positionCenterX1
            let originCenterY = barPositionY + chocolateBarH * 4.0 / 11.0
            doughnutCenterY = originCenterY + doughnutH / 2.0 - CGFloat(i-1) * (doughnutH + doughtnutSpace) //巧克力部分9/10 露出的棍1/10
            
            //加入数组和显示
            if i == 1 {
                //甜甜圈
                doughnut1Down.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut1Down.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut1Down.image = UIImage(named: "doughnut\(i)_2")
                doughnut1Down.tag = number - (i - 1)
                gameContainer.addSubview(doughnut1Down)
                barADown.append(doughnut1Down)
            }else if (i == 2){
                doughnut2Down.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut2Down.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut2Down.image = UIImage(named: "doughnut\(i)_2")
                doughnut2Down.tag = number - (i - 1)
                gameContainer.addSubview(doughnut2Down)
                barADown.append(doughnut2Down)
            }else if (i == 3){
                doughnut3Down.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut3Down.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut3Down.image = UIImage(named: "doughnut\(i)_2")
                doughnut3Down.tag = number - (i - 1)
                gameContainer.addSubview(doughnut3Down)
                barADown.append(doughnut3Down)
            }else if (i == 4){
                doughnut4Down.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut4Down.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut4Down.image = UIImage(named: "doughnut\(i)_2")
                doughnut4Down.tag = number - (i - 1)
                gameContainer.addSubview(doughnut4Down)
                barADown.append(doughnut4Down)
            }else if (i == 5){
                doughnut5Down.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut5Down.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut5Down.image = UIImage(named: "doughnut\(i)_2")
                doughnut5Down.tag = number - (i - 1)
                gameContainer.addSubview(doughnut5Down)
                barADown.append(doughnut5Down)
            }else if (i == 6){
                doughnut6Down.frame = CGRect(x: 0, y: 0, width: doughnutW, height: doughnutH!)
                doughnut6Down.center = CGPoint(x: doughnutCenterX, y: doughnutCenterY)
                doughnut6Down.image = UIImage(named: "doughnut\(i)_2")
                doughnut6Down.tag = number - (i - 1)
                gameContainer.addSubview(doughnut6Down)
                barADown.append(doughnut6Down)
            }
        }
        
        
    }
    
    //MARK:- 字母
    func setupWord() {
        
        //字母固定值
        let wordW: CGFloat = chocolateBarA.frame.width
        let wordH: CGFloat = wordW
        
        //A
        wordA.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: wordW, height: wordH))
        wordA.text = "A"
        wordA.textColor = .brown
        wordA.textAlignment = .center
        
        wordA.center = CGPoint(x: chocolateBarA.center.x, y: chocolateBarA.frame.maxY + wordH)
        gameContainer.addSubview(wordA)
        
        //B
        wordB.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: wordW, height: wordH))
        wordB.text = "B"
        wordB.textColor = .brown
        wordB.textAlignment = .center
        wordB.center = CGPoint(x: chocolateBarB.center.x, y: chocolateBarB.frame.maxY + wordH)
        gameContainer.addSubview(wordB)
        
        //C
        wordC.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: wordW, height: wordH))
        wordC.text = "C"
        wordC.textColor = .brown
        wordC.textAlignment = .center
        wordC.center = CGPoint(x: chocolateBarC.center.x, y: chocolateBarC.frame.maxY + wordH)
        gameContainer.addSubview(wordC)
        
    }
    
    //MARK:- 提示
    public func setupHint() {

        //线索1
        hint1 = createHint(hint: hint1, text: "move the smallest doughnut by the cyclic order of A➔C", alpha: 1.0)
        
        //线索2
        hint2 = createHint(hint: hint2, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索3
        hint3 = createHint(hint: hint3, text: "move the smallest doughnut by the cyclic order of C➔B", alpha: 0.0)
        
        //线索4
        hint4 = createHint(hint: hint4, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索5
        hint5 = createHint(hint: hint5, text: "move the smallest doughnut by the cyclic order of B➔A", alpha: 0.0)
        
        //线索6
        hint6 = createHint(hint: hint6, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索7
        hint7 = createHint(hint: hint7, text: "move the smallest doughnut by the cyclic order of A➔C", alpha: 0.0)
        
        //线索8
        hint8 = createHint(hint: hint8, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索9
        hint9 = createHint(hint: hint9, text: "move the smallest doughnut by the cyclic order of C➔B", alpha: 0.0)
        
        //线索10
        hint10 = createHint(hint: hint10, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索11
        hint11 = createHint(hint: hint11, text: "move the smallest doughnut by the cyclic order of B➔A", alpha: 0.0)
        
        //线索12
        hint12 = createHint(hint: hint12, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索13
        hint13 = createHint(hint: hint13, text: "move the smallest doughnut by the cyclic order of A➔C", alpha: 0.0)
        
        //线索14
        hint14 = createHint(hint: hint14, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索15
        hint15 = createHint(hint: hint15, text: "move the smallest doughnut by the cyclic order of C➔B", alpha: 0.0)
        
        //线索16
        hint16 = createHint(hint: hint16, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索17
        hint17 = createHint(hint: hint17, text: "move the smallest doughnut by the cyclic order of B➔A", alpha: 0.0)
        
        //线索18
        hint18 = createHint(hint: hint18, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索19
        hint19 = createHint(hint: hint19, text: "move the smallest doughnut by the cyclic order of A➔C", alpha: 0.0)
        
        //线索20
        hint20 = createHint(hint: hint20, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索21
        hint21 = createHint(hint: hint21, text: "move the smallest doughnut by the cyclic order of C➔B", alpha: 0.0)
        
        //线索22
        hint22 = createHint(hint: hint22, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索23
        hint23 = createHint(hint: hint23, text: "move the smallest doughnut by the cyclic order of B➔A", alpha: 0.0)
        
        //线索24
        hint24 = createHint(hint: hint24, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索25
        hint25 = createHint(hint: hint25, text: "move the smallest doughnut by the cyclic order of A➔C", alpha: 0.0)
        
        //线索26
        hint26 = createHint(hint: hint26, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索27
        hint27 = createHint(hint: hint27, text: "move the smallest doughnut by the cyclic order of C➔B", alpha: 0.0)
        
        //线索28
        hint28 = createHint(hint: hint28, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索29
        hint29 = createHint(hint: hint29, text: "move the smallest doughnut by the cyclic order of B➔A", alpha: 0.0)
        
        //线索30
        hint30 = createHint(hint: hint30, text: "move the movable doughnut which is the seceond smallest one", alpha: 0.0)
        
        //线索31
        hint31 = createHint(hint: hint31, text: "move the smallest doughnut by the cyclic order of A➔C", alpha: 0.0)
    }
    
    //MARK:- 快速制作线索
    func createHint(hint: UILabel, text: String, alpha: CGFloat) -> UILabel {
                
        //提示定义赋值
        hintCenterX = gameContainer.bounds.width / 2
        hintCenterY =  chocolateBarB.frame.maxY + chocolateBarB.bounds.width * 3 //巧克力棒+（字母+空隙）
        
        let hintW = gameContainer.bounds.width
        let hintH = chocolateBarB.bounds.width
        
        //线索
        hint.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: hintW, height: hintH))
        hint.center = CGPoint(x: hintCenterX, y: hintCenterY)
        
        hint.text = text
        hint.alpha = alpha
        
        hint.textColor = UIColor.orange
        hint.textAlignment = .center
        hint.backgroundColor = UIColor.clear
        gameContainer.addSubview(hint)
        
        return hint
        
    }
    
}

//MARK:- 移动(修改处3)
public extension GameViewController {

    func moveDoughtnut(from: ChocolateBarTag, to: ChocolateBarTag) {
        
        //记录要移动的甜甜圈对应的柱子
        if from == A {
            fromBarUp = barAUp
            fromBarDown = barADown
        }else if(from == B){
            fromBarUp = barBUp
            fromBarDown = barBDown
        }else if(from == C){
            fromBarUp = barCUp
            fromBarDown = barCDown
        }
        
        //记录甜甜圈要移向的柱子
        if to == A {
            toBarUp = barAUp
            toBarDown = barADown
        }else if(to == B){
            toBarUp = barBUp
            toBarDown = barBDown
        }else if(to == C){
            toBarUp = barCUp
            toBarDown = barCDown
        }
        
        if(fromBarUp.last?.tag == 0) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime) {
                let alertController = UIAlertController(title: "Check", message: "No doughnut", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
            }
        }else if(fromBarUp.last!.tag > toBarUp.last!.tag && toBarUp.last?.tag != 0) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime) {
                let alertController = UIAlertController(title: "Check", message: "Don't put the bigger doughnut on the smaller one", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
            }
        }else {
            print("移动")
            
            //如果toBar没有则赋值
            if toBarUp.last?.tag == 0 && toBarDown.last?.tag == 0 {
                let originCenterY = barPositionY + chocolateBarH * 4.0 / 11.0
                let toBarUpCenter = originCenterY - doughnutH / 2.0
                let toBarDownCenter = originCenterY + doughnutH / 2.0
                if to == A {
                    //上半部分
                    toBarUp.last?.center = CGPoint(x: chocolateBarA.center.x, y: toBarUpCenter + (doughnutH + doughtnutSpace)) //因为下面要减去空隙,这里第一次加上
                    
                    //下半部分
                    toBarDown.last?.center = CGPoint(x: chocolateBarA.center.x, y: toBarDownCenter + (doughnutH + doughtnutSpace))
                    
                }else if(to == B){
                    //上半部分
                    toBarUp.last?.center = CGPoint(x: chocolateBarB.center.x, y: toBarUpCenter + (doughnutH + doughtnutSpace))
                    
                    //下半部分
                    toBarDown.last?.center = CGPoint(x: chocolateBarB.center.x, y: toBarDownCenter + (doughnutH + doughtnutSpace))
                    
                }else {
                    //上半部分
                    toBarUp.last?.center = CGPoint(x: chocolateBarC.center.x, y: toBarUpCenter + (doughnutH + doughtnutSpace))
                    
                    //下半部分
                    toBarDown.last?.center = CGPoint(x: chocolateBarC.center.x, y: toBarDownCenter + (doughnutH + doughtnutSpace))
                    
                    toBarUp.last?.center = CGPoint(x: chocolateBarC.center.x, y: toBarUpCenter + (doughnutH + doughtnutSpace))
                }
            }
            
            //取出view
            let moveDoughtnutUp = self.fromBarUp.last!
            let moveDoughtnutDown = self.fromBarDown.last!
            
            //上移
            UIView.animate(withDuration: speed, delay: delayTime, options: .curveEaseInOut, animations: {
                //完成后跳出成功提示
                self.ifLabelNeedAnimate(from: from, to: to)
                self.delayTime += self.speed
                moveDoughtnutUp.center = CGPoint(x: (self.fromBarUp.last?.center.x)!, y: self.upSpace - self.doughnutH / 2)
                moveDoughtnutDown.center = CGPoint(x: (self.fromBarDown.last?.center.x)!, y: self.upSpace + self.doughnutH / 2)
                print("up")
                //取出view后移除
                self.fromBarUp.removeLast()
                self.fromBarDown.removeLast()
                if from == self.A {
                    self.barAUp = self.fromBarUp
                    self.barADown = self.fromBarDown
                }else if(from == self.B){
                    self.barBUp = self.fromBarUp
                    self.barBDown = self.fromBarDown
                }else {
                    self.barCUp = self.fromBarUp
                    self.barCDown = self.fromBarDown
                }
            })
            
            //平移
            UIView.animate(withDuration: speed, delay: delayTime, options: .curveEaseInOut, animations: {
                self.delayTime += self.speed
                moveDoughtnutUp.center = CGPoint(x: (self.toBarUp.last?.center.x)!, y: self.upSpace - self.doughnutH / 2)
                moveDoughtnutDown.center = CGPoint(x: (self.toBarDown.last?.center.x)!, y: self.upSpace + self.doughnutH / 2)
                print("move")
            })
            
            //下移
            UIView.animate(withDuration: speed, delay: delayTime, options: .curveEaseInOut, animations: {
                self.delayTime += self.speed
                moveDoughtnutUp.center = CGPoint(x: (self.toBarUp.last?.center.x)!, y: (self.toBarUp.last?.center.y)! - (self.doughnutH + self.doughtnutSpace))
                moveDoughtnutDown.center = CGPoint(x: (self.toBarDown.last?.center.x)!, y: (self.toBarDown.last?.center.y)! -  (self.doughnutH + self.doughtnutSpace))
                print("down")
                
                self.toBarUp.append(moveDoughtnutUp)
                self.toBarDown.append(moveDoughtnutDown)
                //添加甜甜圈
                if to == self.A {
                    self.barAUp = self.toBarUp
                    self.barADown = self.toBarDown
                }else if(to == self.B){
                    self.barBUp = self.toBarUp
                    self.barBDown = self.toBarDown
                }else {
                    self.barCUp = self.toBarUp
                    self.barCDown = self.toBarDown
                }
            })
            
            
        }
        
        //完成后跳出成功提示
        if (barCUp.count == doughtnutNumber + 1) {
            // 播放音乐
            playBgMusic()
            timerFinished = Timer.scheduledTimer(timeInterval: delayTime, target: self, selector: #selector(successPass), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc public func successPass() {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Congratulations on learning the pattern of odd numbers! \n\n[next](@next)")
    }
    
    //MARK:- 提示动画
    func ifLabelNeedAnimate(from: ChocolateBarTag, to: ChocolateBarTag) {
        progress += 1
        if (from == A && to == C && progress == 1 && isTrue) {
            disappearThenAppear(firstLabel: hint1, nextLabel: hint2)
        }else if (from == A && to == B && progress == 2 && isTrue) {
            disappearThenAppear(firstLabel: hint2, nextLabel: hint3)
        }else if (from == C && to == B && progress == 3 && isTrue) {
            disappearThenAppear(firstLabel: hint3, nextLabel: hint4)
        }else if (from == A && to == C && progress == 4 && isTrue) {
            disappearThenAppear(firstLabel: hint4, nextLabel: hint5)
        }else if (from == B && to == A && progress == 5 && isTrue) {
            disappearThenAppear(firstLabel: hint5, nextLabel: hint6)
        }else if (from == B && to == C && progress == 6 && isTrue) {
            disappearThenAppear(firstLabel: hint6, nextLabel: hint7)
        }else if (from == A && to == C && progress == 7 && isTrue){
            disappearThenAppear(firstLabel: hint7, nextLabel: hint8)
        }else if (from == A && to == B && progress == 8 && isTrue) {
            disappearThenAppear(firstLabel: hint8, nextLabel: hint9)
        }else if (from == C && to == B && progress == 9 && isTrue) {
            disappearThenAppear(firstLabel: hint9, nextLabel: hint10)
        }else if (from == C && to == A && progress == 10 && isTrue){
            disappearThenAppear(firstLabel: hint10, nextLabel: hint11)
        }else if (from == B && to == A && progress == 11 && isTrue) {
            disappearThenAppear(firstLabel: hint11, nextLabel: hint12)
        }else if (from == C && to == B && progress == 12 && isTrue) {
            disappearThenAppear(firstLabel: hint12, nextLabel: hint13)
        }else if (from == A && to == C && progress == 13 && isTrue){
            disappearThenAppear(firstLabel: hint13, nextLabel: hint14)
        }else if (from == A && to == B && progress == 14 && isTrue) {
            disappearThenAppear(firstLabel: hint14, nextLabel: hint15)
        }else if (from == C && to == B && progress == 15 && isTrue){
            disappearThenAppear(firstLabel: hint15, nextLabel: hint16)
        }else if (from == A && to == C && progress == 16 && isTrue) {
            disappearThenAppear(firstLabel: hint16, nextLabel: hint17)
        }else if (from == B && to == A && progress == 17 && isTrue) {
            disappearThenAppear(firstLabel: hint17, nextLabel: hint18)
        }else if (from == B && to == C && progress == 18 && isTrue) {
            disappearThenAppear(firstLabel: hint18, nextLabel: hint19)
        }else if (from == A && to == C && progress == 19 && isTrue){
            disappearThenAppear(firstLabel: hint19, nextLabel: hint20)
        }else if (from == B && to == A && progress == 20 && isTrue) {
            disappearThenAppear(firstLabel: hint20, nextLabel: hint21)
        }else if (from == C && to == B && progress == 21 && isTrue) {
            disappearThenAppear(firstLabel: hint21, nextLabel: hint22)
        }else if (from == C && to == A && progress == 22 && isTrue){
            disappearThenAppear(firstLabel: hint22, nextLabel: hint23)
        }else if (from == B && to == A && progress == 23 && isTrue) {
            disappearThenAppear(firstLabel: hint23, nextLabel: hint24)
        }else if (from == B && to == C && progress == 24 && isTrue) {
            disappearThenAppear(firstLabel: hint24, nextLabel: hint25)
        }else if (from == A && to == C && progress == 25 && isTrue){
            disappearThenAppear(firstLabel: hint25, nextLabel: hint26)
        }else if (from == A && to == B && progress == 26 && isTrue) {
            disappearThenAppear(firstLabel: hint26, nextLabel: hint27)
        }else if (from == C && to == B && progress == 27 && isTrue) {
            disappearThenAppear(firstLabel: hint27, nextLabel: hint28)
        }else if (from == A && to == C && progress == 28 && isTrue) {
            disappearThenAppear(firstLabel: hint28, nextLabel: hint29)
        }else if (from == B && to == A && progress == 29 && isTrue){
            disappearThenAppear(firstLabel: hint29, nextLabel: hint30)
        }else if (from == B && to == C && progress == 30 && isTrue) {
            disappearThenAppear(firstLabel: hint30, nextLabel: hint31)
        }else if (from == A && to == C && progress == 31 && isTrue) {
            UIView.animate(withDuration: speed, delay: delayTime, options: .curveEaseOut, animations: {
                self.hint31.alpha = 1
            }, completion: { (true) in
                UIView.animate(withDuration: self.speed, delay: self.speed, options: .curveEaseOut, animations: {
                    self.hint31.alpha = 0
                })
            })
        }else {
            isTrue = false
            let alertController = UIAlertController(title: "you should follow the tip below the chocolate bar", message: nil, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func disappearThenAppear(firstLabel: UILabel, nextLabel: UILabel) {
        UIView.animate(withDuration: speed, delay: delayTime, options: .curveEaseOut, animations: {
            firstLabel.alpha = 1
        }, completion: { (true) in
            UIView.animate(withDuration: self.speed, delay: self.speed, options: .curveEaseOut, animations: {
                firstLabel.alpha = 0
            },completion: { (true) in
                UIView.animate(withDuration: self.speed, delay: self.speed, options: .curveEaseOut, animations: {
                    nextLabel.alpha = 1
                })
            })
        })
    }
    
}

//MARK:- 背景音乐
public extension GameViewController {
    
    func playBgMusic() {
        
        let musicPath = Bundle.main.path(forResource: "hannuota", ofType: "mp3")
        
        //指定音乐路径
        let url = URL(fileURLWithPath: musicPath!)
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        }catch {
            print("出现异常")
        }
        
        audioPlayer!.numberOfLoops = -1
        //设置音乐播放次数，-1为循环播放
        audioPlayer!.volume = 1
        //设置音乐音量，可用范围为0~1
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
}

//MARK:- 加载storyboard
public extension GameViewController {
    class func loadFromStoryboard() -> GameViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController() as! GameViewController
    }
}

let gameViewController = GameViewController.loadFromStoryboard()
PlaygroundPage.current.liveView = gameViewController

//#-end-hidden-code
