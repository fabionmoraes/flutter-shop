import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/badge_count.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/product_grid.dart';

enum FilterOption {
  favorite,
  all,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOption.favorite,
                child: Text('Somente Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOption.all,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOption selected) {
              setState(() {
                if (selected == FilterOption.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
            builder: (ctx, cart, child) => BadgeCount(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: ProductGrid(
        showFavoriteOnly: _showFavoriteOnly,
      ),
    );
  }
}
