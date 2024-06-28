import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();

    _priceFocus.dispose();
    _descriptionFocus.dispose();

    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)!.settings.arguments;

      if (arg != null) {
        final product = arg as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  void updateImage() {
    setState(() {});
  }

  String? isValidaImageUrl(String? url) {
    String getUrl = url ?? '';

    bool isUrlValid = Uri.tryParse(getUrl)?.hasAbsolutePath ?? false;

    String urlToLowerCase = getUrl.toLowerCase();
    bool endsWithFile = urlToLowerCase.endsWith('.png') ||
        urlToLowerCase.endsWith('.jpg') ||
        urlToLowerCase.endsWith('jpeg');

    if (isUrlValid && endsWithFile) {
      return null;
    }

    return 'Url da imagem do produto inválido';
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => isLoading = true);

    final navigation = Navigator.of(context);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(context, _formData);
      navigation.pop();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de produto'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      initialValue: _formData['name']?.toString(),
                      textInputAction: TextInputAction.next,
                      onSaved: (newValue) => _formData['name'] = newValue ?? '',
                      validator: (value) {
                        final name = value ?? '';

                        if (name.trim().isEmpty) {
                          return 'O nome é obrigatório';
                        }

                        if (name.trim().length < 3) {
                          return 'O nome precisa do mínimo de três letras';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onSaved: (newValue) =>
                          _formData['price'] = double.parse(newValue ?? '0'),
                      focusNode: _priceFocus,
                      validator: (value) {
                        final priceString = value ?? '-1';
                        final price = double.tryParse(priceString) ?? -1;

                        if (price <= 0) {
                          return 'Informe um preço válido';
                        }

                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      onSaved: (newValue) =>
                          _formData['description'] = newValue ?? '',
                      validator: (value) {
                        final description = value ?? '';

                        if (description.trim().isEmpty) {
                          return 'O descrição é obrigatório';
                        }

                        if (description.trim().length < 10) {
                          return 'O descrição precisa do mínimo de dez letras';
                        }

                        return null;
                      },
                      maxLines: 3,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Url da Imagem',
                            ),
                            focusNode: _imageUrlFocus,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (newValue) =>
                                _formData['imageUrl'] = newValue ?? '',
                            validator: isValidaImageUrl,
                            controller: _imageUrlController,
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Informe a url')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
