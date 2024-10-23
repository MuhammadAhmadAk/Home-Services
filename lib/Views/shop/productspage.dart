import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services/Views/shop/product_details.dart';
import 'package:home_services/Views/shop/widgets/product_card.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/shared_pref_products.dart';
import 'package:home_services/_DB%20services/bloc/product%20cubit/products_cubit.dart';
import 'package:home_services/_DB%20services/bloc/product%20cubit/products_state.dart';

class ProductPage extends StatefulWidget {
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String? _selectedSortOption;

  @override
  void initState() {
    super.initState();
    getProducts();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Define the slide animation (bottom to top)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Starts from below the screen
      end: Offset.zero, // Ends at the default position (no offset)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Define fade animation
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Start the animation after a delay
    Future.delayed(Duration(milliseconds: 200), () {
      _animationController.forward();
    });

    // Listen for changes in the search field
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  saveProducts(List<Map<String, dynamic>> newProducts) async {
    await SharedPrefProducts.storeProducts(newProducts);
    setState(() {
      products = newProducts;
      filteredProducts = newProducts; // Initialize filtered list
    });
  }

  getProducts() async {
    List<Map<String, dynamic>>? savedProducts =
        await SharedPrefProducts.getProducts();
    log("All saved products $savedProducts");
    if (savedProducts != null) {
      setState(() {
        products = savedProducts;
        filteredProducts = savedProducts; // Set the initial filtered products
      });
    }
    context.read<ProductsCubit>().fetchProducts();
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final productName = product['name'].toString().toLowerCase();
        final productCategory = product['category'].toString().toLowerCase();
        // Check if the search query matches either the name or category
        return productName.contains(query) || productCategory.contains(query);
      }).toList();

      // Apply sorting after filtering
      _sortProducts();
    });
  }

  void _sortProducts() {
    if (_selectedSortOption == 'Low to High') {
      filteredProducts.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (_selectedSortOption == 'High to Low') {
      filteredProducts.sort((a, b) => b['price'].compareTo(a['price']));
    }
  }

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
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductLoadedState) {
            saveProducts(state.products);
            log("${state.products}");
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search by product name or category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredProducts.length} Products',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.black54),
                    ),
                    DropdownButton<String>(
                      value: _selectedSortOption,
                      hint: Text('Sort By',
                          style: GoogleFonts.poppins(color: Colors.black54)),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSortOption = newValue;
                          _sortProducts(); // Sort products on selection
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'Low to High',
                          child: Text('Price: Low to High'),
                        ),
                        DropdownMenuItem(
                          value: 'High to Low',
                          child: Text('Price: High to Low'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoModalPopupRoute(
                                    builder: (context) => ProductDetailsPage(
                                        product: products[index]),
                                  ));
                            },
                            child: ProductCard(
                              product: filteredProducts[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
