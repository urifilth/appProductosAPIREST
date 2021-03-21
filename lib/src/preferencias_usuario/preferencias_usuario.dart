//COPIAR Y PEGAR ESTA CLASE, NOS VA A SERVIR PARA CUALQUIER APP QUE QUERAMOS MANTENER
//INSTALAR SHARED_PREFERENCES EN EL PUBSPEC.YAML

/*IMPLEMENTAR LAS PREFERENCIAS EN EL MAIN***
  void main() async { 

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());

}
*/
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario(){
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  //Ninguna de estas preferencias se usa
  // bool _colorSecundario;
  // int _genero;
  // String _token;


  //PARA GUARDAR EL TOKEN

  //GET Y SET DEL token
  get token{
    return _prefs.getString('token') ?? '';
  }
  set token(String value){
    _prefs.setString('token', value);
  }
  
  //GET Y SET DE LA ÚLTIMA PÁGINA
  get ultimaPagina{
    return _prefs.getString('ultimaPagina') ?? 'home';
  }
  set ultimaPagina(String value){
    _prefs.setString('ultimaPagina', value);
  }

}
