import 'package:book_brain/screen/favorites/view/favorites_screen.dart';
import 'package:book_brain/screen/home/view/home_screen.dart';
import 'package:book_brain/screen/ranking/view/ranking_screen.dart';
import 'package:book_brain/screen/setting/view/setting_screen.dart';
import 'package:book_brain/utils/core/constants/dimension_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static const String routeName = '/main_app';
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0; 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior
          .translucent, 
      onTap: () {
        
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack( 
          index: _currentIndex,
          children: const [
            HomeScreen(),
            FavoritesScreen(),
            RankingScreen(),
            SettingScreen(),
          ],
        ),
        bottomNavigationBar: SalomonBottomBar( 
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() { 
              _currentIndex = index; 
            });
          },
          items: [
            SalomonBottomBarItem( 
              icon: Icon(FontAwesomeIcons.house,
                size: kDefaultIconSize,),
              title: Text("Trang chủ"),
            ),
            SalomonBottomBarItem( 
              icon: Icon(FontAwesomeIcons.solidHeart,
                size: kDefaultIconSize,),
              title: Text("Yêu thích"),
            ),
            SalomonBottomBarItem(
              icon: Icon(FontAwesomeIcons.rankingStar,
                size: kDefaultIconSize,),
              title: Text("Xếp hạng"),
            ),
            SalomonBottomBarItem( 
            
              icon: Icon(FontAwesomeIcons.solidUser,
            
                size: kDefaultIconSize,),
              title: Text("Cá nhân"),
             
            ),
          ],
        ),
      ),
    );
  }
}
