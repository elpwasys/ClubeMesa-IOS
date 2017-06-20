//
//  BoasVindasModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 16/04/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import Foundation
import ObjectMapper

class BoasVindasModel: Model {
    
    var ordem: Int?
    var mensagem: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        ordem <- map["ordem"]
        mensagem <- map["mensagem"]
    }
}
