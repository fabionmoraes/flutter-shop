import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/utils/alert.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget(
    this.cartItem, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Cart provider = Provider.of(context, listen: false);

    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (_) {
        return AlertMessage(context)
            .confirmed('Quer remover o item do carrinho?');
      },
      onDismissed: (_) {
        provider.removeItem(cartItem.productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor:
                Theme.of(context).primaryTextTheme.headlineMedium?.color,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text('${cartItem.price}'),
              ),
            ),
          ),
          title: Text(cartItem.name),
          subtitle: Text('Total: R\$ ${cartItem.price * cartItem.quantity}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
