import UIKit

enum Tab: Int {
    case toDo = 1
    case timer = 0
    case settings = 2
}

class TabBarController: UITabBarController {
    
    private lazy var toDoVC: ToDoViewController = {
        let toDoVC = ToDoViewController()
        toDoVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "list.bullet"),
            tag: Tab.toDo.rawValue
        )
        return toDoVC
    }()

    private lazy var timerVC: TimerViewController = {
        let timerVC = TimerViewController()
        timerVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "timer"),
            tag: Tab.timer.rawValue
        )
        return timerVC
    }()
    
    private lazy var settingsVC: SettingsViewController = {
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "gear"),
            tag: Tab.settings.rawValue
        )
        return settingsVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        setupTabBar()
    }

    private func setupTabBar() {
        viewControllers = [
            timerVC,
            settingsVC,
            toDoVC
]
        tabBar.tintColor = .systemGreen
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.barTintColor = .clear
        tabBar.isTranslucent = false
    }


}
