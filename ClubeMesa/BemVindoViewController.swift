//
//  BemVindoViewController.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 16/04/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import UIKit

class BemVindoViewController: ClubMesaViewController {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate var mensagens = [String]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        carregar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func carregar() {
        showActivityIndicator()
        let observable = BoasVindasService.Async.listar()
        prepare(for: observable)
            .subscribe(
                onNext: { models in
                    self.carregar(models: models)
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
    
    private func carregar(models: [BoasVindasModel]) {
        var slides = [Slide]()
        let height = centerView.frame.height;
        for model in models {
            if let mensagem = model.mensagem {
                slides.append(Slide.create(mensagem, height: height, owner: self))
            }
        }
        configurar(slides: slides)
    }
    
    private func configurar(slides: [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: centerView.frame.width, height: centerView.frame.height)
        scrollView.contentSize = CGSize(width: (centerView.frame.width * CGFloat(slides.count)), height: centerView.frame.height)
        scrollView.isPagingEnabled = true
        for (i, slide) in slides.enumerated() {
            slide.frame = CGRect(x: centerView.frame.width * CGFloat(i), y: 0, width: centerView.frame.width, height: centerView.frame.height)
            scrollView.addSubview(slide)
        }
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
    }
}

extension BemVindoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x / centerView.frame.width)
        pageControl.currentPage = Int(index)
    }
}
