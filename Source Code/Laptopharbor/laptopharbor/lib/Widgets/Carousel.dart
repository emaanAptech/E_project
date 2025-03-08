import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MyCarousel extends StatelessWidget {
  final List<String> carouselImages;
  final bool? autoPlay;
  final double? viewportFraction;
  final int? autoPlayInterval;
  final double? elementHeight;

  const MyCarousel(
      {super.key,
      required this.carouselImages,
      this.autoPlay,
      this.viewportFraction,
      this.autoPlayInterval,
      this.elementHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          
          CarouselSlider(
              items: carouselImages.map((e) => Image.network(e)).toList(),
              
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 0.99,
                aspectRatio: 14 / 9,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 3),
                height: MediaQuery.of(context).size.height * 0.5,
              )),
              const SizedBox(height: 20),
             const Divider(color: Colors.black, thickness: 1),
             const SizedBox(height: 40),
        ],
        
      ),
    );
  }
}
