//
//  ViewController.swift
//  MinhasViagens
//
//  Created by Tribanco Dev on 02/08/2018.
//  Copyright © 2018 minhasViagens. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocal = CLLocationManager()
    var viagem: Dictionary<String, String> = [:]
    var indiceSelecionado: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        if let indice = indiceSelecionado {
            if indice == -1 {
                for i in 0..<ArmazenamentoDados().listarViagens().count {
                    exibirAnotacao(viagem: ArmazenamentoDados().listarViagens()[i])
                }
                
                gerenciadorLocal.delegate = self
                gerenciadorLocal.desiredAccuracy = kCLLocationAccuracyBest
                gerenciadorLocal.requestWhenInUseAuthorization()
                gerenciadorLocal.startUpdatingLocation()
            } else {
                exibirAnotacao( viagem: viagem)
            }
        }
        
        //Reconhecedor de gestos
        let reconhecedorDeGesto = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:)))
        reconhecedorDeGesto.minimumPressDuration = 2
        
        mapa.addGestureRecognizer(reconhecedorDeGesto)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let local = locations.last!
        
        let localizacao = CLLocationCoordinate2DMake(local.coordinate.latitude, local.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.01 , 0.01)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, span)
        self.mapa.setRegion(regiao, animated: true)
    }
    
    func exibirLocal (latitude: Double, longitude: Double) {
        //exibe local
        let localizacao = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(0.01 , 0.01)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegionMake(localizacao, span)
        self.mapa.setRegion(regiao, animated: true)
    }
    
    func exibirAnotacao(viagem: Dictionary<String, String>) {
        //Exibe anotacao com os dados de endereco
        if let localViagem = viagem["local"] {
            if let latitudeS = viagem["latitude"] {
                if let longitudeS = viagem["longitude"] {
                    if let latitude = Double(latitudeS) {
                        if let longitude = Double(longitudeS) {
                            //Adiciona anotacao
                            let anotacao = MKPointAnnotation()
                            
                            anotacao.coordinate.latitude = latitude
                            anotacao.coordinate.longitude = longitude
                            anotacao.title = localViagem
                            
                            self.mapa.addAnnotation(anotacao)
                            
                            self.exibirLocal(latitude: latitude, longitude: longitude)
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    @objc func marcar(gesture: UIGestureRecognizer) {
        //Confere se o estado de pressionado comecou, e nao deixa repetir
        if gesture.state == UIGestureRecognizerState.began {
            
            //Recupera as coordenadas do ponto selecionado
            let pontoSelecionado = gesture.location(in: self.mapa)
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            //Recupera o endereco do ponto selecionado
            var localCompleto = "Endereco nao encontrado"
            CLGeocoder().reverseGeocodeLocation(localizacao) { (local, erro) in
                if erro == nil {
                    
                    if let dadosLocal = local?.first {
                        
                        if let nome = dadosLocal.name {
                            localCompleto = nome
                        } else {
                            if let endereco = dadosLocal.thoroughfare {
                                localCompleto = endereco
                            }
                        }
                    }
                    
                    //Salvar dados no dispositivo
                    self.viagem = ["local": localCompleto, "latitude": String(coordenadas.latitude), "longitude": String(coordenadas.longitude)]
                    ArmazenamentoDados().salvarViagem(viagem: self.viagem)
                    
                    //Exibe anotacao com os dados de endereco
                    self.exibirAnotacao(viagem: self.viagem)
                    
                } else {
                    print (erro)
                }
            }
            
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
