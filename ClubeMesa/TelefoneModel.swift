//
//  TelefoneModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 04/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class TelefoneModel: Model {
    
    var tipo: Tipo!
    var numero: String!
    var prefixo: String!
    
    enum Tipo: String {
        case celular = "CELULAR"
        case whatsapp = "WHATSAPP"
        case comercial = "COMERCIAL"
        case residencial = "RESIDENCIAL"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        tipo <- map["tipo"]
        numero <- map["numero"]
        prefixo <- map["prefixo"]
    }
    
    static func from(_ telefone: Telefone) -> TelefoneModel {
        let model = TelefoneModel()
        model.id = telefone.id
        model.tipo = Tipo.init(rawValue: telefone.tipo)
        model.numero = telefone.numero
        model.prefixo = telefone.prefixo
        return model
    }
    
    static func from(_ telefones: List<Telefone>) -> [TelefoneModel] {
        var models = [TelefoneModel]()
        for telefone in telefones {
            let model = from(telefone)
            models.append(model)
        }
        return models
    }
}
