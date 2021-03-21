import 'dart:convert';

import 'package:form_validation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

  final String _firebaseToken = 'AIzaSyCxTNHRRsNOka5cI2UvK4hhwhNCCQfI00E';
  final _prefs = new PreferenciasUsuario();

  Future <Map<String, dynamic>> login( String email, String password ) async {

    final _url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken');
    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final resp = await http.post(
      _url,
      body: json.encode( authData ),
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if( decodedResp.containsKey('idToken') ) {
      
      _prefs.token = decodedResp['idToken'];

      return { 'Ok': true, 'token': decodedResp['idToken'] };
    } else{
      return { 'Ok': false, 'Mensaje': decodedResp['error']['message'] };
    }
  }




  Future<Map<String, dynamic>> nuevoUsuario( String email, String password) async {

    
    final _url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken');
    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true,
    };

    final resp = await http.post(
      _url,
      body: json.encode( authData ),
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if( decodedResp.containsKey('idToken') ) {
      
      _prefs.token = decodedResp['idToken'];

      return { 'Ok': true, 'token': decodedResp['idToken'] };
    } else{
      return { 'Ok': false, 'Mensaje': decodedResp['error']['message'] };
    }
    
  }

}