//
//  Telefone.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 04/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import RealmSwift

class Telefone: Object {
    
    dynamic var id = 0
    dynamic var tipo = ""
    dynamic var numero = ""
    dynamic var prefixo = ""
    
    dynamic var estabelecimento: Estabelecimento?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func from(_ model: TelefoneModel) -> Telefone {
        guard let id = model.id else {
            fatalError("TelefoneModel.id is nil.")
        }
        let telefone = Telefone()
        telefone.id = id
        telefone.tipo = model.tipo.rawValue
        telefone.numero = model.numero
        telefone.prefixo = model.prefixo
        return telefone
    }
}
