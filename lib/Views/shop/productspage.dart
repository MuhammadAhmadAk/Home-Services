import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services/Views/shop/widgets/product_card.dart';
import 'package:home_services/main.dart';

class ProductPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {'image': 'https://as1.ftcdn.net/v2/jpg/02/60/49/74/1000_F_260497495_f8cVb5sVLHx1lku5YPmMCvy39g2zlhAG.jpg', 'name': 'ProArt Studiobook', 'brand': 'Asus', 'price': '\$2338,1'},
    {'image': 'https://as1.ftcdn.net/v2/jpg/02/60/49/74/1000_F_260497495_f8cVb5sVLHx1lku5YPmMCvy39g2zlhAG.jpg', 'name': 'Zenbook Duo', 'brand': 'Asus', 'price': '\$1272,2'},
    {'image': 'https://as2.ftcdn.net/v2/jpg/03/28/67/13/1000_F_328671336_hqPPPzmf0RVNVc4h6UELWxlTREyPfjwC.jpg', 'name': 'Zenbook Pro Duo', 'brand': 'Asus', 'price': '\$3096,97'},
    {'image': 'https://as2.ftcdn.net/v2/jpg/03/28/67/13/1000_F_328671336_hqPPPzmf0RVNVc4h6UELWxlTREyPfjwC.jpg', 'name': 'Macbook Pro', 'brand': 'Apple', 'price': '\$1238,75'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Popular Product',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 15.h),
            _buildProductCountAndSort(),
            SizedBox(height: 10.h),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search in Laptops',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildProductCountAndSort() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '40 Laptop Products',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Text(
                'Sort By',
                style: GoogleFonts.poppins(color: Colors.black54),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product: product);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product['image'],
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8),
            Text(
              product['name'],
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              product['brand'],
              style: GoogleFonts.poppins(color: Colors.black54),
            ),
            Text(
              product['price'],
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
