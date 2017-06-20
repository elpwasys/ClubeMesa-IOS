//
//  AssinanteModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 23/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class AssinanteModel: Model {
    
    var cpf: String!
    var nome: String!
    var email: String!
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cpf <- map["cpf"]
        nome <- map["nome"]
        email <- map["email"]
    }
    
    func dictionary() -> [String: Any] {
        var hash:[String: Any] = [
            "cpf": cpf,
            "nome": nome,
            "email": email
        ]
        if let id = self.id {
            hash["id"] = id
        }
        return hash
    }
}
