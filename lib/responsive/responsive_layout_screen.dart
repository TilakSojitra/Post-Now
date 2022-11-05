import 'package:flutter/material.dart';
import 'package:post_now/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../utils/global_variable.dart';

class ResponsiveLayout extends StatefulWidget {

  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async{
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }
  
  @override
  Widget build(BuildContext context){
    return LayoutBuilder (
      builder: (context,constraints) {
        if(constraints.maxWidth > WebScreenSize){
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );
  }
}