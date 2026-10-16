import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      UIApplication.shared.applicationIconBadgeNumber = -1
      UIApplication.shared.applicationIconBadgeNumber = 0
    }
  }
}
