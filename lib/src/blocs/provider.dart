import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/login_bloc.dart';
export 'package:form_validation/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget{

  static Provider _instanciaActual;

  factory Provider({Key key, Widget child}){

    if(_instanciaActual == null){
      _instanciaActual = new Provider._internal(key: key, child: child );      //._internal es un constructor privado para prevenir que se inicializa la clase desde afuera
    }

    return _instanciaActual;

  }

  Provider._internal({key, Widget child})             //CONSTRUCTOR RÁPIDO QUE IMPLEMENTA EL INHERETED 
    : super(key: key, child: child);

  final loginbloc = loginBloc();

  // Provider({key, Widget child})             //CONSTRUCTOR RÁPIDO QUE IMPLEMENTA EL INHERETED 
  //   : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static loginBloc of ( BuildContext context ) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginbloc;
  }

}