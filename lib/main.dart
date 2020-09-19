import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/views/product_detail_screen.dart';
import 'package:shop_app/views/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  /*
  * Added a Cart function, so we will have a Cart Provider.
  * That is why I am now using a MultiProvider, that gives the possibility to have
  * more than one provider.
   */
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}

/*
 * Deprecated piece code.
 * I now have more than one provider, so that solution will not work anymore so I've
 * just commented for future reference. :)
 */
/*
    //Using a observer to update products list and than
    //instancing the list returned from the provider.

    return ChangeNotifierProvider(
      //Observer
      create: (_) => new ProductsProvider(), //List returned from the provider
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
*/
