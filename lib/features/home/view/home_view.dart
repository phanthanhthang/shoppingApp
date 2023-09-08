import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../../product/component/text/subtitle1_text.dart';
import '../../../core/base/view/base_view.dart';
import '../../../product/component/card/special_icon_card.dart';
import '../../../product/component/card/special_text_card.dart';
import '../../../screens/add_product.dart';
import '../viewmodel/home_view_model.dart';
import '../../../core/extensions/app_extensions.dart';
import '../../../product/component/card/item_card.dart';
import '../../../product/component/icon/primary_icon.dart';
import '../../../product/component/image/responsive_image.dart';
import '../../../product/component/text/bold_title.dart';
import '../../../product/component/text/primary_bold_text.dart';
import '../../../product/component/text/product_name.dart';
import '../../../screens/welcome.dart';

class HomeView extends StatelessWidget {
  static const path = '/home';
  const HomeView({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) => BaseView<HomeViewModel>(
        viewModel: HomeViewModel(),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
          uid == "" ? model.fetchItems() : model.fetchData(uid);
          print(uid);
        },
        onPageBuilder: (BuildContext context, HomeViewModel viewModel) {
          Widget isLoading = viewModel.isLoading
              ? _loadingBar(context)
              : _products(context, viewModel);
          return Scaffold(
              backgroundColor: context.groupedBackground,
              appBar: _appBar(context, viewModel),
              body: isLoading);
        },
      );

  AppBar _appBar(BuildContext context, HomeViewModel viewModel) => AppBar(
        backgroundColor: context.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ),
        title: _appBarTitle(context),
        actions: [
          _totalMoney(context, viewModel),
          uid != ""
              ? Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProduct(uid: uid),
                        ),
                      );
                    },
                    child: Icon(Icons.add),
                  ))
              : SizedBox(),
        ],
      );

  Text _appBarTitle(BuildContext context) => BoldTitle(
        data: 'Discover',
        context: context,
      );

  Padding _totalMoney(BuildContext context, HomeViewModel viewModel) {
    String totalMoney = '\€ ${viewModel.totalPrice}';
    return Padding(
      padding: context.horizontalPaddingNormal,
      child: ActionChip(
        backgroundColor: context.secondaryBackground,
        // Total money text
        label: PrimaryBoldText(context: context, data: totalMoney),
        // Shop icon
        avatar: PrimaryIcon(icon: Icons.shopping_bag, context: context),
        onPressed: () => _showModalBottomSheet(context, viewModel),
      ),
    );
  }

// Loading widget
  Center _loadingBar(BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: context.primaryColor,
        ),
      );

// Body widget
  ElasticInDown _products(BuildContext context, HomeViewModel viewModel) =>
      ElasticInDown(
        duration: context.durationSlow,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: viewModel.products.length,
          itemBuilder: (context, index) => Padding(
              padding: context.paddingLow,
              child: GestureDetector(
                onTap: () {
                  print("tapped");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(
                          imageUrl: viewModel.products[index].image ?? ""),
                    ),
                  );
                },
                child: ItemCard(
                  context: context,
                  model: viewModel.products[index],
                  viewModel: viewModel,
                ),
              )),
        ),
      );

// Basket Menu
  void _showModalBottomSheet(BuildContext context, HomeViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: context.normalBorderRadius),
      backgroundColor: context.groupedBackground,
      builder: (context) => viewModel.basketItems.isEmpty
          ? _emptyBasket(context)
          : StatefulBuilder(builder: (context, StateSetter setState) {
              return _basketItems(context, viewModel, setState);
            }),
    );
  }

  FlipInY _emptyBasket(BuildContext context) => FlipInY(
        child: Center(
          child: Padding(
            padding: context.paddingLow,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                PrimaryIcon(icon: Icons.shopping_cart, context: context),
                context.emptySizedWidthBoxLow3x,
                Subtitle1Text(
                  data: 'Your basket is currently empty.',
                  context: context,
                  color: context.primaryColor,
                ),
              ],
            ),
          ),
        ),
      );

  ListView _basketItems(BuildContext context, HomeViewModel viewModel,
          StateSetter setState) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: context.paddingMedium,
        itemBuilder: (context, index) =>
            _basketItem(context, viewModel, index, setState),
        separatorBuilder: (context, index) => context.emptySizedHeightBoxLow,
        itemCount: viewModel.basketItems.length,
      );

  JelloIn _basketItem(BuildContext context, HomeViewModel viewModel, int index,
          StateSetter setState) =>
      JelloIn(
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: context.normalBorderRadius),
          child: Padding(
            padding: context.paddingLow,
            child: ListTile(
              leading: ResponsiveImage(
                  aspectRaito: 1,
                  imageUrl: viewModel.basketItems[index].image ?? ""),
              title: ProductName(
                data: viewModel.basketItems[index].title ?? 'Title is null !',
              ),
              subtitle:
                  _priceCountAndButtons(context, viewModel, index, setState),
            ),
          ),
        ),
      );

  Column _priceCountAndButtons(BuildContext context, HomeViewModel viewModel,
          int index, StateSetter setState) =>
      Column(
        children: [
          _pricesAndCount(context, viewModel, index),
          context.emptySizedHeightBoxLow,
          _buttons(setState, viewModel, index, context),
        ],
      );

  Wrap _pricesAndCount(
          BuildContext context, HomeViewModel viewModel, int index) =>
      Wrap(
        children: [
          // Price Text
          PrimaryBoldText(
            context: context,
            data:
                'Price: ${viewModel.basketItems[index].productPrice.toString()} \€',
          ),
          context.emptySizedWidthBoxLow2x,
          PrimaryBoldText(
            context: context,
            data:
                'Count: ${viewModel.basketItems[index].count.toString().substring(0, 1)}',
          ),
        ],
      );

  Row _buttons(StateSetter setState, HomeViewModel viewModel, int index,
          BuildContext context) =>
      Row(
        children: [
          GestureDetector(
            onTap: () => setState(
                () => viewModel.incrementCount(viewModel.basketItems[index])),
            child: SpecialIconCard(context: context, icon: Icons.add),
          ),
          // Count card
          SpecialTextCard(
            context: context,
            data: viewModel.basketItems[index].count.toString().substring(0, 1),
          ),
          // Deincrement count button
          GestureDetector(
            onTap: () {
              setState(() {
                viewModel.deIncrementCount(viewModel.basketItems[index]);
                if (viewModel.basketItems[index].count == 0) {
                  viewModel.basketItems.removeAt(index);
                }
              });
            },
            child: SpecialIconCard(
              context: context,
              icon: Icons.remove,
            ),
          ),
        ],
      );
}
// class HomeView extends StatefulWidget {
//   static const path = '/home';
//   const HomeView({Key? key}) : super(key: key);

//   @override
//   State<HomeView> createState() => _BottomNavigationBarExampleState();
// }

// class _BottomNavigationBarExampleState extends State<HomeView> {
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text(
//       'Index 0: Home',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 1: Business',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 2: School',
//       style: optionStyle,
//     ),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) => BaseView<HomeViewModel>(
//       viewModel: HomeViewModel(),
//       onModelReady: (model) {
//         model.setContext(context);
//         model.init();
//         model.fetchItems();
//       },
//       onPageBuilder: (BuildContext context, HomeViewModel viewModel) {
//         Widget isLoading = viewModel.isLoading
//             ? _loadingBar(context)
//             : _products(context, viewModel);
//         return Scaffold(
//           appBar: AppBar(
//           title: const Text('BottomNavigationBar Sample'),
//           ),
//           body: Center(
//             child: _widgetOptions.elementAt(_selectedIndex),
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Business',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.school),
//             label: 'School',
//           ),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: Colors.amber[800],
//           onTap: _onItemTapped,
//           )
//         );
//       }
//     );
//   }
// }
