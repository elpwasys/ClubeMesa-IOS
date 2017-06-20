//
//  CartaoModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 25/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class CartaoModel: Model {
    
    var data: Date!
    var nome: String!
    var numero: String!
    var codigo: String!
    var bandeira: String!
    var expiracaoMes: String!
    var expiracaoAno: String!
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        let dateTransform = DateTransformType()
        data <- (map["data"], dateTransform)
        nome <- map["nome"]
        numero <- map["numero"]
        bandeira <- map["bandeira"]
        expiracaoMes <- map["expiracaoMes"]
        expiracaoAno <- map["expiracaoAno"]
    }
    
    func dictionary() -> [String: Any] {
        var hash:[String: Any] = [
            "nome": nome,
            "numero": numero,
            "codigo": codigo,
            "expiracaoMes": expiracaoMes,
            "expiracaoAno": expiracaoAno
        ]
        if let id = self.id {
            hash["id"] = id
        }
        if let bandeira = self.bandeira {
            hash["bandeira"] = bandeira
        }
        return hash
    }
}
