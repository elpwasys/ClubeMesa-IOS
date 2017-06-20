//
//  BoasVindasService.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 16/04/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class BoasVindasService: Service {
    
    static func listar() throws -> [BoasVindasModel] {
        let url = "\(Config.restURL)/boasvindas/listar"
        let response: DataResponse<[BoasVindasModel]> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let model = result.value!
        return model
    }
    
    class Async {
    static func listar() -> Observable<[BoasVindasModel]> {
            return Observable.create { observer in
                do {
                    let models = try BoasVindasService.listar()
                    observer.onNext(models)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
}
