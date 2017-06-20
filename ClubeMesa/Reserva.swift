//
//  Reserva.swift
//  ClubMesa
//
//  Created by Everton Luiz Pascke on 04/06/17.
//  Copyright © 2017 Wasys Technology. All rights reserved.
//

import UIKit

class Reserva: View {

    @IBOutlet weak var siteText: UITextView!
    @IBOutlet weak var emailText: UITextView!
    @IBOutlet weak var whatsAppText: UITextView!
    @IBOutlet weak var telefoneText: UITextView!
    @IBOutlet weak var estabelecimentoLabel: UILabel!
    
    fileprivate var view: UIView!
    fileprivate var overlay: UIView!
    
    static func create(_ estabelecimento: EstabelecimentoModel, view: UIView) -> Reserva {
        
        let reserva = Bundle.main.loadNibNamed("Reserva", owner: view, options: nil)?.first as! Reserva
        
        ViewUtils.text(estabelecimento.nome, for: reserva.estabelecimentoLabel)
        
        var site = estabelecimento.site
        if let reservaSite = estabelecimento.reservaSite {
            site = reservaSite
        }
        
        ViewUtils.text(site, for: reserva.siteText)
        
        var email = estabelecimento.email
        if let reservaEmail = estabelecimento.reservaEmail {
            email = reservaEmail
        }
        
        ViewUtils.text(email, for: reserva.emailText)
        
        if let whatsapp = estabelecimento.telefone(by: .whatsapp) {
            ViewUtils.text("(\(whatsapp.prefixo!)) \(whatsapp.numero!)", for: reserva.whatsAppText)
        }
        
        if let comercial = estabelecimento.telefone(by: .comercial) {
            ViewUtils.text("(\(comercial.prefixo!)) \(comercial.numero!)", for: reserva.telefoneText)
        }
        
        reserva.frame.size = CGSize(width: view.frame.width - CGFloat(16), height: reserva.frame.height)
        reserva.view = view
        reserva.cornerRadius = 4
        
        let layer = reserva.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.4
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        
        return reserva
    }
    
    func show() {
        if overlay == nil {
            // Overlay
            overlay = UIView(frame: view.frame)
            overlay.center = view.center
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
            overlay.addGestureRecognizer(gestureRecognizer)
            
            center = overlay.center
            //
            view.addSubview(overlay)
            
            self.alpha = 0
            view.addSubview(self)
            
            let timing = UICubicTimingParameters(animationCurve: .easeIn)
            let animator = UIViewPropertyAnimator(duration: 0.25, timingParameters: timing)
            animator.addAnimations {
                self.alpha = 1
            }
            animator.startAnimation()
        }
    }
    
    func hide() {
        if overlay != nil {
            overlay.removeFromSuperview()
            overlay = nil
            self.removeFromSuperview()
        }
    }
}
