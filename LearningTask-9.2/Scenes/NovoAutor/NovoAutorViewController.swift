//
//  NovoAutorViewController.swift
//  LearningTask-9.2
//
//  Created by rafael.rollo on 22/07/2022.
//

import UIKit

protocol NovoAutorViewControllerDelegate: AnyObject {
    func novoAutorViewController(_ controller: NovoAutorViewController, adicionou autor: Autor)
}

class NovoAutorViewController: UIViewController {

    typealias MensagemDeValidacao = String
    
    weak var delegate: NovoAutorViewControllerDelegate?
    
    @IBOutlet weak var fotoTextField: UITextField!
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var tecnologiasTableView: UITableView!
    
    var tecnologias: [String] = [] {
        didSet {
            tecnologiasTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func botaoSalvarPressionado(_ sender: UIButton) {
        switch formularioEhValido() {
            
        case (false, let mensagem):
            exibeAlerta(titulo: "Erro", mensagem: mensagem)
            
        default:
            cadastraAutor()
            self.dismiss(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "verCampoNovaTecnologiaSegue" else { return }
        guard let destination = segue.destination as? NovaTecnologiaViewController else {
            fatalError("Não foi possível executar a segue: \(segue.identifier!)")
        }
        destination.delegate = self
    }
    
    private func nomeDeAutorValido(_ nome: String) -> Bool {
        let pattern = #"^[a-zA-Z-]+ ?.* [a-zA-Z-]+$"#
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: nome)
    }
    
    private func separa(nomeDeAutor: String) -> (String, String) {
        let separador = " "
        let nomeCompleto = nomeDeAutor.components(separatedBy: separador)
        return (nomeCompleto.first!, nomeCompleto.dropFirst().joined(separator: separador))
    }
    
    private func formularioEhValido() -> (Bool, MensagemDeValidacao?) {
        if let fotoUrl = fotoTextField.text, fotoUrl.isEmpty {
            return (false, "Informe a URL da foto do autor")
        }
        
        guard let nome = nomeTextField.text, !nome.isEmpty else {
            return (false, "Nome não pode estar em branco")
        }

        guard nomeDeAutorValido(nome) else {
            return (false, "Informe o nome completo do autor.")
        }
        
        if let bio = bioTextField.text, bio.isEmpty {
            return (false, "A bio do autor não pode estar em branco")
        }
        
        if tecnologias.isEmpty {
            return (false, "Informe ao menos uma tecnologia sobre a qual este autor escreve.")
        }
        
        return (true, nil)
    }
    
    func cadastraAutor() {
        let (nome, sobrenome) = separa(nomeDeAutor: nomeTextField.text!)
        let autor = Autor(foto: fotoTextField.text!, nome: nome, sobrenome: sobrenome, bio: bioTextField.text!, tecnologias: tecnologias)
        delegate?.novoAutorViewController(self, adicionou: autor)
    }

}

extension NovoAutorViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tecnologias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celula = tableView.dequeueReusableCell(withIdentifier: "TecnologiaViewCell", for: indexPath) as? TecnologiaViewCell else {
            fatalError("Não foi possível obter célula para a tecnologia do autor em NovoAutor")
        }
        
        celula.tecnologia = tecnologias[indexPath.row]
        return celula
    }
    
}

extension NovoAutorViewController: NovaTecnologiaViewControllerDelegate {
    func novaTecnologiaViewController(_ controller: NovaTecnologiaViewController, adicionou tecnologia: String) {
        tecnologias.append(tecnologia)
    }
}
