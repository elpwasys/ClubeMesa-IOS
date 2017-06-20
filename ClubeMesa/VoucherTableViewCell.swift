//
//  VoucherTableViewCell.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 04/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import UIKit
import Kingfisher

class VoucherTableViewCell: UITableViewCell {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var clubLabel: UILabel!
    @IBOutlet weak var estabelecimentoLabel: UILabel!
    @IBOutlet weak var validadeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func populate(_ voucher: VoucherModel) {
        ViewUtils.text(voucher.estabelecimento?.nome, for: estabelecimentoLabel)
        ViewUtils.text(voucher.estabelecimento?.club?.nome, for: clubLabel)
        if let logo = voucher.estabelecimento?.logo {
            if let url = URL(string: "\(Config.fileURL)/\(logo.caminho!)") {
                logoView.kf.setImage(with: url)
            }
        }
        let dataValidadeInicio = TextUtils.text(voucher.dataValidadeInicio)!
        let dataValidadeTermino = TextUtils.text(voucher.dataValidadeTermino)!
        if voucher.status == VoucherModel.Status.usado {
            if let dataUtilizacao = voucher.dataUtilizacao {
                ViewUtils.text("\(TextUtils.localized(forKey: "Label.UsadoEm")) \(TextUtils.text(dataUtilizacao)!)", for: validadeLabel)
            }
        } else {
            ViewUtils.text("\(dataValidadeInicio) \(TextUtils.localized(forKey: "Label.ate")) \(dataValidadeTermino)", for: validadeLabel)
        }
    }
}
