//
//  ImagemModel.swift
//  FilhoEscola
//
//  Created by Everton Luiz Pascke on 17/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class ImagemModel: Model {
    
    var caminho: String!
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        caminho <- map["caminho"]
    }
    
    static func from(_ imagem: Imagem) -> ImagemModel {
        let model = ImagemModel()
        model.id = imagem.id
        model.caminho = imagem.caminho
        return model
    }
}
