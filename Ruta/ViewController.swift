//
//  ViewController.swift
//  Ruta
//
//  Created by Carlos Brito on 24/01/16.
//  Copyright © 2016 Carlos Brito. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapRoute: MKMapView!
    
    private var origen: MKMapItem!
    private var destiny: MKMapItem!
    private var unoMas: MKMapItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapRoute.delegate = self
        
        //
        
        var puntoCoor = CLLocationCoordinate2D(latitude: 19.359727, longitude: -99.257700)
        var puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        
        origen = MKMapItem(placemark: puntoLugar)
        origen.name = "Tecnológico de Monterrey"
        
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.362896, longitude: -99.268856)
        puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        
        destiny = MKMapItem(placemark: puntoLugar)
        destiny.name = "Centro Comercial"
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.358543, longitude: -99.276304)
        puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        unoMas = MKMapItem(placemark: puntoLugar)
        unoMas.name = "Glorieta"
        
        
        self.anotaPunto(origen!)
        self.anotaPunto(destiny!)
        self.anotaPunto(unoMas!)
        
        self.obtenerRuta(self.origen!, destino: self.destiny!)
        self.obtenerRuta(self.destiny!, destino: self.unoMas!)
    }
    
    func anotaPunto(punto: MKMapItem) {
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        mapRoute.addAnnotation(anota)
    }
    
    func obtenerRuta(origen: MKMapItem, destino: MKMapItem){
        
        let solicitud = MKDirectionsRequest()
        
        solicitud.source = origen
        solicitud.destination = destino
        
        //solicitud.transportType = .Walking
        
        solicitud.transportType = .Automobile
        
        let indicaciones = MKDirections(request: solicitud)
        
        indicaciones.calculateDirectionsWithCompletionHandler({
            (respuesta: MKDirectionsResponse?, error: NSError?) in
            if error != nil {
                print ("Error al obtener la ruta")
            }
            else {
                    self.muestraRuta(respuesta!)
                }
            
        })
        
        
    }

    func muestraRuta(respuesta: MKDirectionsResponse){
        for ruta in respuesta.routes {
            mapRoute.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
            
            for paso in ruta.steps {
                print (paso.instructions)
            }
        }
        let centro = origen.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        mapRoute.setRegion(region, animated: true)
        
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 2.0
        return renderer
        
    }

}

