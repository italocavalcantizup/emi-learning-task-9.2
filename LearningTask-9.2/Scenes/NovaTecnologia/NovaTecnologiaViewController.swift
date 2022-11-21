//
//  NovaTecnologiaViewController.swift
//  LearningTask-9.2
//
//  Created by rafael.rollo on 25/07/2022.
//

import UIKit

protocol NovaTecnologiaViewControllerDelegate: AnyObject {
    func novaTecnologiaViewController(_ controller: NovaTecnologiaViewController, adicionou tecnologia: String)
}

class NovaTecnologiaViewController: UIViewController {
    
    typealias MensagemDeValidacao = String
    
    weak var delegate: NovaTecnologiaViewControllerDelegate?

    @IBOutlet weak var tecnologiaTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func botaoAdicionarPressionado(_ sender: UIButton) {
        switch formularioEhValido() {
            
        case (false, let mensagem):
            exibeAlerta(titulo: "Erro", mensagem: mensagem)
            
        default:
            adicionaTecnologia()
            self.dismiss(animated: true)
        }
    }
    
    func formularioEhValido() -> (Bool, MensagemDeValidacao?) {
        if let tecnologia = tecnologiaTextField.text, tecnologia.isEmpty {
            return (false, "Informe a tecnologia para o autor.")
        }
        
        return (true, nil)
    }
    
    func adicionaTecnologia() {
        delegate?.novaTecnologiaViewController(self, adicionou: tecnologiaTextField.text!)
    }
    
}
