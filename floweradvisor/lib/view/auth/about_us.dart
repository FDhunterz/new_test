import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: const Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(),
            Text('Faizal Triswanto',style: TextStyle(fontWeight: FontWeight.w700),),
            Text('27-02-2024'),
            Text('18:00'),
            SizedBox(height: 50,),
            
            Text('Library',style: TextStyle(fontWeight: FontWeight.w700),),
            Text('flutter_middleware'),
            Text('request_api_helper'),
            Text('flutter_feather_icons'),
            Text('sql_query'),
            Text('flutter_localizations'),
          ],
        ),
      ),
    );
  }
}