import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../components/product_item.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool isLoading = false;

  Future<void> _refreshProducts(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    return Provider.of<ProductList>(context, listen: false)
        .loadProducts()
        .then((result) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProductList productList = Provider.of(context);
    final productFake = [
      Product(
        id: Random().nextDouble().toString(),
        name: 'loading',
        description: 'teste',
        price: 2,
        imageUrl: '',
      )
    ];

    final List<Product> fakeProductList = [
      ...productFake,
      ...productFake,
      ...productFake,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar produtos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productForm);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Skeletonizer(
            enabled: isLoading,
            child: ListView.builder(
              itemCount:
                  isLoading ? fakeProductList.length : productList.itemsCount,
              itemBuilder: (ctx, i) {
                return Column(
                  children: [
                    ProductItem(
                        isLoading ? fakeProductList[i] : productList.items[i]),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
