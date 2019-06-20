import 'custom_button.dart';
import 'sign_up_page.dart';
import 'sign_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _backgroundAnimation;
  String _image =  'lib/resources/images/background.png';

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));

    _backgroundAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
            
              _animationController.reset();
              _animationController.forward();
            }
          });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleOnPressedSignUp() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (context, anim1, anim2) => SignUpPage()),
    );
  }
   void _handleOnPressedSignIn() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (context, anim1, anim2) => SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Image.asset(
           _image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(_backgroundAnimation.value, 0),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: 
                      Center(
                        
                                              child: Image.asset(
                          'lib/resources/images/logo.png',
                          width: 120,
                          height: 120,
                        ),
                      )
            
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  child: Text(
                    'Megga!!',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -2,
                      color: Colors.white,
                    ),
                  ),
                ),
               SizedBox(height: 55,),
                CustomButton(
                  text: 'Sign Up',
                  highlight: true,
                  onPressed: _handleOnPressedSignUp,
                ),
                SizedBox(height: 16),
                CustomButton(text: 'Log in',
                 highlight: true,
                  onPressed: _handleOnPressedSignIn,
                ),
                SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () => {},
                  child: Text(
                    'Copyright © Scaphaestudios 2019',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
               
              ],
            ),
          )
        ],
      ),
    );
  }
}
