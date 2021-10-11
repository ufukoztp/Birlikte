import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:birlikte_app/widget/textStroke.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

import 'package:image/image.dart' as image;

// make statefull widget for testing
class SlidePuzzle extends StatefulWidget {
  SlidePuzzle({Key? key,required this.image}) : super(key: key);
  final String image;

  @override
  _SlidePuzzleState createState() => _SlidePuzzleState();
}

class _SlidePuzzleState extends State<SlidePuzzle> {
  // default put 2
  int valueSlider = 3;
  GlobalKey<_SlidePuzzleWidgetState> globalKey = GlobalKey();
  bool loadBanner=false;


  late final BannerAd myBanner;

  late final AdWidget adWidget;


  @override
  void initState() {
    // TODO: implement initState

    if(Platform.isAndroid){
      myBanner = BannerAd(
        adUnitId: 'ca-app-pub-9790530714505384/3149783346',
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(),
      );

    }else{
      myBanner = BannerAd(
        adUnitId: 'ca-app-pub-9790530714505384/3078528941',
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(),
      );

    }


    final BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );

    myBanner.load().then((value) {
      adWidget = AdWidget(ad: myBanner);
      setState(() {
        loadBanner=true;
      });
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double border = 5;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: loadBanner==true?Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.green[100],
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height:3.w),
              Row(
                children: [
                  InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.chevron_left,size: 10.w,))
                ],
              ),
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(width: border),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.biggest.width,
                      // comment of this so our box can extends height
                      // height: constraints.biggest.width,

                      // if setup decoration,color must put inside
                      // make puzzle widget
                      child: SlidePuzzleWidget(
                        key: globalKey,
                        size: constraints.biggest,
                        // set size puzzle
                        sizePuzzle: valueSlider,
                        imageBckGround: Image(
                          // u can use your own image
                          image: NetworkImage(widget.image),
                        ),
                      ),
                    );
                  },
                ),
                // child: ,
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
            alignment: Alignment.center,
            child: adWidget,
            width: myBanner.size.width.toDouble(),
            height: myBanner.size.height.toDouble(),
          ),
              )

            ],
          ),
        ),
      ):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Center(child: CircularProgressIndicator(),)
      ],)
    );
  }
}

// statefull widget
class SlidePuzzleWidget extends StatefulWidget {
  Size? size;
  // set inner padding
  double innerPadding;
  // set image use for background
  Image? imageBckGround;
  int? sizePuzzle;
  SlidePuzzleWidget({
    Key? key,
    this.size,
    this.innerPadding = 5,
    this.imageBckGround,
    this.sizePuzzle,
  }) : super(key: key);

  @override
  _SlidePuzzleWidgetState createState() => _SlidePuzzleWidgetState();
}

class _SlidePuzzleWidgetState extends State<SlidePuzzleWidget> {
  GlobalKey _globalKey = GlobalKey();
  Size? size;

  // list array slide objects
  List<SlideObject>? slideObjects;
  // image load with renderer
  image.Image? fullImage;
  // success flag
  bool success = false;
  // flag already start slide
  bool startSlide = false;
  // save current swap process for reverse checking
  List<int>? process;
  // flag finish swap
  bool finishSwap = false;

  @override
  Widget build(BuildContext context) {
    size = Size(widget.size!.width - widget.innerPadding * 2,
        widget.size!.width - widget.innerPadding);

    return Column(
      mainAxisSize: MainAxisSize.min,
      // let make ui
      children: [
        // make 2 column, 1 for puzzle box, 2nd for button testing
        Container(
          decoration: BoxDecoration(color: Colors.white),
          width: widget.size!.width,
          height: widget.size!.width,
          padding: EdgeInsets.all(widget.innerPadding),
          child: Stack(
            children: [
              // we use stack stack our background & puzzle box
              // 1st show image use

              if (widget.imageBckGround != null && slideObjects == null) ...[
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.red,
                    height: double.maxFinite,
                    child: widget.imageBckGround,
                  ),
                )
              ],
              // 2nd show puzzle with empty
              if (slideObjects != null)
                ...slideObjects!.where((slideObject) => slideObject.empty!).map(
                      (slideObject) {
                    return Positioned(
                      left: slideObject.posCurrent!.dx,
                      top: slideObject.posCurrent!.dy,
                      child: SizedBox(
                        width: slideObject.size!.width,
                        height: slideObject.size!.height,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(2),
                          color: Colors.white24,
                          child: Stack(
                            children: [
                              if (slideObject.image != null) ...[
                                Opacity(
                                  opacity: success ? 1 : 0.3,
                                  child: slideObject.image,
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              // this for box with not empty flag
              if (slideObjects != null)
                ...slideObjects!.where((slideObject) => !slideObject.empty!).map(
                      (slideObject) {
                    // change to animated position
                    // disabled checking success on swap process
                    return AnimatedPositioned(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease,
                      left: slideObject.posCurrent!.dx,
                      top: slideObject.posCurrent!.dy,
                      child: GestureDetector(
                        onTap: () => changePos(slideObject.indexCurrent!),
                        child: SizedBox(
                          width: slideObject.size!.width,
                          height: slideObject.size!.height,
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(2),
                            color: Colors.blue,
                            child: Stack(
                              children: [
                                if (slideObject.image != null) ...[
                                  slideObject.image!
                                ],
                                Center(
                                  child: TextWidget(
                                    "${slideObject.indexDefault}",
                                    color: Color(0xff225f87),
                                    strokeColor: Colors.white,
                                    strokeWidth: 8,
                                    fontFamily: "KidZone",
                                    fontSize: 40,
                                    overrideSizeStroke: false, shadow: [],
                                  ),
                                ),

                                // nice one.. lets make it random
                              ],
                            ),
                            // nice one
                          ),
                        ),
                      ),
                    );
                  },
                ).toList()

              // now not show at all because we dont generate slideObjects yet.. lets generate
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // u can use any button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => generatePuzzle(),
                  child: Text("Generate"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  // for checking purpose
                  onPressed: startSlide ? null : () => reversePuzzle(),
                  child: Text("Reverse"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => clearPuzzle(),
                  child: Text("Clear"),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // setup method use

  // get render image
  // same as jigsaw puzzle method before

  _getImageFromWidget() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();

    return image.decodeImage(pngBytes);
  }

  // method to generate our puzzle
  generatePuzzle() async {
    // dclare our array puzzle
    finishSwap = false;
    setState(() {});
    // 1st load render image to crop, we need load just once
    if (widget.imageBckGround != null && this.fullImage == null)
      this.fullImage = await _getImageFromWidget();

    print(this.fullImage!.width);
    // ok nice..full image loaded

    // calculate box size for each puzzle
    Size sizeBox =
    Size(size!.width / widget.sizePuzzle!, size!.width / widget.sizePuzzle!);

    // let proceed with generate box puzzle
    // power of 2 because we need generate row & column same number
    slideObjects =
        List.generate(widget.sizePuzzle! * widget.sizePuzzle!, (index) {
          // we need setup offset 1st
          Offset offsetTemp = Offset(
            index % widget.sizePuzzle! * sizeBox.width,
            index ~/ widget.sizePuzzle! * sizeBox.height,
          );

          // set image crop for nice effect, check also if image is null
          image.Image? tempCrop;
          if (widget.imageBckGround != null && this.fullImage != null)
            tempCrop = image.copyCrop(
              fullImage!,
              offsetTemp.dx.round(),
              offsetTemp.dy.round(),
              sizeBox.width.round(),
              sizeBox.height.round(),
            );

          return SlideObject(
            posCurrent: offsetTemp,
            posDefault: offsetTemp,
            indexCurrent: index,
            indexDefault: index + 1,
            size: sizeBox,
            image: tempCrop == null
                ? null
                : Image.memory(image.encodePng(tempCrop) as Uint8List,fit: BoxFit.contain,
            ),
          );
        }); //let set empty on last child

    slideObjects!.last.empty = true;

    // make random.. im using smple method..just rndom with move it.. haha

    // setup moveMethod 1st
    // proceed with swap block place
    // swap true - we swap horizontal line.. false - vertical
    bool swap = true;
    process = [];

    // 20 * size puzzle shuffle
    for (var i = 0; i < widget.sizePuzzle! * 20; i++) {
      for (var j = 0; j < widget.sizePuzzle! / 2; j++) {
        SlideObject slideObjectEmpty = getEmptyObject();

        // get index of empty slide object
        int? emptyIndex = slideObjectEmpty.indexCurrent;
        process!.add(emptyIndex!);
        int randKey;

        if (swap) {
          // horizontal swap
          int row = emptyIndex ~/ widget.sizePuzzle!;
          randKey =
              row * widget.sizePuzzle! + new Random().nextInt(widget.sizePuzzle!);
        } else {
          int col = emptyIndex % widget.sizePuzzle!;
          randKey =
              widget.sizePuzzle! * new Random().nextInt(widget.sizePuzzle!) + col;
        }

        // call change pos method we create before to swap place

        changePos(randKey);
        // ops forgot to swap
        // hmm bug.. :).. let move 1st with click..check whther bug on swap or change pos
        swap = !swap;
      }
    }

    startSlide = false;
    finishSwap = true;
    setState(() {});
  }
  // eyay.. end

  // get empty slide object from list
  SlideObject getEmptyObject() {
    return slideObjects!.firstWhere((element) => element.empty as bool);
  }

  changePos(int indexCurrent) {
    // problem here i think..
    SlideObject slideObjectEmpty = getEmptyObject();

    // get index of empty slide object
    int? emptyIndex = slideObjectEmpty.indexCurrent;

    // min & max index based on vertical or horizontal

    int minIndex = min(indexCurrent, emptyIndex!);
    int maxIndex = max(indexCurrent, emptyIndex);

    // temp list moves involves
    List<SlideObject> rangeMoves = [];

    // check if index current from vertical / horizontal line
    if (indexCurrent % widget.sizePuzzle! == emptyIndex % widget.sizePuzzle!) {
      // same vertical line
      rangeMoves = slideObjects!
          .where((element) =>
      element.indexCurrent! % widget.sizePuzzle! ==
          indexCurrent % widget.sizePuzzle!)
          .toList();
    } else if (indexCurrent ~/ widget.sizePuzzle! ==
        emptyIndex ~/ widget.sizePuzzle!) {
      rangeMoves = slideObjects!;
    } else {
      rangeMoves = [];
    }

    rangeMoves = rangeMoves
        .where((puzzle) =>
    puzzle.indexCurrent! >= minIndex &&
        puzzle.indexCurrent! <= maxIndex &&
        puzzle.indexCurrent != emptyIndex)
        .toList();

    // check empty index under or above current touch
    if (emptyIndex < indexCurrent)
      rangeMoves.sort((a, b) => a.indexCurrent! < b.indexCurrent!.toInt() ? 1 : 0);
    else
      rangeMoves.sort((a, b) => a.indexCurrent! < b.indexCurrent!.toInt() ? 0 : 1);

    // check if rangeMOves is exist,, then proceed switch position
    if (rangeMoves.length > 0) {
      int? tempIndex = rangeMoves[0].indexCurrent;

      Offset? tempPos = rangeMoves[0].posCurrent;

      // yeayy.. sorry my mistake.. :)
      for (var i = 0; i < rangeMoves.length - 1; i++) {
        rangeMoves[i].indexCurrent = rangeMoves[i + 1].indexCurrent;
        rangeMoves[i].posCurrent = rangeMoves[i + 1].posCurrent;
      }

      rangeMoves.last.indexCurrent = slideObjectEmpty.indexCurrent;
      rangeMoves.last.posCurrent = slideObjectEmpty.posCurrent;

      // haha ..i forget to setup pos for empty puzzle box.. :p
      slideObjectEmpty.indexCurrent = tempIndex;
      slideObjectEmpty.posCurrent = tempPos;
    }

    // this to check if all puzzle box already in default place.. can set callback for success later
    if (slideObjects!
        .where((slideObject) =>
    slideObject.indexCurrent == slideObject.indexDefault! - 1)
        .length ==
        slideObjects!.length &&
        finishSwap) {
      print("Success");
      success = true;
      Navigator.of(context).pop(success );
    } else {
      success = false;
    }

    startSlide = true;
    setState(() {});
  }

  clearPuzzle() {
    setState(() {
      // checking already slide for reverse purpose
      startSlide = true;
      slideObjects!.clear();
      finishSwap = true;
    });
  }

  reversePuzzle() async {
    startSlide = true;
    finishSwap = true;
    setState(() {});

    await Stream.fromIterable(process!.reversed)
        .asyncMap((event) async =>
    await Future.delayed(Duration(milliseconds: 50))
        .then((value) => changePos(event)))
        .toList();

    // yeayy
    process = [];
    setState(() {});
  }
}

// lets start class use
class SlideObject {
  // setup offset for default / current position
  Offset? posDefault;
  Offset? posCurrent;
  // setup index for default / current position
  int? indexDefault;
  int? indexCurrent;
  // status box is empty
  bool? empty;
  // size each box
  Size? size;
  // Image field for crop later
  Image? image;

  SlideObject({
    this.empty = false,
    this.image,
    this.indexCurrent,
    this.indexDefault,
    this.posCurrent,
    this.posDefault,
    this.size,
  });
}
