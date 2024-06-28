import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/snackbar.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context, listen: false);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            product.imageUrl != '' ? NetworkImage(product.imageUrl) : null,
      ),
      title: Text(product.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.productForm,
                  arguments: product,
                );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () {
                showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Tem certeza?'),
                          content: Text('Quer remover esse produto?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                              child: const Text('Não'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop(true);
                                final toastfy = Toastfy(context);

                                try {
                                  await provider.removeProduct(product);
                                  toastfy.success(
                                      'Produto atualizado com sucesso!',
                                      null,
                                      4);
                                } on HttpException catch (err) {
                                  toastfy.error(err.toString(), null, 4);
                                }
                              },
                              child: const Text('Sim'),
                            ),
                          ],
                        ));
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
