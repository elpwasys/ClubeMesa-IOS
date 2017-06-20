//
//  Voucher.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 22/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import RealmSwift

class Voucher: Object {
    
    dynamic var status = ""
    dynamic var codigo = ""
    dynamic var qrcode = ""
    dynamic var dataEmissao = NSDate()
    dynamic var dataUtilizacao: NSDate? = nil
    dynamic var dataValidadeInicio = NSDate()
    dynamic var dataValidadeTermino = NSDate()
    
    dynamic var estabelecimento: Estabelecimento?
    
    override static func primaryKey() -> String? {
        return "codigo"
    }
    
    static func from(_ model: VoucherModel) -> Voucher {
        let voucher = Voucher()
        voucher.status = model.status.rawValue
        voucher.codigo = model.codigo
        voucher.qrcode = model.qrcode
        voucher.dataEmissao = model.dataEmissao as NSDate
        voucher.dataUtilizacao = model.dataUtilizacao as NSDate?
        voucher.dataValidadeInicio = model.dataValidadeInicio as NSDate
        voucher.dataValidadeTermino = model.dataValidadeTermino as NSDate
        if let estabelecimento = model.estabelecimento {
            voucher.estabelecimento = Estabelecimento.from(estabelecimento)
        }
        return voucher
    }
}
