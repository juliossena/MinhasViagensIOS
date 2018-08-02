//
//  TableViewController.swift
//  MinhasViagens
//
//  Created by Tribanco Dev on 02/08/2018.
//  Copyright © 2018 minhasViagens. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var locaisViagens: [Dictionary <String, String>] = []
    var controleNavegacao: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controleNavegacao = 0
        atualizarTabela()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locaisViagens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = locaisViagens[indexPath.row]["local"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            ArmazenamentoDados().removerViagem(indice: indexPath.row)
            atualizarTabela()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controleNavegacao = 1
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verLocal" {
            let vc = segue.destination as! ViewController
            
            if self.controleNavegacao == 1 {
                if let indiceRecuperado = sender {
                    let indice = indiceRecuperado as! Int
                    vc.viagem = locaisViagens[indice]
                    vc.indiceSelecionado = indice
                    
                }
            } else {
                vc.viagem = [:]
                vc.indiceSelecionado = -1
            }
        }
    }
    
    func atualizarTabela() {
        locaisViagens = ArmazenamentoDados().listarViagens()
        tableView.reloadData()
    }


}
