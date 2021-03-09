import 'package:flutter/material.dart';

class Option {
  final IconData iconData;
  final String title;
  final Widget navigator;
  Option({
    this.iconData,
    this.title,
    this.navigator,
  });
}

final optionsList = <Option>[
  Option(
    iconData: Icons.person,
    title: 'Edit Profile',
    navigator: null,
  ),
  Option(
    iconData: Icons.sports_esports,
    title: 'Registered Tournaments',
    navigator: null,
  ),
  Option(
    iconData: Icons.video_library,
    title: 'Watch and Earn',
    navigator: null,
  ),
  Option(
    iconData: Icons.bookmark,
    title: 'Saved Tournaments',
    navigator: null,
  ),
  Option(
    iconData: Icons.logout,
    title: 'Log Out',
    navigator: null,
  ),
];
