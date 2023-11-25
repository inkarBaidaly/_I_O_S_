import UIKit
import AVFoundation

class SettingsViewController: UITableViewController{
    
    enum SettingCellType {
        case switchCell(title: String, isOn: Bool)
        case valueCell(title: String, value: String)
        case actionCell(title: String)
    }
    
    var settings: [(section: String, cells: [SettingCellType])] = [
        ("SETTINGS", [
            .switchCell(title: "Remind sound", isOn: true),
            .switchCell(title: "Vibration reminder", isOn: false),
            .valueCell(title: "Background music", value: ""),
            .switchCell(title: "Night mode", isOn: false),
            .valueCell(title: "Focus time length", value: ""),
            .valueCell(title: "Short break time", value: ""),
            .valueCell(title: "Long break time", value: " "),
            .valueCell(title: "Long break interval", value: "4 Focus")
        ]),
        ("PRO FEATURES", [
            .actionCell(title: "Get the full version without ads"),
            .actionCell(title: "Restore Purchase")
        ]),
        ("FEEDBACK", [
            .actionCell(title: "Rate Us"),
            .actionCell(title: "Feedback")
        ]),
        ("SHARE", [
            .actionCell(title: "Tell a friend")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "valueCell")
        tableView.register(UISwitchTableViewCell.self, forCellReuseIdentifier: UISwitchTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "actionCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings[section].section
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.section].cells[indexPath.row]
        
        switch setting {
        case let .switchCell(title, isOn):
            let cell = tableView.dequeueReusableCell(withIdentifier: UISwitchTableViewCell.identifier, for: indexPath) as! UISwitchTableViewCell
            cell.titleLabel.text = title
            cell.switchControl.isOn = isOn
            cell.switchControl.addTarget(self, action: #selector(didToggleSwitch(_:)), for: .valueChanged)
            return cell
            
        case let .valueCell(title, value):
            let cell = tableView.dequeueReusableCell(withIdentifier: "valueCell", for: indexPath)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = value
            return cell
            
        case let .actionCell(title):
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
            cell.textLabel?.text = title
            return cell
        }
    }
    
    @objc func didToggleSwitch(_ sender: UISwitch) {
            if let cell = sender.superview as? UISwitchTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                print("Switch for \(settings[indexPath.section].cells[indexPath.row]) is now \(sender.isOn)")
            }
        }
        
        class UISwitchTableViewCell: UITableViewCell {
            static let identifier = "UISwitchTableViewCell"
            
            let titleLabel: UILabel = {
                let label = UILabel()
                return label
            }()
            
            let switchControl: UISwitch = {
                let switchControl = UISwitch()
                switchControl.onTintColor = .systemGreen
                return switchControl
            }()
            
            override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                super.init(style: style, reuseIdentifier: reuseIdentifier)
                
                // Set up UI components
                addSubview(titleLabel)
                addSubview(switchControl)
                
                // Set up constraints
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                switchControl.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                    titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                    
                    switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                    switchControl.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
    }
