//
//  Club.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 22/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import RealmSwift

class Club: Object {
    
    dynamic var id = 0
    dynamic var nome = ""
    dynamic var estado = ""
    dynamic var cidade = ""
    dynamic var periodo = 0
    
    let estabelecimentos = List<Estabelecimento>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func from(_ model: ClubModel) -> Club {
        guard let id = model.id else {
            fatalError("ClubModel.id is nil.")
        }
        let club = Club()
        club.id = id
        club.nome = model.nome
        club.estado = model.estado
        club.cidade = model.cidade
        club.periodo = model.periodo
        return club
    }
}
