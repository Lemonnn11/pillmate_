import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/components/reusable_bottom_icon.dart';
import 'package:ionicons/ionicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constants.dart';
class ReusableBottomNavigationBar extends StatelessWidget {
  final bool? isLoggedIn;

  const ReusableBottomNavigationBar({super.key, this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return BottomAppBar(
      notchMargin: 5,
      shape: CircularNotchedRectangle(),
      color: Colors.white,
      child: Container(
        height: 65,
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
                    child: BottomIcon(
                      image: Image.asset(
                          'icons/solar_home-2-outline.png'),
                      label: 'โฮมเพจ',
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
                    child: BottomIcon(
                      image: Image.asset(
                          'icons/healthicons_medicines-outline.png'),
                      label: 'ยาของฉัน',
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
                    child: BottomIcon(
                      image: Image.asset(
                          'icons/search-normal.png'),
                      label: 'ค้นหาร้านยา',
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: BottomIcon(
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
