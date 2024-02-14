import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/components/reusable_bottom_icon.dart';
import 'package:ionicons/ionicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constants.dart';
class ReusableBottomNavigationBar extends StatelessWidget {
  final bool? isLoggedIn;
  final String page;
  const ReusableBottomNavigationBar({super.key, this.isLoggedIn, required this.page});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BottomAppBar(
      notchMargin: 5,
      shape: CircularNotchedRectangle(),
      color: Colors.white,
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
                          'icons/solar_home-2-outline.png'),
                      label: 'โฮมเพจ',
                      fontColor: Color(0xff059E78),
                    ): BottomIcon(
                      image: Image.asset(
                          'icons/solar_home-2-outline-grey.png'),
                      label: 'โฮมเพจ',
                      fontColor: Color(0xff8B8B8B),
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
                          'icons/Vector-green.png'),
                      label: 'ยาของฉัน',
                      fontColor: Color(0xff059E78),
                    ): BottomIcon(
                      image: Image.asset(
                          'icons/healthicons_medicines-outline.png'),
                      label: 'ยาของฉัน',
                      fontColor: Color(0xff8B8B8B),
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
                      fontColor: Color(0xff059E78),
                      image: Image.asset(
                          'icons/search-green.png'),
                      label: 'ค้นหาร้านยา',
                    ): BottomIcon(
                      fontColor: Color(0xff8B8B8B),
                      image: Image.asset(
                          'icons/search-normal.png'),
                      label: 'ค้นหาร้านยา',
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/profile');
                    },
                    child:page == 'profile' ?  BottomIcon(
                      fontColor: Color(0xff059E78),
                      image: Image.asset(
                          'icons/user-greenn.png'),
                      label: 'โปรไฟล์',
                    ): BottomIcon(
                      fontColor: Color(0xff8B8B8B),
                      image: Image.asset(
                          'icons/user.png'),
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