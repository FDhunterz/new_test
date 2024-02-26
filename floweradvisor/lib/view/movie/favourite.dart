import 'package:floweradvisor/controller/movie/detail_controller.dart';
import 'package:floweradvisor/controller/movie/favourite_controller.dart';
import 'package:floweradvisor/materialx/button.dart';
import 'package:flutter/material.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouriteController.state;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NoSplashButton(
                  onTap: ()=> Navigator.pop(context),
                  child: const SizedBox(width: 30,
                    child: Icon(Icons.chevron_left),
                  ),
                ),
                const SizedBox(width: 200,
                  child: Text( 'Favourite',overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                ),
                const SizedBox(width: 30,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: controller.data.isEmpty ? Center(
              child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('asset/no-data.gif',width: 50,),
                        const SizedBox(height: 12,),
                        const Text('No Data'),
                      ],
                    ),
            ) : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),                
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:20.0),
                      child: Wrap(
                        children: controller.data.map((e) {
                          final getIndex =  controller.data.indexOf(e) ;
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * .5,
                            child: Padding(
                              padding: EdgeInsets.only(left: getIndex % 2 == 0 ? 12: 0, right: getIndex % 2 == 1 ? 12: 0),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: (){
                                    DetailController.state.route(e,haveAllData: e);
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 300,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          image:  DecorationImage(
                                            image: NetworkImage( e.poster == null || e.poster == 'N/A' ?'https://static.thenounproject.com/png/2932881-200.png' : e.poster!),
                                            fit: e.poster == null || e.poster == 'N/A' ? BoxFit.contain :BoxFit.cover,
                                            invertColors: e.poster == null || e.poster == 'N/A' ? true : false,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4,),
                                      Text(
                                        e.title ?? '',maxLines: 2,overflow: TextOverflow.ellipsis,
                                        style:const  TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        e.type ?? '',
                                        style:const  TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
          )
        ],
      ),
    );
  }
}