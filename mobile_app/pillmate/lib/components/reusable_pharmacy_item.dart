import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/pages/google_map.dart';

class ReusablePharmacyItem extends StatelessWidget {
  final Map<String, String> pharmacy;
  final bool editFontsize;
  final int change;
  const ReusablePharmacyItem({super.key, required this.pharmacy, required this.editFontsize, required this.change});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
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
                          fontFamily: 'PlexSansThaiRg'
                      ),
                    ),
                    SizedBox(height: 4,),
                    Text(
                      pharmacy['province']! + ', ' + pharmacy['city']!,
                      style: TextStyle(
                          fontSize: editFontsize ?  11.5 + change.toDouble() : 11.5,
                          fontFamily: 'PlexSansThaiRg',
                          color: Color(0xff8B8B8B)
                      ),
                    ),
                    SizedBox(height: 4,),
                    Text(
                      'เปิดอยู่ ' + pharmacy['serviceTime']!,
                      style: TextStyle(
                          fontSize: editFontsize ?  11.5 + change.toDouble() : 11.5,
                          fontFamily: 'PlexSansThaiRg'
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth*0.025,
              ),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapPage(pharmacy: pharmacy,)));
                  },
                  child:Column(
                    children: [

                      CircleAvatar(
                        backgroundColor: Color(0xffE9E9E9),
                        radius: 17,
                        child: Container( width: 25,child: Image.asset('icons/direction.png')),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        'เส้นทาง',
                        style: TextStyle(
                            fontSize: editFontsize ?  12 + change.toDouble() : 12,
                            fontFamily: 'PlexSansThaiRg'
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
        Container(
          width: screenWidth,
          height: 1,
          color: Color(0xffE3E3E3),
        ),
      ],
    );
  }
}
