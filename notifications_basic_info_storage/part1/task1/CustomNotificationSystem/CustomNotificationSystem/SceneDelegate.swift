import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let senderVC = SenderViewController()
        senderVC.title = "Sender"

        let receiverVC = ReceiverViewController()
        receiverVC.title = "Receiver"

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: senderVC),
            UINavigationController(rootViewController: receiverVC)
        ]

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

