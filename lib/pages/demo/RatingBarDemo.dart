
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarDemo extends StatefulWidget {

  final String? title;

  RatingBarDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _RatingBarDemoState createState() => _RatingBarDemoState();
}

class _RatingBarDemoState extends State<RatingBarDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: [
            _buildBar(),
            Divider(),
            _buildBar1(),
            Divider(),
            _buildBar2(),
          ],
        )
    );
  }

  _buildBar() {
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  _buildBar1() {
    return RatingBar(
      initialRating: 3,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: _image('images/icon_heart.png'),
        half: _image('images/icon_heart_half.png'),
        empty: _image('images/icon_heart_border.png'),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }
  _buildBar2() {
    return RatingBar.builder(
      initialRating: 3,
      itemCount: 5,
      itemBuilder: (context, index) => itemMap['${index}'],
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: Colors.amber,
    );
  }

  Map<String, dynamic> itemMap = {
  "0": Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, ),
  "1": Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent, ),
  "2": Icon(Icons.sentiment_neutral, color: Colors.amber, ),
  "3": Icon(Icons.sentiment_satisfied, color: Colors.lightGreen, ),
  "4": Icon(Icons.sentiment_very_satisfied, color: Colors.green, )
  };
}