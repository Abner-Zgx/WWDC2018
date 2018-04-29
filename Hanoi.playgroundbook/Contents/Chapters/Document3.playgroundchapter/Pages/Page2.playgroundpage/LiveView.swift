import PlaygroundSupport
import AVFoundation
import SpriteKit
import GameKit

@objc(LiveViewController)
public class LiveViewController: UIViewController {

    //添加一个AVAudioPlayer类型的播放器变量
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var SKView: SKView!
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 播放音乐
        playBgMusic()
        
        let scene = InitialScene(size: SKView.frame.size)
        SKView.presentScene(scene)
        
    }
    
    //画面旋转后重新加载view
    override public func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        let scene = InitialScene(size: SKView.frame.size)
        SKView.presentScene(scene)
    }

}

//MARK:- 背景音乐
public extension LiveViewController {
    
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

extension LiveViewController {
    
    class func loadFromStoryboard() -> LiveViewController {
        let storyboard = UIStoryboard.init(name: "Initial", bundle: nil)
        return storyboard.instantiateInitialViewController() as! LiveViewController
    }
    
}

let liveViewController = LiveViewController.loadFromStoryboard()
PlaygroundPage.current.liveView = liveViewController



