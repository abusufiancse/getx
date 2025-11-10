// lib/data/models/product_model.dart

import '../core/utils/safe_cast.dart';

class ProductResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: SafeCast.asList(
        json['products'],
        elementConverter: (productJson) => Product.fromJson(productJson),
      ),
      total: SafeCast.asInt(json['total']),
      skip: SafeCast.asInt(json['skip']),
      limit: SafeCast.asInt(json['limit']),
    );
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final double weight;
  final Dimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<Review> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final Meta meta;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: SafeCast.asInt(json['id']),
      title: SafeCast.asString(json['title']),
      description: SafeCast.asString(json['description']),
      category: SafeCast.asString(json['category']),
      price: SafeCast.asDouble(json['price']),
      discountPercentage: SafeCast.asDouble(json['discountPercentage']),
      rating: SafeCast.asDouble(json['rating']),
      stock: SafeCast.asInt(json['stock']),
      tags: SafeCast.asList(
        json['tags'],
        elementConverter: (tag) => SafeCast.asString(tag),
      ),
      brand: SafeCast.asString(json['brand']),
      sku: SafeCast.asString(json['sku']),
      weight: SafeCast.asDouble(json['weight']),
      dimensions: Dimensions.fromJson(SafeCast.asMap(json['dimensions'])),
      warrantyInformation: SafeCast.asString(json['warrantyInformation']),
      shippingInformation: SafeCast.asString(json['shippingInformation']),
      availabilityStatus: SafeCast.asString(json['availabilityStatus']),
      reviews: SafeCast.asList(
        json['reviews'],
        elementConverter: (review) => Review.fromJson(review),
      ),
      returnPolicy: SafeCast.asString(json['returnPolicy']),
      minimumOrderQuantity: SafeCast.asInt(json['minimumOrderQuantity']),
      meta: Meta.fromJson(SafeCast.asMap(json['meta'])),
      thumbnail: SafeCast.asString(json['thumbnail']),
      images: SafeCast.asList(
        json['images'],
        elementConverter: (image) => SafeCast.asString(image),
      ),
    );
  }
}

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: SafeCast.asDouble(json['width']),
      height: SafeCast.asDouble(json['height']),
      depth: SafeCast.asDouble(json['depth']),
    );
  }
}

class Review {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: SafeCast.asInt(json['rating']),
      comment: SafeCast.asString(json['comment']),
      date: DateTime.tryParse(SafeCast.asString(json['date'])) ?? DateTime.now(),
      reviewerName: SafeCast.asString(json['reviewerName']),
      reviewerEmail: SafeCast.asString(json['reviewerEmail']),
    );
  }
}

class Meta {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      createdAt: DateTime.tryParse(SafeCast.asString(json['createdAt'])) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(SafeCast.asString(json['updatedAt'])) ?? DateTime.now(),
      barcode: SafeCast.asString(json['barcode']),
      qrCode: SafeCast.asString(json['qrCode']),
    );
  }
}