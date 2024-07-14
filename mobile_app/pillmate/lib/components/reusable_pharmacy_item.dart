import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/pages/google_map.dart';

import '../constants/constants.dart';

class ReusablePharmacyItem extends StatelessWidget {
  final Map<String, String> pharmacy;
  final bool editFontsize;
  final int change;
  final bool darkMode;

  const ReusablePharmacyItem({super.key, required this.pharmacy, required this.editFontsize, required this.change, required this.darkMode});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapPage(pharmacy: pharmacy,)));
      },
      child: Container(
        color: !darkMode ? Colors.white: kBlackDarkMode,
        child: Column(

          children: [

            Padding(

              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04, vertical: 20),

              child: Row(
                children: [
                  Container(
                    height: screenWidth * 0.2,
                    child: Image.asset('images/phar1.png'),
                  ),
                  SizedBox(
                    width: screenWidth*0.04,
                  ),
                  Container(
                    width: screenWidth*0.47,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacy['storeName']!,
                          style: TextStyle(
                              fontSize: editFontsize ?  13 + change.toDouble() : 13,
                              fontFamily: !darkMode ? 'PlexSansThaiRg': 'PlexSansThaiSm',
                            color: !darkMode ? Colors.black: Colors.white,

                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          pharmacy['province']! + ', ' + pharmacy['city']!,
                          style: TextStyle(
                              fontSize: editFontsize ?  11.5 + change.toDouble() : 11.5,
                              fontFamily: 'PlexSansThaiRg',
                            color: !darkMode ? Colors.black: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4,),
                        Text(
                          'เปิดอยู่ ' + pharmacy['serviceTime']!,
                          style: TextStyle(
                              fontSize: editFontsize ?  11.5 + change.toDouble() : 11.5,
                              fontFamily: 'PlexSansThaiRg',
                            color: !darkMode ? Colors.black: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(

                    width: screenWidth*0.025,

                  ),
                  Column(
                    children: [

                      CircleAvatar(
                        backgroundColor:  !darkMode ? Color(0xffE9E9E9): Color(0xff8B8B8B),
                        radius: 18,
                        child: Container( child: !darkMode ? Image.asset('icons/ri_direction-fill.png') : Image.asset('icons/ri_direction-fill_dark.png') ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        'เส้นทาง',
                        style: TextStyle(
                            fontSize: editFontsize ?  12 + change.toDouble() : 12,
                            fontFamily: 'PlexSansThaiRg',
                          color: !darkMode ? Colors.black: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth,
              height: 1,
              color:  !darkMode ? Color(0xffE7E7E7): Color(0xff8B8B8B),
            ),
          ],
        ),
      ),
    );
  }
}
