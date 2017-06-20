//
//  MenuViewController.swift
//  ClubeMesa
//
//  Created by Everton Luiz Pascke on 10/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import UIKit
import Kingfisher

class Menu {
    var id: Int
    var icon: UIImage
    var label: String
    init(id: Int, icon: UIImage, label: String) {
        self.id = id
        self.icon = icon
        self.label = label
    }
}

class MenuViewController: ClubMesaViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate var menus = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.createMenu()
        if let dispositivo = Dispositivo.current {
            self.update(dispositivo)
        }
        let center = NotificationCenter.default
        center.addObserver(forName: Dispositivo.updateNotificationName, object: nil, queue: nil) { notification in
            if let dispositivo = notification.object as? Dispositivo {
                self.update(dispositivo)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createMenu() {
        menus.append(Menu(id: 1, icon: UIImage(named: "Search-White")!, label: TextUtils.localized(forKey: "Menu.Pesquisar")))
        menus.append(Menu(id: 2, icon: UIImage(named: "Food-White")!, label: TextUtils.localized(forKey: "Menu.Assinaturas")))
        menus.append(Menu(id: 3, icon: UIImage(named: "TagMultiple-White")!, label: TextUtils.localized(forKey: "Menu.MeusVouchers")))
        menus.append(Menu(id: 4, icon: UIImage(named: "Email-White")!, label: TextUtils.localized(forKey: "Menu.Mensagens")))
        menus.append(Menu(id: 5, icon: UIImage(named: "Settings-White")!, label: TextUtils.localized(forKey: "Menu.Configuracao")))
        menus.append(Menu(id: 6, icon: UIImage(named: "Database-White")!, label: TextUtils.localized(forKey: "Menu.Cache")))
    }
    
    private func update(_ dispositivo: Dispositivo) {
        ViewUtils.text(dispositivo.nome, for: nomeLabel)
        if dispositivo.imagemURI != nil {
            if let url = URL(string: "\(Config.fileURL)/\(dispositivo.imagemURI!)") {
                imageView.kf.setImage(with: url)
            }
        }
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var link: String!
        let menu = menus[indexPath.row]
        if menu.id == 1 {
            link = Config.link(forKey: "ClubConsulta")
        } else if menu.id == 2 {
            link = Config.link(forKey: "ClubAssinatura")
        } else if menu.id == 3 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "Scene.VoucherLista")
            self.navigationController?.pushViewController(controller!, animated: true)
        } else if menu.id == 4 {
            link = Config.link(forKey: "Mensagem")
        } else if menu.id == 5 {
            link = Config.link(forKey: "Configuracao")
        } else if menu.id == 6 {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "Scene.Cache")
            self.navigationController?.pushViewController(controller!, animated: true)
        }
        if link != nil {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "Scene.Web") as! WebViewController
            controller.link = link!
            self.navigationController?.pushViewController(controller, animated: true)
        }
        print("ViewControllers: \(self.navigationController?.viewControllers.count ?? 0)")
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        let menu = menus[indexPath.row]
        cell.populate(menu)
        return cell
    }
}
