import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  
  MapboxMapController mapController;

  final center = LatLng(51.503210, -0.118317);

  final dark = 'mapbox://styles/richardeascanio/ckd7glysf00bk1ilsxptqw97c';
  final streets = 'mapbox://styles/richardeascanio/ckd7gohzs00dz1ipfsrz3bqdj';

  String selectedStyle = 'mapbox://styles/richardeascanio/ckd7gohzs00dz1ipfsrz3bqdj';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    // _onStyleLoaded();
  }
    
  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  // Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  // Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }
    
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // Simbolos
        FloatingActionButton(
          child: Icon(Icons.sentiment_very_satisfied),
          onPressed: () {
            mapController.addSymbol(SymbolOptions(
              geometry: center,
              textField: 'London eye',
              iconImage: 'assetImage',
              iconSize: 0.5,
              textOffset: Offset(0, 1.5)
            ));
          }
        ),
        SizedBox(height: 5.0,),
        // Zoom in
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          }
        ),
        SizedBox(height: 5.0,),
        // Zoom out
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          }
        ),
        SizedBox(height: 5.0,),
        // Cambiar estilo
        FloatingActionButton(
          child: Icon(Icons.add_to_home_screen),
          onPressed: () {
            if (selectedStyle == dark) {
              selectedStyle = streets;
            } else {
              selectedStyle = dark;
            }
            _onStyleLoaded();
            setState(() { });
          }
        ),
      ],
    );
  }

  MapboxMap _crearMapa() {
    return MapboxMap(
      styleString: selectedStyle,
      onStyleLoadedCallback: _onStyleLoaded,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 16
      ),
      onMapCreated: _onMapCreated,
    );
  }
    
      
}