import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shop/models/book.dart';
import 'package:shop/models/cart.dart';

void main() {
  test('Cart model works correctly', () {
    final cart = Cart();

    cart.add(books[0]);
    cart.add(books[1]);

    debugPrint('After adding: ${cart.count} items');

    final addedAgain = cart.add(books[0]);
    debugPrint('Duplicate added: $addedAgain');

    cart.remove(books[0]);

    debugPrint('${cart.count} items, ${cart.total} ₸');

    expect(cart.count, 1);
    expect(cart.total, 3100);
    expect(addedAgain, false);

    expect(() => cart.items.add(books[0]), throwsUnsupportedError);
  });
}
