//
//  VoucherModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 22/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class VoucherModel: Model {
    
    var status: Status!
    var codigo: String!
    var qrcode: String!
    var dataEmissao: Date!
    var dataUtilizacao: Date?
    var dataValidadeInicio: Date!
    var dataValidadeTermino: Date!
    
    var estabelecimento: EstabelecimentoModel?
    
    enum Segmento {
        case historico
        case disponivel
    }
    
    enum Status: String {
        case usado = "USADO"
        case emitido = "EMITIDO"
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        codigo <- map["codigo"]
        qrcode <- map["qrcode"]
        let dateTransform = DateTransformType()
        dataEmissao <- (map["dataEmissao"], dateTransform)
        dataUtilizacao <- (map["dataUtilizacao"], dateTransform)
        dataValidadeInicio <- (map["dataValidadeInicio"], dateTransform)
        dataValidadeTermino <- (map["dataValidadeTermino"], dateTransform)
        estabelecimento <- map["estabelecimento"]
    }
    
    static func from(_ voucher: Voucher) -> VoucherModel {
        let model = VoucherModel()
        model.status = Status.init(rawValue: voucher.status)
        model.codigo = voucher.codigo
        model.qrcode = voucher.qrcode
        model.dataEmissao = voucher.dataEmissao as Date
        model.dataValidadeInicio = voucher.dataValidadeInicio as Date
        model.dataValidadeTermino = voucher.dataValidadeTermino as Date
        if let dataUtilizacao = voucher.dataUtilizacao {
            model.dataUtilizacao = dataUtilizacao as Date
        }
        if let estabelecimento = voucher.estabelecimento {
            model.estabelecimento = EstabelecimentoModel.from(estabelecimento)
        }
        return model
    }
}
