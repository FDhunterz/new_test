import 'package:floweradvisor/controller/movie/detail_controller.dart';
import 'package:floweradvisor/controller/movie/favourite_controller.dart';
import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/materialx/button.dart';
import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DetailController.state;
    final data = controller.selectedData!;
    controller.renderDataShow();
    return Scaffold(
      body: StatefulBuilder(
        builder: (context,s) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          image: controller.selectedData!.poster == 'N/A' ? null : DecorationImage(image: NetworkImage(controller.selectedData!.poster!,),fit: BoxFit.cover,opacity: 0.05), 
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -1,
                      child: Container(
                        height: 70,
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(colors: [const Color(0xff1c1b1f),const Color(0xff1c1b1f).withOpacity(0.4),const Color(0xff1c1b1f).withOpacity(0)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Column(
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
                              SizedBox(width: 200,
                                child: Text(controller.selectedData!.title ?? '',overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                              ),
                               NoSplashButton(
                                onTap: () async {
                                  MainController.state.start();
                                  await FavouriteController.state.save(data);
                                  s((){});
                                  MainController.state.end();
                                },
                                 child: SizedBox(
                                    width: 30,
                                    child: FavouriteController.state.isFavourite(data) ? const Icon( Icons.favorite,color: Colors.red,) : const Icon( Icons.favorite_border),
                                  ),
                               ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Center(
                          child:  Container(
                            width: 200,
                            height: 280,
                            decoration: BoxDecoration(
                              image: controller.selectedData!.poster == 'N/A' ? null : DecorationImage(image: NetworkImage(controller.selectedData!.poster!,),fit: BoxFit.cover), 
                            ),
                          ),
                        ),
                        const SizedBox(height: 12,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data.year ?? ''),
                            const Text(' | '),
                            Text(data.runtime ?? ''),
                            const Text(' | '),
                            Text(data.type ?? ''),
                          ],
                        ),
                        const SizedBox(height: 60,),
                        
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(data.plot ?? ''),
                        const SizedBox(height: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.dataShow.map((e) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom:8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [ 
                                  Text(e['title'],style: const TextStyle(fontWeight: FontWeight.w700),),
                                  Text(e['value'] ?? ''),
                                ],
                              ),
                            );
                        }).toList(),
                        ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}