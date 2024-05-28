import 'package:flutter/material.dart';
import 'package:camshot/config/app_routes_old.dart';
import 'package:camshot/config/image_assets.dart';

class Start_Page extends StatelessWidget {
  const Start_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Spacer(),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Image(
                      image: AssetImage(AppImages.first_page),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.login),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'google',
                          fontWeight: FontWeight.bold),
                    )),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
