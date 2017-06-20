//
//  CustoModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 23/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class CustoModel: Model {
    
    var status: Status!
    var valorTotal: Double?
    var valorParcelas: Double?
    var qtdeParcelas: Int?
    var dataValidadeInicio: Date?
    var dataValidadeTermino: Date?
    
    enum Status: String {
        case valido = "VALIDO"
        case expirado = "EXPIRADO"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        let dateTransform = DateTransformType()
        status <- map["status"]
        valorTotal <- map["valorTotal"]
        valorParcelas <- map["valorParcelas"]
        qtdeParcelas <- map["qtdeParcelas"]
        dataValidadeInicio <- (map["dataValidadeInicio"], dateTransform)
        dataValidadeTermino <- (map["dataValidadeTermino"], dateTransform)
    }
}
