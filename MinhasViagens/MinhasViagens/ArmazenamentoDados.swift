//
//  ArmazenamentoDados.swift
//  MinhasViagens
//
//  Created by Tribanco Dev on 02/08/2018.
//  Copyright © 2018 minhasViagens. All rights reserved.
//

import UIKit

class ArmazenamentoDados {
    
    let chaveArmazenamento = "locaisViagens"
    var viagens: [Dictionary<String, String>] = []
    
    func salvarViagem (viagem: Dictionary<String, String>) {
        
        viagens = listarViagens()
        
        viagens.append(viagem)
        UserDefaults.standard.set(viagens, forKey: chaveArmazenamento)
        UserDefaults.standard.synchronize()
    }
    
    func listarViagens() -> [Dictionary<String, String>]{
        let dados = UserDefaults.standard.object(forKey: chaveArmazenamento)
        if dados != nil {
            return dados as! Array
        } else {
            return []
        }
    }
    
    func removerViagem(indice: Int) {
        viagens = listarViagens()
        viagens.remove(at: indice)
        
        UserDefaults.standard.set(viagens, forKey: chaveArmazenamento)
        UserDefaults.standard.synchronize()
    }
}
