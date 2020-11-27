
import UIKit
import SpriteKit
import AVFoundation

class ViewController: UIViewController {
  
  // MARK: Properties
  
  // The scene draws the tiles and sprites, and handles swipes.
  var scene: GameScene!
  
  var movesLeft = 0
  var score = 0
    
    var level: Level!

    func beginGame() {
      shuffle()
    }

    func shuffle() {
      let newTiles = level.shuffle()
      scene.addSprites(for: newTiles)
    }
  
  lazy var backgroundMusic: AVAudioPlayer? = {
    guard let url = Bundle.main.url(forResource: "Mining by Moonlight", withExtension: "mp3") else {
      return nil
    }
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.numberOfLoops = -1
      return player
    } catch {
      return nil
    }
  }()
  
  // MARK: IBOutlets
  @IBOutlet weak var gameOverPanel: UIImageView!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var movesLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var shuffleButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure the view
    let skView = view as! SKView
    skView.isMultipleTouchEnabled = false
    
    // Create and configure the scene.
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .aspectFill
    level = Level()
    scene.level = level
    scene.swipeHandler = handleSwipe

    // Present the scene.
    skView.presentScene(scene)
    beginGame()

    
  }
  
  // MARK: IBActions
  @IBAction func shuffleButtonPressed(_: AnyObject) {
    
  }
  
  // MARK: View Controller Functions
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return [.portrait, .portraitUpsideDown]
  }

    func handleSwipe(_ swap: Swap) {
      view.isUserInteractionEnabled = false

      level.performSwap(swap)
      scene.animate(swap) {
        self.view.isUserInteractionEnabled = true
      }
    }
}
