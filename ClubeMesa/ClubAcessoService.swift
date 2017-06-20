//
//  ClubAcessoService.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 25/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class ClubAcessoService: Service {
    
    static func validar(id: Int, codigo: String) throws -> ClubAcessoModel {
        let url = "\(Config.restURL)/club/acesso/validar/\(id)/\(codigo)"
        let response: DataResponse<ClubAcessoModel> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let value = result.value!
        return value
    }
    
    class Async {
        static func validar(id: Int, codigo: String) -> Observable<ClubAcessoModel> {
            return Observable.create { observer in
                do {
                    let value = try ClubAcessoService.validar(id: id, codigo: codigo)
                    observer.onNext(value)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
}
