//
//  AssinaturaService.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 23/05/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire

class AssinaturaService: Service {
    
    static func obter(_ id: Int) throws -> AssinaturaModel {
        let url = "\(Config.restURL)/assinatura/obter/\(id)"
        let response: DataResponse<AssinaturaModel> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let value = result.value!
        return value
    }
    
    static func assinar(_ model: AssinaturaModel) throws -> ResultModel {
        let url = "\(Config.restURL)/assinatura/assinar/"
        let dictionary = model.dictionary()
        let response: DataResponse<ResultModel> = try Network.request(url, method: .post, parameters: dictionary, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let value = result.value!
        return value
    }
    
    class Async {
        static func obter(_ id: Int) -> Observable<AssinaturaModel> {
            return Observable.create { observer in
                do {
                    let value = try AssinaturaService.obter(id)
                    observer.onNext(value)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        static func assinar(_ model: AssinaturaModel) -> Observable<ResultModel> {
            return Observable.create { observer in
                do {
                    let value = try AssinaturaService.assinar(model)
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
