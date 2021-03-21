import 'dart:convert';
import 'dart:io';


import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';
import 'package:form_validation/src/models/producto_model.dart';


class ProductosProvider {

  final String _url = 'https://flutter-varios-db737-default-rtdb.firebaseio.com';
  
  final _prefs = new PreferenciasUsuario();


  Future<bool> crearProducto( ProductoModel producto ) async {
    
    final url = Uri.parse('$_url/productos.json?auth=${ _prefs.token }');

    final resp = await http.post( url, body: productoModelToJson(producto) );


    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }

  Future<bool> editarProducto( ProductoModel producto ) async {
    
    final url = Uri.parse('$_url/productos/${ producto.id }.json?auth=${ _prefs.token }');

    final resp = await http.put( url, body: productoModelToJson(producto) );


    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }

  Future<List<ProductoModel>> cargarProductos() async {


    final url  = Uri.parse('$_url/productos.json?auth=${ _prefs.token }');
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();

    if( decodedData == null ) return [];

    decodedData.forEach( ( id, producto) { 
      
      final prodTemp = ProductoModel.fromJson(producto);
      prodTemp.id = id;
      
      productos.add( prodTemp );

    });
    // print(productos);
    return productos;
  }

  Future<int> borrarProducto( String id) async{
    final url = Uri.parse('$_url/productos/$id.json?auth=${ _prefs.token }');

    final resp = await http.delete(url);

    print( resp.body );

    return 1;

  }

  Future<String> subirImagen( File imagen ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/ds49kk4nc/image/upload?upload_preset=cxoc68sj');
    final mimeType = mime(imagen.path).split('/');      //image/jpg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] ),       //mimetype[0] es la imagen y el [1] es el tipo
    );

    imageUploadRequest.files.add(file);

    // imageUploadRequest.files.add(file);         //SE PUEDEN SUBIR VARIOS ARCHIVOS ASÍ, PERO AQUÍ SOLO OCUPAMOS SUBIR UNO
    // imageUploadRequest.files.add(file);
    // imageUploadRequest.files.add(file);
    

    final streamResponse = await imageUploadRequest.send();   //se manda la petición y obtenemos la respuesta
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201 ){
      print('Algo salió mal');
      print(resp.body);
      return null;
    }

    final responseData = json.decode(resp.body);
    print(responseData);

    return responseData['secure_url'];

  }
}
