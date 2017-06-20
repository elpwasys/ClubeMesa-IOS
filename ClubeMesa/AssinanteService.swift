//
//  AssinanteService.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 23/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class AssinanteService: Service {
    
    static func obter() throws -> AssinanteModel {
        let url = "\(Config.restURL)/assinante/obter"
        let response: DataResponse<AssinanteModel> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let value = result.value!
        return value
    }
    
    static func salvar(model: AssinanteModel) throws -> AssinanteModel {
        let url = "\(Config.restURL)/assinante/salvar"
        let dictionary = model.dictionary()
        let response: DataResponse<AssinanteModel> = try Network.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let value = result.value!
        return value
    }
    
    class Async {
        static func obter() -> Observable<AssinanteModel> {
            return Observable.create { observer in
                do {
                    let value = try AssinanteService.obter()
                    observer.onNext(value)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        static func salvar(model: AssinanteModel) -> Observable<AssinanteModel> {
            return Observable.create { observer in
                do {
                    let value = try AssinanteService.salvar(model: model)
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
