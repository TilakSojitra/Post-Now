import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_now/resources/auth_methods.dart';
import 'package:post_now/screens/login_screen.dart';
import 'package:post_now/screens/profile_screen.dart';
import 'package:post_now/utils/colors.dart';
import 'package:post_now/utils/utils.dart';
import 'package:post_now/widgets/text_field.dart';
import 'package:post_now/resources/auth_methods.dart';

import '../responsive/mobilescreen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/webscreen_layout.dart';

class UpdateScreen extends StatefulWidget {
  final String uid;
  const UpdateScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;
  var userData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      print(widget.uid);
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;
      _usernameController.text = userData['username'];
      _bioController.text = userData['bio'];
      _image = userData['photoUrl'];

      setState(() {});
    } catch (e) {
      // showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void updateUser() async {
    setState(() {
      isLoading = true;
    });



    String res = await AuthMethods().updateUser(
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image,
    );

    if (res != 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
      setState(() {
        isLoading = false;
      });
    } else {
      showSnackBar(res, context);
      setState(() {
        isLoading = false;
      });

      // ignore: use_build_context_synchronously
      navigateToProfile();
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToProfile() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(uid: widget.uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return Scaffold(
      appBar: AppBar(
        // leading: InkWell(
        //   onTap: () => {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(
        //         builder: (context) => ProfileScreen(uid: widget.uid),
        //       ),
        //     )
        //   },
        //   child: const Icon(
        //     Icons.close,
        //   ),
        // ),
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Edit profile',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 170,
                ),
                // Flexible(flex: 8, child: Container()),

                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                TextFormField(
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  controller: _usernameController,
                ),

                const SizedBox(height: 14),

                TextFormField(
                  decoration: InputDecoration(
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  controller: _bioController,
                ),

                const SizedBox(height: 14),
                InkWell(
                  onTap: updateUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      color: blueColor,
                    ),
                    child: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          )
                        : const Text(
                            'Update',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
