//
//  SideMenuViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/7/21.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var footerLabel: UILabel!
    @IBOutlet weak var labelLogin: UILabel!
    
    var delegate: SideMenuViewControllerDelegate?

    var defaultHighlightedCell: Int = 0

    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: "Общая информация"),
        SideMenuModel(icon: UIImage(systemName: "timer")!, title: "История оплат"),
        SideMenuModel(icon: UIImage(systemName: "keyboard")!, title: "Передача показаний"),
        SideMenuModel(icon: UIImage(systemName: "creditcard")!, title: "Оплата"),
        SideMenuModel(icon: UIImage(systemName: "applescript")!, title: "Поддержка"),
        SideMenuModel(icon: UIImage(systemName: "headphones")!, title: "Контакты"),
        SideMenuModel(icon: UIImage(systemName: "person.fill.questionmark.ar")!, title: "Обращение"),
        SideMenuModel(icon: UIImage(systemName: "backward.end")!, title: "Выход")

    ]

    
    func setLogin()->Void{
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.login) {
            labelLogin.text =  "Логин:" + " " +  stringOne// Some String Value
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.sideMenuTableView.separatorStyle = .none
        labelLogin.minimumScaleFactor = 0.2
      
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }

        // Footer
        self.footerLabel.textColor = UIColor.white
        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.footerLabel.text = "Developed by John Codeos"
        

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
        setLogin()
    }
    
}

// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title

        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
