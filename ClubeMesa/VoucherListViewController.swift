//
//  VoucherListViewController.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 04/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import UIKit
import RxSwift

class VoucherListViewController: DrawerViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    fileprivate var vouchers = [VoucherModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        carregar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRefreshTapped(_ sender: UIBarButtonItem) {
        carregar()
    }
    
    private func carregar() {
        let isNetworkAvailable = Reachability.isNetworkAvailable()
        if (isNetworkAvailable) {
            sincronizar()
        } else {
            let message = TextUtils.localized(forKey: "Message.InternetIndisponivel")
            self.handle(Trouble.internetNotAvailable(message))
            self.initSegment()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "Segue.VoucherVisualizacao" {
                let controller = segue.destination as! VoucherVisualizacaoViewController
                let indexPath = tableView.indexPathForSelectedRow!
                let voucher = vouchers[indexPath.row]
                controller.voucher = voucher
            }
        }
    }
    
    private func atualizar(_ vouchers: [VoucherModel]) {
        self.vouchers = vouchers
        self.tableView.reloadData()
    }
    
    private func sincronizar() {
        showActivityIndicator()
        let observable = VoucherService.Async.sincronizar()
        prepare(for: observable)
            .subscribe(
                onNext: { void in
                    self.initSegment()
                },
                onError: { error in
                    self.hideActivityIndicator()
                    self.handle(error)
                },
                onCompleted: {
                    self.hideActivityIndicator()
                }
            ).addDisposableTo(disposableBag)
    }
    
    private func initSegment() {
        if segmentControl.selectedSegmentIndex < 0 {
            segmentControl.selectedSegmentIndex = 0;
        }
        self.onSegmentChanged()
    }
    
    private func listar(_ index: Int) {
        
        var observable: Observable<[VoucherModel]>?
        
        if index == 0 {
            observable = VoucherService.Async.disponiveis()
        } else if index == 1 {
            observable = VoucherService.Async.usados()
        } else if index == 2 {
            observable = VoucherService.Async.expirados()
        }
        
        if (observable != nil) {
            prepare(for: observable!)
                .subscribe(
                    onNext: { models in
                        self.atualizar(models)
                    },
                    onError: { error in
                        self.handle(error)
                    }
                ).addDisposableTo(disposableBag)
        }
        
        
    }
    
    @IBAction func onSegmentChanged() {
        let index = segmentControl.selectedSegmentIndex
        listar(index)
    }
}

extension VoucherListViewController: UITableViewDelegate {
    
}

extension VoucherListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouchers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let voucher = vouchers[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherTableViewCell", for: indexPath) as! VoucherTableViewCell
        cell.populate(voucher)
        return cell
    }
}
