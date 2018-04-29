/*:
 **Target：try to find the regular pattern of Hanoi**
 
 Question：If you have an even number of doughnuts, which chocolate bar should be placed with the smallest doughnut for the first move?
 What about an odd one?
 
 Note：
 
 * Don't put the bigger doughnut on the smaller one
 
 * Can only move one doughnut everytime
 
 * Can only move the top doughnut everytime
 
 Hint：Change the number of doughnut by modifying the code
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(description, show, "moveDoughnut(from: ChocolateBarTag, to: ChocolateBarTag)")
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
    let doughnutSpace: CGFloat = 1 //甜甜圈距离
    
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
    //MARK:- 修改处1
    //#-end-hidden-code
    // you can change the number of doughnuts between 1 to 6
    var numberOfDoughnuts: Int = /*#-editable-code*/6/*#-end-editable-code*/
    //#-hidden-code
    //MARK:- 移动速度
    var speed: TimeInterval = 1
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
        
        if numberOfDoughnuts <= 0 || numberOfDoughnuts >= 7 {
            let alertController = UIAlertController(title: "numberOfDoughnuts is error", message: "The number of doughnuts can only be between 1～6", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }else {
            //UI界面
            setupUI()
        }
        
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
        doughnut6Up.layer.removeAllAnimations()
        doughnut6Down.layer.removeAllAnimations()
        
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
        doughnutUp(number: numberOfDoughnuts)
        
        //巧克力棒
        setupBar()
        
        //甜甜圈靠内
        doughnutDown(number: numberOfDoughnuts)
        
        //字母
        setupWord()
        
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
            doughnutCenterY = originCenterY - doughnutH / 2.0 - CGFloat(i-1) * (doughnutH + doughnutSpace) //巧克力部分9/10 露出的棍1/10;上半部分 - doughnutW / 2
            
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
            doughnutCenterY = originCenterY + doughnutH / 2.0 - CGFloat(i-1) * (doughnutH + doughnutSpace) //巧克力部分9/10 露出的棍1/10
            
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
    
}

//MARK:- 移动
public extension GameViewController {

    func moveDoughnut(from: ChocolateBarTag, to: ChocolateBarTag) {
        
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
                    toBarUp.last?.center = CGPoint(x: chocolateBarA.center.x, y: toBarUpCenter + (doughnutH + doughnutSpace)) //因为下面要减去空隙,这里第一次加上
                    
                    //下半部分
                    toBarDown.last?.center = CGPoint(x: chocolateBarA.center.x, y: toBarDownCenter + (doughnutH + doughnutSpace))
                    
                }else if(to == B){
                    //上半部分
                    toBarUp.last?.center = CGPoint(x: chocolateBarB.center.x, y: toBarUpCenter + (doughnutH + doughnutSpace))
                    
                    //下半部分
                    toBarDown.last?.center = CGPoint(x: chocolateBarB.center.x, y: toBarDownCenter + (doughnutH + doughnutSpace))
                    
                }else {
                    //上半部分
                    toBarUp.last?.center = CGPoint(x: chocolateBarC.center.x, y: toBarUpCenter + (doughnutH + doughnutSpace))
                    
                    //下半部分
                    toBarDown.last?.center = CGPoint(x: chocolateBarC.center.x, y: toBarDownCenter + (doughnutH + doughnutSpace))
                    
                    toBarUp.last?.center = CGPoint(x: chocolateBarC.center.x, y: toBarUpCenter + (doughnutH + doughnutSpace))
                }
            }
            
            //取出view
            let moveDoughnutUp = self.fromBarUp.last!
            let moveDoughnutDown = self.fromBarDown.last!
            
            //上移
            UIView.animate(withDuration: speed, delay: delayTime, options: .curveEaseInOut, animations: {
                self.delayTime += self.speed
                moveDoughnutUp.center = CGPoint(x: (self.fromBarUp.last?.center.x)!, y: self.upSpace - self.doughnutH / 2)
                moveDoughnutDown.center = CGPoint(x: (self.fromBarDown.last?.center.x)!, y: self.upSpace + self.doughnutH / 2)
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
                moveDoughnutUp.center = CGPoint(x: (self.toBarUp.last?.center.x)!, y: self.upSpace - self.doughnutH / 2)
                moveDoughnutDown.center = CGPoint(x: (self.toBarDown.last?.center.x)!, y: self.upSpace + self.doughnutH / 2)
                print("move")
            })
            
            //下移
            UIView.animate(withDuration: speed, delay: delayTime, options: .curveEaseInOut, animations: {
                self.delayTime += self.speed
                moveDoughnutUp.center = CGPoint(x: (self.toBarUp.last?.center.x)!, y: (self.toBarUp.last?.center.y)! - (self.doughnutH + self.doughnutSpace))
                moveDoughnutDown.center = CGPoint(x: (self.toBarDown.last?.center.x)!, y: (self.toBarDown.last?.center.y)! -  (self.doughnutH + self.doughnutSpace))
                print("down")
                
                self.toBarUp.append(moveDoughnutUp)
                self.toBarDown.append(moveDoughnutDown)
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
        if (barCUp.count == numberOfDoughnuts + 1) {
            // 播放音乐
            playBgMusic()
            timerFinished = Timer.scheduledTimer(timeInterval: delayTime, target: self, selector: #selector(successPass), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc public func successPass() {
        PlaygroundPage.current.assessmentStatus = .pass(message: "Great! Have you found the regular pattern? \n\n[Let's find it](@next)")
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
