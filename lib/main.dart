import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//url para API
const request = 'https://api.hgbrasil.com/finance?format=json-cors&key=48882cef';
void main() {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        hintColor: Colors.amber,
        primaryColor: Colors.white,
      ),
    ),
  );
}

Future<Map> getData() async {
  //fazer a requisição HTTP ára obter os dados
  //decoficar o JSON
  http.Response resposta = await http.get(Uri.parse(request));
  return json.decode(resposta.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //controladores para os campos de texto
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  //variaveis para armazenar os valores das moedas

  double dolar = 0;
  double euro = 0;

  //função para conversão de moedas

  void _converteDolar(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _converteEuro(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar). toStringAsFixed(2);
  }

  void _converteReal(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  //interface

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text ("\$ Conversor de Moedas \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          //Verifica estado da conexão com a API e exibe diferentes componentes
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                ),
                textAlign: TextAlign.center,
              )
            );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    "Erro ao Carregar Dados :(",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }else{
            dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
            euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
            return SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.monetization_on, 
                    size: 150.0, 
                    color: Colors.amber
                  ),
                  TextField(
                    controller: realController,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    decoration: InputDecoration(
                      labelText: "Reais",
                      labelStyle: TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0,
                      ),
                      border: OutlineInputBorder(),
                      prefixText: "R\$",
                    ),
                    onChanged: _converteReal,
                    keyboardType: TextInputType.number,
                  ),
                  Divider(),
                  TextField(
                    controller: dolarController,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    decoration: InputDecoration(
                      labelText: "Dólares",
                      labelStyle: TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0,
                      ),
                      border: OutlineInputBorder(),
                      prefixText: "US\$",
                    ),
                    onChanged: _converteDolar,
                    keyboardType: TextInputType.number,
                  ),
                  Divider(),
                  TextField(
                    controller: euroController,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    decoration: InputDecoration(
                      labelText: "Euros",
                      labelStyle: TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0,
                      ),
                      border: OutlineInputBorder(),
                      prefixText: "€",
                    ),
                    onChanged: _converteEuro,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            );
            }
          }
        }
      ),
    );
  }
}
