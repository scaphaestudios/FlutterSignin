import 'package:flutter/material.dart';
import 'dart:math';

class GuillotineMenu extends StatefulWidget {
  @override
  _GuillotineMenuState createState() => _GuillotineMenuState();
}

class _GuillotineMenuState extends State<GuillotineMenu>
    with SingleTickerProviderStateMixin {
  AnimationController animationControllerMenu;
  Animation<double> animationMenu;
  Animation<double> animationTitleFadeInOut;
  _GuillotineAnimationStatus menuAnimationStatus;
  var _color =Colors.transparent;

  final List<Map> _menus = <Map>[
    {
      "icon": Icons.person,
      "title": "profile",
      "color": Colors.white,
    },
    {
      "icon": Icons.view_agenda,
      "title": "feed",
      "color": Colors.white,
    },
    {
      "icon": Icons.swap_calls,
      "title": "activity",
      "color": Colors.cyan,
    },
    {
      "icon": Icons.settings,
      "title": "settings",
      "color": Colors.white,
    },
  ];

  @override
  void initState() {
    super.initState();
    menuAnimationStatus = _GuillotineAnimationStatus.closed;

    ///
    /// Initialization of the animation controller
    ///
    animationControllerMenu = new AnimationController(
        duration: const Duration(
          milliseconds: 100,
        ),
        vsync: this)
      ..addListener(() {});

    ///
    /// Initialization of the menu appearance animation
    ///
    animationMenu =
        new Tween(begin: -pi / 2.0, end: 0.0).animate(new CurvedAnimation(
      parent: animationControllerMenu,
      curve: Curves.bounceInOut,
      reverseCurve: Curves.bounceInOut,
    ))
          ..addListener(() {
            setState(() {
              // force refresh
            });
          })
          ..addStatusListener((AnimationStatus status) {
           
            if (status == AnimationStatus.completed) {
        
              menuAnimationStatus = _GuillotineAnimationStatus.open;
            } else if (status == AnimationStatus.dismissed) {
               _color = Colors.transparent;
              menuAnimationStatus = _GuillotineAnimationStatus.closed;
            } else {
              menuAnimationStatus = _GuillotineAnimationStatus.animating;
                     _color=Colors.black87;
            }
          });

    ///
    /// Initialization of the menu title fade out/in animation
    ///
    animationTitleFadeInOut =
        new Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
      parent: animationControllerMenu,
      curve: new Interval(
        0.0,
        0.5,
        curve: Curves.ease,
      ),
    ));
  }

  @override
  void dispose() {
    animationControllerMenu.dispose();
    super.dispose();
  }

  ///
  /// Play the animation in the direction that depends on the current menu status
  ///
     void _playAnimation() {
      
    try {
      if (menuAnimationStatus == _GuillotineAnimationStatus.animating) {
        // During the animation, do not do anything
      } else if (menuAnimationStatus == _GuillotineAnimationStatus.closed) {
        animationControllerMenu.forward().orCancel;
      } else {
        animationControllerMenu.reverse().orCancel;
      }
    } on TickerCanceled {
      // the animation go cancelled, probably because disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    double angle = animationMenu.value;

    return new Transform.rotate(
      angle: -angle,
      origin: new Offset(screenWidth- screenWidth/1.10, screenHeight - screenHeight/20),
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.transparent,
        child: Container(
          
          width: screenWidth,
          height: screenHeight,
          color: _color,
          child: new Stack(
            children: <Widget>[
              ///
              /// Menu title
              ///
              new Positioned(
                bottom: 42.0,
                left: 20.0,
                width: screenWidth,
                height: 24.0,
                child: new Transform.rotate(
                    alignment: Alignment.topLeft,
                    origin: Offset.zero,
                    angle: pi / 2.0,
                    child: new Center(
                      child: new Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: new Opacity(
                          opacity: animationTitleFadeInOut.value,
                          child: new Text('ACTIVITY',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              )),
                        ),
                      ),
                    )),
              ),

              ///
              /// Hamburger icon
              ///
              new Positioned(
                bottom: 12.0,
                left: 10.0,
                child: new IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: _playAnimation,
                ),
              ),

  ///
              
              ///
              /// Menu content
              ///
              new Padding(
                padding: const EdgeInsets.only(left: 64.0, top: 96.0),
                child: new Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _menus.map((menuItem) {
                      return new ListTile(
                        leading: new Icon(
                          menuItem["icon"],
                          color: menuItem["color"],
                        ),
                        title: RaisedButton(
                          onPressed: () {
                            _playAnimation();
                          },
                          child: new Text(
                            menuItem["title"],
                            style: new TextStyle(
                                color: menuItem["color"], fontSize: 24.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// Menu animation status
///
enum _GuillotineAnimationStatus { closed, open, animating }
