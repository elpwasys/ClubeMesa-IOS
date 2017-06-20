//
//  EstabelecimentoModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 22/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class EstabelecimentoModel: Model {
    
    var nome: String!
    var site: String?
    var email: String!
    var cep: String!
    var estado: String!
    var cidade: String!
    var bairro: String!
    var numero: String!
    var logradouro: String!
    var complemento: String?
    var enderecoCompleto: String!
    var reservaSite: String?
    var reservaEmail: String?
    var reservaObrigatoria: Bool!
    
    var latitude: Double!
    var longitude: Double!
    
    var club: ClubModel?
    var logo: ImagemModel?
    var telefones: [TelefoneModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
        site <- map["site"]
        email <- map["email"]
        cep <- map["cep"]
        estado <- map["estado"]
        cidade <- map["cidade"]
        bairro <- map["bairro"]
        numero <- map["numero"]
        logradouro <- map["logradouro"]
        complemento <- map["complemento"]
        enderecoCompleto <- map["enderecoCompleto"]
        reservaSite <- map["reservaSite"]
        reservaEmail <- map["reservaEmail"]
        reservaObrigatoria <- map["reservaObrigatoria"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        club <- map["club"]
        logo <- map["logo"]
        telefones <- map["telefones"]
    }
    
    static func from(_ estabelecimento: Estabelecimento) -> EstabelecimentoModel {
        let model = EstabelecimentoModel()
        model.id = estabelecimento.id
        model.nome = estabelecimento.nome
        model.site = estabelecimento.site
        model.email = estabelecimento.email
        model.estado = estabelecimento.estado
        model.cidade = estabelecimento.cidade
        model.bairro = estabelecimento.bairro
        model.numero = estabelecimento.numero
        model.logradouro = estabelecimento.logradouro
        model.complemento = estabelecimento.complemento
        model.enderecoCompleto = estabelecimento.enderecoCompleto
        model.reservaSite = estabelecimento.reservaSite
        model.reservaEmail = estabelecimento.reservaEmail
        model.reservaObrigatoria = estabelecimento.reservaObrigatoria
        model.latitude = estabelecimento.latitude
        model.longitude = estabelecimento.longitude
        if let club = estabelecimento.club {
            model.club = ClubModel.from(club)
        }
        if let imagem = estabelecimento.imagem {
            model.logo = ImagemModel.from(imagem)
        }
        if !estabelecimento.telefones.isEmpty {
            model.telefones = TelefoneModel.from(estabelecimento.telefones)
        }
        return model
    }
    
    func telefone(by tipo: TelefoneModel.Tipo) -> TelefoneModel? {
        if let telefones = self.telefones {
            for telefone in telefones {
                if tipo == telefone.tipo {
                    return telefone
                }
            }
        }
        return nil
    }
}
