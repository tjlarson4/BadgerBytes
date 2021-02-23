//
//  MenuItemsVC.swift
//  MenuProgrammatically
//
//  Created by Atessa Amjadi on 2/21/21.
//

import UIKit

//source: https://www.youtube.com/watch?v=Pu7B7uEzP18

struct Item {
    var isoCode: String
    var name: String
}


class TableHeader: UITableViewHeaderFooterView {
    static let identifier = "TableHeader"
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Menu"
        headerLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headerLabel.textAlignment = .center
        return headerLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.sizeToFit()
        headerLabel.frame = CGRect(x: 0,
                                   y: contentView.frame.size.height-15-headerLabel.frame.size.height,
                                   width: contentView.frame.size.width,
                                   height: headerLabel.frame.size.height)

    }

}

class TableFooter: UITableViewHeaderFooterView{
    
    
}

class MenuItemsVC: UIViewController {
    
    let Menu = [
        Item(isoCode: "Chips and salsa", name: "Chips and salsa"),
        Item(isoCode: "Chips and guacamole", name: "Chips and guacamole"),
        Item(isoCode: "Chips and queso", name: "Chips and queso"),
        Item(isoCode: "Nachos", name: "Nachos"),
        Item(isoCode: "Mexican street corn", name: "Mexican street corn"),
        Item(isoCode: "Chicken quesadilla", name: "Chicken quesadilla"),
        Item(isoCode: "Chicken tacos", name: "Chicken tacos"),
        Item(isoCode: "Grilled fish tacos", name: "Grilled fish tacos"),
        Item(isoCode: "Chicken fajitas", name: "Chicken fajitas"),
        Item(isoCode: "Steak fajitas", name: "Steak fajitas"),
        Item(isoCode: "Grilled vegetable fajitas", name: "Grilled vegetable fajitas"),
        Item(isoCode: "Steak enchiladas", name: "Steak enchiladas"),
        Item(isoCode: "Vegetable enchiladas", name: "Vegetable enchiladas")
      
    ]

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.register(TableHeader.self, forHeaderFooterViewReuseIdentifier: "Header")
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        //needed for heightForRow
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }


}

extension MenuItemsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        
        let menu = Menu[indexPath.row]
        
        cell.configure(text: menu.name, imageName: menu.isoCode)
        
//        cell.countryTitleLabel?.text = country.name
//        cell.countryTextLabel?.text = country.isoCode
//        cell.countryImageView?.image = UIImage(named: country.isoCode)
        
        
//        cell.configure(text: "Custom + \(indexPath.row+1)", imageName: indexPath.row % 2 == 0 ? "Chicken tacos" : "Chips and salsa")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        return tableHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
}
