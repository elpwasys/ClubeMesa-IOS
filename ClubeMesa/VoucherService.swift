//
//  VoucherService.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 04/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import Foundation

import RxSwift
import Alamofire
import RealmSwift

class VoucherService: Service {
    
    static func buscar(codigo: String) throws -> VoucherModel {
        let url = "\(Config.restURL)/voucher/buscar/\(codigo)"
        let response: DataResponse<VoucherModel> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let value = result.value!
        let voucher = Voucher.from(value)
        let realm = try Realm()
        try realm.write {
            realm.add(voucher, update: true)
        }
        let model = VoucherModel.from(voucher)
        return model
    }
    
    static func sincronizar() throws {
        let url = "\(Config.restURL)/voucher/listar"
        let response: DataResponse<[VoucherModel]> = try Network.request(url, method: .get, encoding: JSONEncoding.default, headers: Device.headers).parse()
        let result = response.result
        if result.isFailure {
            throw result.error!
        }
        let values = result.value!
        let realm = try Realm()
        try realm.write {
            for value in values {
                let voucher = Voucher.from(value)
                realm.add(voucher, update: true)
            }
        }
    }
    
    static func usados() throws -> [VoucherModel] {
        let realm = try Realm()
        var models = [VoucherModel]()
        let vouchers = realm.objects(Voucher.self).filter(NSPredicate(format: "status == %@", VoucherModel.Status.usado.rawValue))
        for voucher in vouchers {
            let model = VoucherModel.from(voucher)
            models.append(model)
        }
        return models;
    }
    
    static func disponiveis() throws -> [VoucherModel] {
        let hoje = Date()
        let realm = try Realm()
        var models = [VoucherModel]()
        let vouchers = realm.objects(Voucher.self).filter(NSPredicate(format: "status == %@", VoucherModel.Status.emitido.rawValue)).filter(NSPredicate(format: "dataValidadeTermino >= %@", hoje as NSDate))
        for voucher in vouchers {
            let model = VoucherModel.from(voucher)
            models.append(model)
        }
        return models;
    }
    
    static func expirados() throws -> [VoucherModel] {
        let hoje = Date()
        let realm = try Realm()
        var models = [VoucherModel]()
        let vouchers = realm.objects(Voucher.self).filter(NSPredicate(format: "status == %@", VoucherModel.Status.emitido.rawValue)).filter(NSPredicate(format: "dataValidadeTermino < %@", hoje as NSDate))
        for voucher in vouchers {
            let model = VoucherModel.from(voucher)
            models.append(model)
        }
        return models;
    }
    
    class Async {
        static func buscar(codigo: String) -> Observable<VoucherModel> {
            return Observable.create { observer in
                do {
                    let model = try VoucherService.buscar(codigo: codigo)
                    observer.onNext(model)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        static func disponiveis() -> Observable<[VoucherModel]> {
            return Observable.create { observer in
                do {
                    let models = try VoucherService.disponiveis()
                    observer.onNext(models)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        static func usados() -> Observable<[VoucherModel]> {
            return Observable.create { observer in
                do {
                    let models = try VoucherService.usados()
                    observer.onNext(models)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        static func expirados() -> Observable<[VoucherModel]> {
            return Observable.create { observer in
                do {
                    let models = try VoucherService.expirados()
                    observer.onNext(models)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
        static func sincronizar() -> Observable<Void> {
            return Observable.create { observer in
                do {
                    try VoucherService.sincronizar()
                    observer.onNext(Void())
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
                return Disposables.create()
            }
        }
    }
}
