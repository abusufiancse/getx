import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import 'package:intl/intl.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final priceStr = product.price != null ? NumberFormat.simpleCurrency().format(product.price) : 'N/A';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _thumb(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title ?? 'No title', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(product.description ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(priceStr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                          const SizedBox(width: 4),
                          Text('${product.rating ?? 0}'),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumb() {
    final url = product.thumbnail;
    if (url == null || url.isEmpty) {
      return Container(width: 86, height: 86, color: Colors.grey.shade200, child: const Icon(Icons.image, size: 36));
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: 86,
      height: 86,
      fit: BoxFit.cover,
      placeholder: (c, s) => Container(color: Colors.grey.shade200),
      errorWidget: (c, s, e) => Container(color: Colors.grey.shade200, child: const Icon(Icons.broken_image)),
    );
  }
}
