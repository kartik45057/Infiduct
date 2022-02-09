import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/painting.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StyledImage extends StatefulWidget {
  var imageUrl;
  StyledImage(this.imageUrl);

  @override
  _StyledImageState createState() => _StyledImageState();
}

class _StyledImageState extends State<StyledImage> {

  int activeIndex= 0;
  Widget buildIndicator() => Padding(
    padding: const EdgeInsets.only(bottom:8.0),
    child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.imageUrl.length,
      effect: SwapEffect(
        dotColor: Colors.blue,
        activeDotColor: Colors.white,
        dotHeight: 13,
          dotWidth: 13

      ),

    ),
  );

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
          color: Colors.black12
      ),
      child: Column(
        children: [
          Expanded(
            flex:9,
            child: CarouselSlider.builder(

              options: CarouselOptions(
                  height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight) *0.6,
                autoPlay: true,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index , reason){
                    setState(() {
                      activeIndex = index;
                    });
                }
              ),
              itemCount: widget.imageUrl.length,
              itemBuilder: (context , index , realindex){
                return Container(margin: EdgeInsets.symmetric(vertical: 30),
                  //width:300,
                  color: Colors.grey,
                  child: Image.network(
                    widget.imageUrl[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          Expanded(
          flex: 1,
          child: buildIndicator()
          ),
        ],
      ),
    );
  }
}
