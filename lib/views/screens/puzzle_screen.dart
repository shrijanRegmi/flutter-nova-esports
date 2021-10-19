import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:image/image.dart' as image;
import 'package:peaman/models/app_models/level_model.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/filled_btn.dart';
import 'package:provider/provider.dart';

// make statefull widget for testing
class PuzzleScreen extends StatefulWidget {
  final Level level;
  PuzzleScreen(
    this.level, {
    Key key,
  }) : super(key: key);

  @override
  _PuzzleScreenState createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  // default put 2
  int _difficultyValue = 2;
  GlobalKey<_SlidePuzzleWidgetState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    setState(() {
      _difficultyValue = widget.level.difficulty;
    });
  }

  @override
  Widget build(BuildContext context) {
    double border = 5;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CommonAppbar(
          title: Text(
            'Level ${widget.level.level}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Color(0xff3D4A5A),
            ),
          ),
        ),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xff3D4A5A),
                  border: Border.all(width: border, color: Colors.green[600]),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: constraints.biggest.width,
                      child: SlidePuzzleWidget(
                        key: globalKey,
                        size: constraints.biggest,
                        sizePuzzle: _difficultyValue,
                        level: widget.level,
                      ),
                    );
                  },
                ),
                // child: ,
              ),
              SizedBox(
                height: 50.0,
              ),
              // Container(
              //   child: Slider(
              //     min: 2,
              //     max: 15,
              //     divisions: 13,
              //     label: "${_difficultyValue.toString()}",
              //     value: _difficultyValue.toDouble(),
              //     onChanged: (value) {
              //       setState(
              //         () {
              //           _difficultyValue = value.toInt();
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// statefull widget
class SlidePuzzleWidget extends StatefulWidget {
  final Size size;
  final double innerPadding;
  final int sizePuzzle;
  final Level level;
  SlidePuzzleWidget({
    Key key,
    this.size,
    this.innerPadding = 5,
    this.sizePuzzle,
    this.level,
  }) : super(key: key);

  @override
  _SlidePuzzleWidgetState createState() => _SlidePuzzleWidgetState();
}

class _SlidePuzzleWidgetState extends State<SlidePuzzleWidget> {
  CachedNetworkImageProvider _img;

  @override
  void initState() {
    super.initState();
    _img = CachedNetworkImageProvider(
      widget.level.imgUrl,
    );

    _img.resolve(new ImageConfiguration()).addListener(
      ImageStreamListener((info, call) {
        Future.delayed(
          Duration(milliseconds: 1000),
          () {
            generatePuzzle();
          },
        );
      }),
    );
  }

  GlobalKey _globalKey = GlobalKey();
  Size size;

  // list array slide objects
  List<SlideObject> slideObjects;
  // image load with renderer
  image.Image fullImage;
  // success flag
  bool _success = false;
  // flag already start slide
  bool startSlide = false;
  // save current swap process for reverse checking
  List<int> process;
  // flag finish swap
  bool finishSwap = false;
  bool _block = false;

  @override
  Widget build(BuildContext context) {
    size = Size(widget.size.width - widget.innerPadding * 2,
        widget.size.width - widget.innerPadding);
    final _appUser = Provider.of<AppUser>(context);

    return _success
        ? _successBuilder()
        : Column(
            mainAxisSize: MainAxisSize.min,
            // let make ui
            children: [
              // make 2 column, 1 for puzzle box, 2nd for button testing
              Container(
                decoration: BoxDecoration(color: Colors.white),
                width: widget.size.width,
                height: widget.size.width,
                padding: EdgeInsets.all(widget.innerPadding),
                child: Stack(
                  children: [
                    if (widget.level.imgUrl != null &&
                        slideObjects == null) ...[
                      RepaintBoundary(
                        key: _globalKey,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Color(0xff3D4A5A),
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: Image(
                            image: _img,
                          ),
                        ),
                      )
                    ],
                    if (slideObjects != null)
                      ...slideObjects
                          .where((slideObject) => slideObject.empty)
                          .map(
                        (slideObject) {
                          return Positioned(
                            left: slideObject.posCurrent.dx,
                            top: slideObject.posCurrent.dy,
                            child: SizedBox(
                              width: slideObject.size.width,
                              height: slideObject.size.height,
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(2),
                                color: Colors.white24,
                                child: Stack(
                                  children: [
                                    if (slideObject.image != null) ...[
                                      Opacity(
                                        opacity: _success ? 1 : 0.2,
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
                    if (slideObjects != null)
                      ...slideObjects
                          .where((slideObject) => !slideObject.empty)
                          .map(
                        (slideObject) {
                          return AnimatedPositioned(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease,
                            left: slideObject.posCurrent.dx,
                            top: slideObject.posCurrent.dy,
                            child: GestureDetector(
                              onTap: () {
                                changePos(slideObject.indexCurrent);
                              },
                              child: SizedBox(
                                width: slideObject.size.width,
                                height: slideObject.size.height,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2),
                                  color: Colors.blue,
                                  child: Stack(
                                    children: [
                                      if (slideObject.image != null) ...[
                                        slideObject.image
                                      ],
                                      Center(
                                        child: Text(
                                          "${slideObject.indexDefault}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList()
                  ],
                ),
              ),
              if (_appUser.admin)
                Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    FilledBtn(
                      title: 'Solve',
                      onPressed: reversePuzzle,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              // Container(
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       // u can use any button
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ElevatedButton(
              //           onPressed: () => generatePuzzle(),
              //           child: Text("Generate"),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ElevatedButton(
              //           // for checking purpose
              //           onPressed: startSlide ? null : () => reversePuzzle(),
              //           child: Text("Reverse"),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ElevatedButton(
              //           onPressed: () => clearPuzzle(),
              //           child: Text("Clear"),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            ],
          );
  }

  Widget _successBuilder() {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Column(
        children: [
          Text(
            'Congrats!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 32.0,
            ),
          ),
          Text(
            'You have solved this level.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          FilledBtn(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  _getImageFromWidget() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();

    size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();

    return image.decodeImage(pngBytes);
  }

  generatePuzzle() async {
    // dclare our array puzzle
    finishSwap = false;
    setState(() {});
    // 1st load render image to crop, we need load just once
    if (_img != null && this.fullImage == null)
      this.fullImage = await _getImageFromWidget();
    // ok nice..full image loaded

    // calculate box size for each puzzle
    Size sizeBox =
        Size(size.width / widget.sizePuzzle, size.width / widget.sizePuzzle);

    // let proceed with generate box puzzle
    // power of 2 because we need generate row & column same number
    slideObjects =
        List.generate(widget.sizePuzzle * widget.sizePuzzle, (index) {
      // we need setup offset 1st
      Offset offsetTemp = Offset(
        index % widget.sizePuzzle * sizeBox.width,
        index ~/ widget.sizePuzzle * sizeBox.height,
      );

      // set image crop for nice effect, check also if image is null
      image.Image tempCrop;
      if (widget.level.imgUrl != null && this.fullImage != null)
        tempCrop = image.copyCrop(
          fullImage,
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
            : Image.memory(
                image.encodePng(tempCrop),
                fit: BoxFit.contain,
              ),
      );
    }); //let set empty on last child

    slideObjects.last.empty = true;

    // make random.. im using smple method..just rndom with move it.. haha

    // setup moveMethod 1st
    // proceed with swap block place
    // swap true - we swap horizontal line.. false - vertical
    bool swap = true;
    process = [];

    // 20 * size puzzle shuffle
    for (var i = 0; i < widget.sizePuzzle * 20; i++) {
      for (var j = 0; j < widget.sizePuzzle / 2; j++) {
        SlideObject slideObjectEmpty = getEmptyObject();

        // get index of empty slide object
        int emptyIndex = slideObjectEmpty.indexCurrent;
        process.add(emptyIndex);
        int randKey;

        if (swap) {
          // horizontal swap
          int row = emptyIndex ~/ widget.sizePuzzle;
          randKey =
              row * widget.sizePuzzle + new Random().nextInt(widget.sizePuzzle);
        } else {
          int col = emptyIndex % widget.sizePuzzle;
          randKey =
              widget.sizePuzzle * new Random().nextInt(widget.sizePuzzle) + col;
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

  SlideObject getEmptyObject() {
    return slideObjects.firstWhere((element) => element.empty);
  }

  changePos(int indexCurrent) {
    if (!_block) {
      // problem here i think..
      SlideObject slideObjectEmpty = getEmptyObject();

      // get index of empty slide object
      int emptyIndex = slideObjectEmpty.indexCurrent;

      // min & max index based on vertical or horizontal

      int minIndex = min(indexCurrent, emptyIndex);
      int maxIndex = max(indexCurrent, emptyIndex);

      // temp list moves involves
      List<SlideObject> rangeMoves = [];

      // check if index current from vertical / horizontal line
      if (indexCurrent % widget.sizePuzzle == emptyIndex % widget.sizePuzzle) {
        // same vertical line
        rangeMoves = slideObjects
            .where((element) =>
                element.indexCurrent % widget.sizePuzzle ==
                indexCurrent % widget.sizePuzzle)
            .toList();
      } else if (indexCurrent ~/ widget.sizePuzzle ==
          emptyIndex ~/ widget.sizePuzzle) {
        rangeMoves = slideObjects;
      } else {
        rangeMoves = [];
      }

      rangeMoves = rangeMoves
          .where((puzzle) =>
              puzzle.indexCurrent >= minIndex &&
              puzzle.indexCurrent <= maxIndex &&
              puzzle.indexCurrent != emptyIndex)
          .toList();

      // check empty index under or above current touch
      if (emptyIndex < indexCurrent)
        rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? 1 : 0);
      else
        rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? 0 : 1);

      // check if rangeMOves is exist,, then proceed switch position
      if (rangeMoves.length > 0) {
        int tempIndex = rangeMoves[0].indexCurrent;

        Offset tempPos = rangeMoves[0].posCurrent;

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

      // this to check if all puzzle box already in default place.. can set callback for _success later
      if (slideObjects
                  .where((slideObject) =>
                      slideObject.indexCurrent == slideObject.indexDefault - 1)
                  .length ==
              slideObjects.length &&
          finishSwap) {
        // Success
        final _appUser = Provider.of<AppUser>(context, listen: false);

        if (!_appUser.admin && _appUser.currentLevel == widget.level.level)
          AppUserProvider(uid: _appUser.uid).updateUserDetail(
              data: {'current_level': _appUser.currentLevel + 1});
        Future.delayed(Duration(milliseconds: 1000),
            () => setState(() => _success = true));
        _block = true;
      } else {
        _success = false;
      }

      startSlide = true;
      setState(() {});
    }
  }

  clearPuzzle() {
    setState(() {
      // checking already slide for reverse purpose
      startSlide = true;
      slideObjects = null;
      finishSwap = true;
    });
  }

  reversePuzzle() async {
    startSlide = true;
    finishSwap = true;
    setState(() {});

    await Stream.fromIterable(process?.reversed)
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
  Offset posDefault;
  Offset posCurrent;
  // setup index for default / current position
  int indexDefault;
  int indexCurrent;
  // status box is empty
  bool empty;
  // size each box
  Size size;
  // Image field for crop later
  Image image;

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
