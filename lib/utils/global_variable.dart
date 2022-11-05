import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post_now/screens/add_post_screen.dart';
import 'package:post_now/screens/feed_screen.dart';
import 'package:post_now/screens/profile_screen.dart';
import 'package:post_now/screens/search_screen.dart';

// ignore: constant_identifier_names
const WebScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
