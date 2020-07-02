import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/provider/products.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    this._imageUrlFocusNode.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    this._priceFocusNode.dispose();
    this._descriptionFocusNode.dispose();
    this._imageUrlFocusNode.removeListener(updateImage);
    this._imageUrlFocusNode.dispose();
  }

  void updateImage() {
    if(this._isValidImageUrl(this._imageUrlController.text)){
      setState(() {});
    }
  }

  bool _isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');

    bool endWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endWithJpeg = url.toLowerCase().endsWith('.jpeg');
    bool endWithPng = url.toLowerCase().endsWith('.png');

    return (startWithHttp || startWithHttps) &&
        (endWithJpeg || endWithJpg || endWithPng);
  }

  void _saveForm() {
    if (!this._form.currentState.validate()) return;

    this._form.currentState.save();

    final newProduct = new Product(
      title: this._formData['title'],
      price: this._formData['price'],
      description: this._formData['description'],
      imageUrl: this._formData['imageUrl'],
    );

    //Para trabalhar com o context fora do método build, o listen tem que ser false
    Provider.of<Products>(context, listen: false).addProduct(newProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário Produto'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: this._saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: this._form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(this._priceFocusNode);
                },
                onSaved: (value) => this._formData['title'] = value,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Informe um Título válido';
                  }
                  if (value.trim().length < 3) {
                    return 'Informe um Título com mais de 3 letras';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: this._priceFocusNode,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(this._descriptionFocusNode);
                },
                onSaved: (value) =>
                    this._formData['price'] = double.parse(value),
                validator: (value){
                  if (value.trim().isEmpty) {
                    return 'Informe um Preço';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Informe um Preço acima de R\$ 0.00';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                focusNode: this._descriptionFocusNode,
                keyboardType: TextInputType.multiline,
                onSaved: (value) => this._formData['description'] = value,
                validator: (value){
                  if (value.trim().isEmpty) {
                    return 'Informe uma Descrição';
                  }
                  if (value.trim().length < 10) {
                    return 'Informe uma Descrição com mais de 10 letras';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'URL da imagem'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: this._imageUrlFocusNode,
                      controller: this._imageUrlController,
                      onFieldSubmitted: (_) {
                        this._saveForm();
                      },
                      onSaved: (value) => this._formData['imageUrl'] = value,
                      validator: (value){
                        if(value.trim().isEmpty) return 'Informe uma URL válida';
                        if(!this._isValidImageUrl(value)) return 'A URL informada não é válida';
                        return null;
                      },
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 8,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: this._imageUrlController.text.isEmpty
                        ? Text(
                            'Informe a URL',
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            child: Image.network(this._imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
