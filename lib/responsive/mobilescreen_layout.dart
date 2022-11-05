
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:post_now/utils/colors.dart';
import 'package:post_now/utils/global_variable.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:post_now/models/user.dart' as model;
// import '../providers/user_provider.dart'; 


class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}): super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTaped(int page){
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView (
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
        // child: Text(user.username)
      ),
      bottomNavigationBar: CupertinoTabBar (
        height: 55,
        backgroundColor: mobileBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _page == 0 ? primaryColor : secondaryColor),
            label:'',
            backgroundColor: primaryColor,
          ), 
          BottomNavigationBarItem(
            icon: Icon(Icons.search,  color: _page == 1 ? primaryColor : secondaryColor),
            label:'',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle , color: _page == 2 ? primaryColor : secondaryColor),
            label:'',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _page == 3 ? primaryColor : secondaryColor),
            label:'',
            backgroundColor: primaryColor,
          ),
           
        ],
        onTap: navigationTaped,
        currentIndex: _page,
        )
      );
  }
}
 