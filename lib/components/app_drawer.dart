import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo Usuário!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Loja'),
            onTap: () {
              navigator.pushReplacementNamed(AppRoutes.authOrHome);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Pedidos'),
            onTap: () {
              navigator.pushReplacementNamed(AppRoutes.orders);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Gerenciar Produtos'),
            onTap: () {
              navigator.pushReplacementNamed(AppRoutes.products);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              navigator.pushReplacementNamed(AppRoutes.authOrHome);
            },
          ),
        ],
      ),
    );
  }
}
