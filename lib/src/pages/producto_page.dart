import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/productos_provider.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formkey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context)
        .settings
        .arguments; //Revisa si es nuevo producto o es uno que ya existe, toma el argumento si viene, si es nuevo viene en null
    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Productos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual_outlined),
            onPressed: () => _seleccionarFoto(),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt_outlined),
            onPressed: () => _tomarFoto(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key:
                formkey, //FORMWIDGET NOS PERMITE CONTROLAR EL ESTADO DE ESTE FORMULARIO
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto
          .titulo, //ES UNA CONDICIÓN ESPECIALIZADA PARA EVALUAR CADA UNO DE LOS CAMPOS Y VALIDARLOS
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value, //Guarda el valor escrito
      validator: (value) {
        //hace las validaciones
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Un precio solo tiene números';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {



    if (!formkey.currentState.validate()) return;
    // if( formkey.currentState.validate() ){
    //   //cuando el formulario es válido
    // }
    formkey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if(foto != null){
      producto.fotoUrl = await productoProvider.subirImagen(foto);
    }

    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }

    // setState(() {
    //   _guardando = false;
    // });
    mostrarSnackbar('Registro guardado!');

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      behavior: SnackBarBehavior.floating,
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage( producto.fotoUrl ),
        placeholder: AssetImage('assets/jar-loading.gif'), 
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    
    _procesarImagen( ImageSource.gallery );

  }

  _tomarFoto() async {
    
    _procesarImagen( ImageSource.camera );

  }

  _procesarImagen( ImageSource origen ) async {
    final ImagePicker imagePicker = ImagePicker();
    final PickedFile pickedFile =
        await imagePicker.getImage(source: origen);
    setState(() {
      if (pickedFile != null) {
        foto = File(pickedFile.path);
        producto.fotoUrl = null;
        setState(() {
          
        });
      } else {
        print('No se seleccionó una foto.');
      }
    });
  }
}
