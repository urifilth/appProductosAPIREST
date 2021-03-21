import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:form_validation/src/blocs/validators.dart';

class loginBloc with Validators{

  final _passwordController = BehaviorSubject<String>();  //POR DEFECTO TRAEN EL BROADCAST, YA NO SE USARÍA EL .BROADCAST();
  final _emailController    = BehaviorSubject<String>();  //POR DEFECTO TRAEN EL BROADCAST, YA NO SE USARÍA EL .BROADCAST();


  // Recuperar los datos del stream
  Stream<String> get emailStream    => _emailController.stream.transform( validarEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );

  Stream<bool> get formValidStream => Rx.combineLatest2(emailStream, passwordStream, (e, p) => true); //SE IMPLEMENTA CUAL COMBINACIÓN SE QUIERE USAR

  //INSERTAR VALORES AL STREAM
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;


  //OBTENER EL ÚLTIMO VALOR INGRESADO A LOS STREAMS
  String get email    => _emailController.value;
  String get password => _passwordController.value;

  dispose(){
    _emailController?.close();          //SIEMPRE ES UNA BUENA PRÁCTICA COLOCAR EL SIGNO POR SI ESTÁ VACÍO
    _passwordController?.close();
  }
  

}


