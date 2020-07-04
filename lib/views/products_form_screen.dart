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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    this._imageUrlFocusNode.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;
      if (product != null) {
        this._formData['id'] = product.id;
        this._formData['title'] = product.title;
        this._formData['price'] = product.price;
        this._formData['description'] = product.description;
        this._formData['imageUrl'] = product.imageUrl;

        this._imageUrlController.text = product.imageUrl;
      } else {
        this._formData['price'] = '';
      }
    }
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
    if (this._isValidImageUrl(this._imageUrlController.text)) {
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

  Future<void> _saveForm() async {
    if (!this._form.currentState.validate()) return;

    this._form.currentState.save();

    final newProduct = new Product(
      id: this._formData['id'],
      title: this._formData['title'],
      price: this._formData['price'],
      description: this._formData['description'],
      imageUrl: this._formData['imageUrl'],
    );

    setState(() {
      this._isLoading = true;
    });

    //Para trabalhar com o context fora do método build, o listen tem que ser false
    final products = Provider.of<Products>(context, listen: false);

    try {
      (this._formData['id'] == null)
          ? await products.addProduct(newProduct)
          : await products.updateProduct(newProduct);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um Erro!'),
          content: Text('Não foi possível salvar o produto.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        this._isLoading = false;
      });
    }
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
      body: this._isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: this._form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: this._formData['title'],
                      decoration: InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(this._priceFocusNode);
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
                      initialValue: this._formData['price'].toString(),
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
                      validator: (value) {
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
                      initialValue: this._formData['description'],
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      focusNode: this._descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) => this._formData['description'] = value,
                      validator: (value) {
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
                            decoration:
                                InputDecoration(labelText: 'URL da imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: this._imageUrlFocusNode,
                            controller: this._imageUrlController,
                            onFieldSubmitted: (_) {
                              this._saveForm();
                            },
                            onSaved: (value) =>
                                this._formData['imageUrl'] = value,
                            validator: (value) {
                              if (value.trim().isEmpty)
                                return 'Informe uma URL válida';
                              if (!this._isValidImageUrl(value))
                                return 'A URL informada não é válida';
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
                              : SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: FittedBox(
                                    child: Image.network(
                                        this._imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
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
