//
//  AutoresListViewController.swift
//  LearningTask-9.2
//
//  Created by rafael.rollo on 22/07/2022.
//

import UIKit

class AutoresListViewController: UITableViewController {
    
    private enum Segues: String {
        case verFormNovoAutorSegue = "verFormNovoAutorSegue"
        case verDetalhesDoAutorSegue = "verDetalhesDoAutorSegue"
    }

    var autorAPI: AutoresAPI?
    var livrosAPI: LivrosAPI?
    
    var autores: [Autor] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
        // Do any additional setup after loading the view.
    
        setupViews()
        carregaAutores()
    }

    private func setupViews() {
        tableView.register(TableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: TableSectionHeaderView.reuseId)
        tableView.sectionHeaderHeight = TableSectionHeaderView.alturaBase
        tableView.sectionHeaderTopPadding = 0
    }
    
    private func carregaAutores() {
        guard let autorAPI = autorAPI else { return }
        self.autores = autorAPI.listaTodos()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier,
              let segueEsperada = AutoresListViewController.Segues(rawValue: segueId) else { return }
        
        switch segueEsperada {
        case .verDetalhesDoAutorSegue:
            prepareVerDetalhesDoAutor(for: segue, sender: sender)
        default:
            prepareFormNovoAutor(for: segue, sender: sender)
        }
        
        func prepareVerDetalhesDoAutor(for segue: UIStoryboardSegue, sender: Any?) {
            guard let celula = sender as? AutorTableViewCell,
                  let autorViewController = segue.destination as? AutorViewController else {
                fatalError("Não foi possível executar segue \(segue.identifier!)")
            }
            autorViewController.livrosAPI = livrosAPI
            autorViewController.autor = celula.autor
        }
        
        func prepareFormNovoAutor(for segue: UIStoryboardSegue, sender: Any?) {
            guard let destination = segue.destination as? NovoAutorViewController else {
                fatalError("Não foi possível executar a segue: \(segue.identifier!)")
            }
            destination.delegate = self
        }
    
        
    }
    
}

// MARK: - UITableViewDataSource Implementations
extension AutoresListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AutorTableViewCell", for: indexPath) as? AutorTableViewCell else {
            fatalError("Não foi possível obter celula para a lista de autores")
        }
        
        let autor = autores[indexPath.row]
        cell.autor = autor
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate Implementations
extension AutoresListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableSectionHeaderView.reuseId) as? TableSectionHeaderView else {
            fatalError("Não foi possível obter view de header para a lista de autores.")
        }
        
        headerView.titulo = "Todos os Autores"
        return headerView
    }
    
}

extension AutoresListViewController: NovoAutorViewControllerDelegate {
    func novoAutorViewController(_ controller: NovoAutorViewController, adicionou autor: Autor) {
        autores.append(autor)
    }
}
