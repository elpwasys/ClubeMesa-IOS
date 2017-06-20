//
//  ClubModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 22/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class ClubModel: Model {
    
    var nome: String!
    var estado: String!
    var cidade: String!
    
    var valorTotal: Double!
    
    var periodo: Int!
    var inicioMes: Int!
    var inicioAno: Int!
    var maximoAssinaturas: Int!
    var maximoEstabelecimentos: Int!
    
    var custo: CustoModel?
    var imagens: [ImagemModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        nome <- map["nome"]
        estado <- map["estado"]
        cidade <- map["cidade"]
        valorTotal <- map["valorTotal"]
        periodo <- map["periodo"]
        inicioMes <- map["inicioMes"]
        inicioAno <- map["inicioAno"]
        maximoAssinaturas <- map["maximoAssinaturas"]
        maximoEstabelecimentos <- map["maximoEstabelecimentos"]
        custo <- map["custo"]
        imagens <- map["imagens"]
    }
    
    static func from(_ club: Club) -> ClubModel {
        let model = ClubModel()
        model.id = club.id
        model.nome = club.nome
        model.estado = club.estado
        model.cidade = club.cidade
        model.periodo = club.periodo
        return model
    }
    
    func dictionary() -> [String: Any] {
        var hash:[String: Any] = [
            "nome": nome
        ]
        if let id = self.id {
            hash["id"] = id
        }
        return hash
    }
}
