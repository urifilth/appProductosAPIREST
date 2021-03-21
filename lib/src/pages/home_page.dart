import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/productos_provider.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Credenciales ingresadas'),
        centerTitle: true,
      ),
      body: _crearListado(),
      floatingActionButton: _crearButton(context),
    );
  }

  Widget _crearListado() {
    
    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: ( BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if( snapshot.hasData ){

          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            // itemCount: snapshot.data.length,     //este es un método que puede ser usado para conseguir la cantidad 
            itemBuilder: (context, i) => _crearItem( context, productos[i] ),
          );
        } else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    
  }

  Widget _crearItem(BuildContext context, ProductoModel producto){

    return Dismissible(     //Elimina deslizando
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: ( direccion ){
        productosProvider.borrarProducto(producto.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[

            ( producto.fotoUrl == null ) 
              ? Image(image: AssetImage('assets/no-image.png'),)
              : FadeInImage(
                image: NetworkImage( producto.fotoUrl ),
                placeholder: AssetImage('assets/jar-loading.gif'), 
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text('${ producto.titulo } - ${ producto.valor }'),
                subtitle: Text('${ producto.id }'),
                onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto).then((value) {setState(() { });}),
              )
          ],
        ),

      ),
    );

  }

  Widget _crearButton(BuildContext context){
    return FloatingActionButton(
      child: Icon( Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto').then((value) {  setState(() {      });}),
    );
  }
}
