import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

/*
   * ---------------------------------------------------------------------------
   * CONTROLLING THE FOCUS OF THE FORM:
   *
   * First thing that is needed is a FocusNode (final _priceFocusNode = FocusNode();)
   * That need to be linked to the proper field, in this case, that would be the
   * field for the price (focusNode: _priceFocusNode,).
   *
   * Next a TextInputAction should be defined, to change the behavior of the "Enter" option.
   * In case of the title, that would be "textInputAction: TextInputAction.next,".
   *
   * Now it is time to tell the app what to do when the user clicks in the "Next" button.
   * For that use the "onFieldSubmitted", in case of the title, we should have:
   *
   * onFieldSubmitted: (_) {
   *   FocusScope.of(context).requestFocus(_priceFocusNode);
   * },
   *
   * When using FocusNode, it is advised (aka: required) to get rid of them after
   * you are done. the dispose() method should be used:
   *
   *  @override
   *  void dispose() {
   *    super.dispose();
   *    _priceFocusNode.dispose();
   *  }
   *
   * ---------------------------------------------------------------------------
   */

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusMode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  final product = Product;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusMode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Product;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    if (isValidUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusMode.removeListener(_updateImage);
    _imageUrlFocusMode.dispose();
  }

  void _submitForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      final product = Product(
        id: _formData['id'],
        title: _formData['title'],
        price: _formData['price'],
        description: _formData['description'],
        imageUrl: _formData['imageUrl'],
      );
      final productProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      if (_formData['id'] == null) {
        productProvider.addProduct(product);
      } else {
        productProvider.updateProduct(product);
      }
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  bool isValidUrl(String url) {
    /*
     * Far from the ideal verifications but it works for this simple application
     */
    bool isValidProtocol = url.toLowerCase().startsWith(('http://')) ||
        url.toLowerCase().startsWith(('https://'));
    bool isValidImage = url.toLowerCase().endsWith('png') ||
        url.toLowerCase().endsWith('jpg') ||
        url.toLowerCase().endsWith('jpeg');
    return (isValidProtocol && isValidImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Form'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                initialValue: _formData['title'],
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Title should not be empty.';
                  }
                  if (value.trim().length < 3) {
                    return 'Title should have at least 3 characters.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                initialValue: _formData['price'].toString(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //Keyboard type, for iOS devices a "numberWithOptions(decimal: true)" option should be set.
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) => _formData['price'] = double.parse(value),
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Price should not be empty';
                  }
                  if ((double.parse(value.trim()) <= 0)) {
                    return 'Inform a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                initialValue: _formData['description'],
                maxLines: 3,
                //Number of lines
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _formData['description'] = value,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Description should not be empty';
                  }
                  if (value.trim().length < 10) {
                    return 'Description should have at least 12 characters.';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusMode,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) {
                        _submitForm();
                      },
                      onSaved: (value) => _formData['imageUrl'] = value,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Image URL must not be empty';
                        }
                        if (!isValidUrl(_imageUrlController.text)) {
                          return 'Invalid URL.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Inform a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                    alignment: Alignment.center,
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
