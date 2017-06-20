//
//  AssinaturaModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 23/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class AssinaturaModel: Model {
    
    var codigo: String!
    var valor: Double!
    var parcelas: Int!
    var dataValidadeInicio: Date!
    var dataValidadeTermino: Date!
    
    var club: ClubModel!
    var cartao: CartaoModel!
    var assinante: AssinanteModel!
    
    var isNova: Bool {
        return self.id == nil
    }
    
    enum Status: String {
        case valido = "VALIDO"
        case expirado = "EXPIRADO"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        let dateTransform = DateTransformType()
        codigo <- map["codigo"]
        valor <- map["valor"]
        parcelas <- map["parcelas"]
        dataValidadeInicio <- (map["dataValidadeInicio"], dateTransform)
        dataValidadeTermino <- (map["dataValidadeTermino"], dateTransform)
        club <- map["club"]
        cartao <- map["cartao"]
        assinante <- map["assinante"]
    }
    
    func dictionary() -> [String: Any] {
        var hash:[String: Any] = [
            "codigo": codigo
        ]
        if let id = self.id {
            hash["id"] = id
        }
        if club != nil {
            hash["club"] = club.dictionary()
        }
        if cartao != nil {
            hash["cartao"] = cartao.dictionary()
        }
        if assinante != nil {
            hash["assinante"] = assinante.dictionary()
        }
        return hash
    }
}
