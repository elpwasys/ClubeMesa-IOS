//
//  VoucherVisualizacaoViewController.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 04/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftMessages

class VoucherVisualizacaoViewController: MenuStoryboardViewController {

    @IBOutlet weak var codigoLabel: UILabel!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var dataValidadeInicioLabel: UILabel!
    @IBOutlet weak var dataValidadeTerminoLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var estabelecimentoLabel: UILabel!
    @IBOutlet weak var mensagemConfirmeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var reservaButton: Button!
    
    var voucher: VoucherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let voucher = self.voucher {
            ViewUtils.text(voucher.codigo, for: codigoLabel)
            ViewUtils.text(voucher.dataValidadeInicio, for: dataValidadeInicioLabel)
            ViewUtils.text(voucher.dataValidadeTermino, for: dataValidadeTerminoLabel)
            ViewUtils.text(voucher.estabelecimento?.nome, for: estabelecimentoLabel)
            ViewUtils.text(voucher.estabelecimento?.enderecoCompleto, for: enderecoLabel)
            if let logo = voucher.estabelecimento?.logo {
                if let url = URL(string: "\(Config.fileURL)/\(logo.caminho!)") {
                    logoImageView.kf.setImage(with: url)
                }
            }
            let path = "\(Config.baseURL)/qrcode?text=\(voucher.qrcode!)&width=150&height=150"
            let characterSet = (CharacterSet(charactersIn: " ").inverted)
            if let escaped = path.addingPercentEncoding(withAllowedCharacters: characterSet) {
                if let url = URL(string: escaped) {
                    qrcodeImageView.kf.setImage(with: url)
                }
            }
            var title: String
            if voucher.status == VoucherModel.Status.usado {
                title = TextUtils.localized(forKey: "Label.Avaliar")
                mensagemConfirmeLabel.isHidden = true
            } else {
                title = TextUtils.localized(forKey: "Label.Reservar")
                mensagemConfirmeLabel.isHidden = false
                if let estabelecimento = voucher.estabelecimento, estabelecimento.reservaObrigatoria {
                    title = TextUtils.localized(forKey: "Label.ReservaObrigatoria")
                }
            }
            reservaButton.setTitle(title, for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onButtomTapped() {
        if let voucher = self.voucher {
            if voucher.status == VoucherModel.Status.usado {
                // CHAMAR AVALIACAO
                let link = Config.link(forKey: "Avaliacao")
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "Scene.Web") as! WebViewController
                controller.link = "\(link)?codigo=\(voucher.codigo!)"
                controller.isLeftMenu = false
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                let estabelecimento = voucher.estabelecimento!
                let reserva = Reserva.create(estabelecimento, view: self.view)
                reserva.show()
            }
        }
    }
}
