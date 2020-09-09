import 'package:buyemall/models/product.dart';
import 'package:buyemall/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../palette.dart';

class ProductEditScreen extends StatefulWidget {
  static const String routeName = '/product-edit';

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _editFormKey = GlobalKey<FormState>();
  // Always dispose of FocusNodes coz of memory leaks
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  // Always dispose of TextEditControllers
  final _imageUrlController = TextEditingController();
  Map<String, dynamic> _editFormData = {
    'title': '',
    'price': '',
    'imageUrl': ''
  };
  var _isInit = true;
  Product _selectedProduct;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final product = ModalRoute.of(context).settings.arguments as Product;

    if (product != null) {
      _selectedProduct = product;
      if (_isInit) {
        _editFormData['title'] = product.title;
        _editFormData['description'] = product.description;
        _editFormData['price'] = product.price;
        _imageUrlController.text = product.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  _validate(String name, value) {
    if (value.isEmpty) {
      return 'Please enter a $name';
    }

    if (name == 'price') {
      if (double.tryParse(value) == null) {
        return 'Please enter a valid price';
      }

      if (double.parse(value) <= 0) {
        return 'Please enter a price greater than zero';
      }
    }

    if (name == 'description') {
      if (value.length <= 10) {
        return 'Description should be atleast 10 characters long';
      }
    }

    return null;
  }

  _save(String name, dynamic value) {
    setState(() {
      _editFormData[name] = value;
    });
  }

  Future<void> _submit() async {
    if (!_editFormKey.currentState.validate()) {
      return;
    }

    _editFormKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_selectedProduct == null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editFormData);
      } catch (error) {
        await showDialog(context: null);
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_selectedProduct.id, _editFormData);
      } catch (error) {
        await showDialog(context: null);
      }
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [
            IconButton(icon: Icon(Icons.save), onPressed: () => _submit())
          ],
        ),
        body: (_isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: (Form(
                    key: _editFormKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          initialValue: _editFormData['title'],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) => _validate('title', value),
                          onSaved: (newValue) => _save('title', newValue),
                        ),
                        TextFormField(
                            initialValue: _editFormData['price'].toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Price'),
                            textInputAction: TextInputAction.next,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) => _validate('price', value),
                            onSaved: (newValue) =>
                                _save('price', double.parse(newValue))),
                        TextFormField(
                            initialValue: _editFormData['description'],
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            focusNode: _descriptionFocusNode,
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            validator: (value) =>
                                _validate('description', value),
                            onSaved: (newValue) =>
                                _save('description', newValue)),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: Container(
                                  child: (_imageUrlController.text.isEmpty)
                                      ? Text('Enter a URL')
                                      : FittedBox(
                                          child: Image.network(
                                              _imageUrlController.text),
                                        )),
                            ),
                            Expanded(
                              child: TextFormField(
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  decoration:
                                      InputDecoration(labelText: 'Image URL'),
                                  controller: _imageUrlController,
                                  onFieldSubmitted: (_) {
                                    _submit();
                                  },
                                  validator: (value) =>
                                      _validate('imageUrl', value),
                                  onSaved: (newValue) =>
                                      _save('imageUrl', newValue)),
                            )
                          ],
                        ),
                      ],
                    ))),
              ));
  }
}
