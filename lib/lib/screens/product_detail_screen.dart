// lib/screens/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Get.to(() => ProductDetailScreen(product: product));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                product.thumbnail,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (product.discountPercentage > 0)
                          Text(
                            '${product.discountPercentage.toStringAsFixed(1)}% OFF',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return Icon(
                              index < product.rating ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            );
                          }),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.rating.toStringAsFixed(1)})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stock: ${product.stock}',
                      style: TextStyle(
                        fontSize: 12,
                        color: product.stock > 10 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}