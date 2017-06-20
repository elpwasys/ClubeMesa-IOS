//
//  ClubAcessoModel.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 25/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation
import ObjectMapper

class ClubAcessoModel: Model {
    
    var codigo: String!
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        codigo <- map["codigo"]
    }
}
