//
//  Estabelecimento.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 22/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import RealmSwift

class Estabelecimento: Object {
    
    dynamic var id = 0
    dynamic var nome = ""
    dynamic var site: String? = nil
    dynamic var email = ""
    dynamic var estado = ""
    dynamic var cidade = ""
    dynamic var bairro = ""
    dynamic var numero = ""
    dynamic var logradouro = ""
    dynamic var complemento: String? = nil
    dynamic var enderecoCompleto = ""
    dynamic var reservaSite: String? = nil
    dynamic var reservaEmail: String? = nil
    dynamic var reservaObrigatoria = true
    
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    
    dynamic var club: Club?
    dynamic var imagem: Imagem?
    
    let telefones = List<Telefone>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func from(_ model: EstabelecimentoModel) -> Estabelecimento {
        guard let id = model.id else {
            fatalError("EstabelecimentoModel.id is nil.")
        }
        let estabelecimento = Estabelecimento()
        estabelecimento.id = id
        estabelecimento.nome = model.nome
        estabelecimento.site = model.site
        estabelecimento.email = model.email
        estabelecimento.estado = model.estado
        estabelecimento.cidade = model.cidade
        estabelecimento.bairro = model.bairro
        estabelecimento.numero = model.numero
        estabelecimento.logradouro = model.logradouro
        estabelecimento.complemento = model.complemento
        estabelecimento.enderecoCompleto = model.enderecoCompleto
        estabelecimento.reservaSite = model.reservaSite
        estabelecimento.reservaEmail = model.reservaEmail
        estabelecimento.reservaObrigatoria = model.reservaObrigatoria
        estabelecimento.latitude = model.latitude
        estabelecimento.longitude = model.longitude
        if let club = model.club {
            estabelecimento.club = Club.from(club)
        }
        if let imagem = model.logo {
            estabelecimento.imagem = Imagem.from(imagem)
        }
        if let telefones = model.telefones {
            for telefone in telefones {
                let entity = Telefone.from(telefone)
                entity.estabelecimento = estabelecimento
                estabelecimento.telefones.append(entity)
            }
        }
        return estabelecimento
    }
}
