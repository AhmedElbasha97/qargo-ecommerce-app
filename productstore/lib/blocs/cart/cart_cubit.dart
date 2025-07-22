import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../../services/notification_service.dart';


class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]) {
    loadCart();
  }


  Future<void> addToCart(ProductModel product, {BuildContext? context}) async {
    final index = state.indexWhere((item) => item.product.id == product.id);
    final updated = [...state];
    await NotificationService().showCartNotification(product.title);    if (index == -1) {
      updated.add(CartItem(product: product));
    } else {
      updated[index].quantity += 1;
    }

    emit(updated);
    saveCart(updated);

    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.title} added to cart')),
      );
    }
  }

  void removeFromCart(ProductModel product) {
    final updated = [...state]..removeWhere((item) => item.product.id == product.id);
    emit(updated);
    saveCart(updated);
  }

  void increaseQuantity(ProductModel product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final updated = [...state];
      updated[index].quantity += 1;
      emit(updated);
      saveCart(updated);
    }
  }

  void decreaseQuantity(ProductModel product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final updated = [...state];
      if (updated[index].quantity > 1) {
        updated[index].quantity -= 1;
      } else {
        updated.removeAt(index);
      }
      emit(updated);
      saveCart(updated);
    }
  }

  Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList('cart', jsonList);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('cart') ?? [];
    final cart = saved.map((s) => CartItem.fromJson(jsonDecode(s))).toList();
    emit(cart);
  }
  void clearCart() async {
    emit([]);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
  }
}