import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/components/reusable_bottom_icon.dart';
import 'package:ionicons/ionicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constants.dart';
class ReusableBottomNavigationBar extends StatelessWidget {
  final bool? isLoggedIn;
  final String page;
  final bool darkMode;
  const ReusableBottomNavigationBar({super.key, this.isLoggedIn, required this.page, required this.darkMode});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BottomAppBar(
      notchMargin: 5,
      shape: CircularNotchedRectangle(),
      color: !darkMode ? Colors.white: Color(0xff3f3f3f),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width:  screenWidth*0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/homepage');
                    },
                    child: page == 'homepage' ? BottomIcon(
                      image: Image.asset(
                          !darkMode ? 'icons/solar_home-2-outline.png': 'icons/solar_home-2-outline-light-green.png'),
                      label: 'โฮมเพจ',
                      fontColor: !darkMode ? Color(0xff059E78): Color(0xff94DDB5),
                    ): BottomIcon(
                      image: Image.asset(
                          !darkMode ? 'icons/solar_home-2-outline-grey.png': 'icons/solar_home-2-outline-white.png'),
                      label: 'โฮมเพจ',
                      fontColor: !darkMode ? Color(0xff8B8B8B): Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(isLoggedIn!){
                        Navigator.pushNamed(context, '/my-drug-list');
                      }
                      else{
                        Navigator.pushNamed(context, '/log-in');
                      }
                    },
                    child: page == 'drugList' ? BottomIcon(
                      image: Image.asset(
                          !darkMode ?'icons/Vector-green.png': 'icons/healthicons_medicines-outline-light-green.png'),
                      label: 'ยาของฉัน',
                      fontColor: !darkMode ? Color(0xff059E78): Color(0xff94DDB5),
                    ): BottomIcon(
                      image: Image.asset(
                          !darkMode ? 'icons/healthicons_medicines-outline.png': 'icons/healthicons_medicines-outline-white.png'),
                      label: 'ยาของฉัน',
                      fontColor: !darkMode ? Color(0xff8B8B8B): Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth*0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/search-pharmacy');
                    },
                    child:page == 'searchPharmacy' ? BottomIcon(
                      fontColor: !darkMode ? Color(0xff059E78): Color(0xff94DDB5),
                      image: Image.asset(
                          !darkMode ? 'icons/search-green.png': 'icons/search-light-green.png'),
                      label: 'ค้นหาร้านยา',
                    ): BottomIcon(
                      fontColor: !darkMode ? Color(0xff8B8B8B): Colors.white,
                      image: Image.asset(
                          !darkMode ? 'icons/search-normal.png': 'icons/search-white.png'),
                      label: 'ค้นหาร้านยา',
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/profile');
                    },
                    child:page == 'profile' ?  BottomIcon(
                      fontColor: !darkMode ? Color(0xff059E78): Color(0xff94DDB5),
                      image: Image.asset(
                          !darkMode ? 'icons/user-greenn.png': 'icons/user-light-green.png'),
                      label: 'โปรไฟล์',
                    ): BottomIcon(
                      fontColor: !darkMode ? Color(0xff8B8B8B): Colors.white,
                      image: Image.asset(
                          !darkMode ? 'icons/user.png': 'icons/user-white.png'),
                      label: 'โปรไฟล์',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}