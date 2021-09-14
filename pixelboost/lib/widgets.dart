import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pixelboost/main.dart';
import 'dart:html' as html;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Uint8List output;
  PlatformFile image;
  bool refine = false;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: midBlue,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text('PixelBoost', style: TextStyle(
              color: Colors.white,
              fontSize: 60,
            )),
            Text('By Srujan Mupparapu', style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
            SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => refine = false),
                  child: MethodOption(
                    selected: refine == false,
                    title: 'Super-Resolution',
                    description: 'Scale images up without lost details and fuzziness.',
                    illustration: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                          width: 114,
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 12,
                          width: 64,
                          decoration: BoxDecoration(
                            color: midBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 140,
                          width: 178,
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: Text('2x', style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 60),
                GestureDetector(
                  onTap: () => setState(() => refine = true),
                  child: MethodOption(
                    selected: refine == true,
                    title: 'Refine',
                    description: 'Improve image quality at the same dimensions.',
                    illustration: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 112,
                          width: 142,
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 12,
                          width: 64,
                          decoration: BoxDecoration(
                            color: midBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 112,
                          width: 142,
                          decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            _bottom(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _bottom() {
    if (output != null) return _download();
    if (image == null) return _uploadButton();
    if (processing) return _inProcessing();
    return _boostButton();
  }

  Widget _uploadButton() => Column(
    children: [
      RoundButton(
        height: 72,
        width: 465,
        text: Text('Upload Image', style: TextStyle(
          color: Colors.white,
          fontSize: 28,
        )),
        onPress: _pickImage,
      ),
      SizedBox(height: 10),
      Text('JPG only', style: TextStyle(
        color: Colors.white,
        fontSize: 18,
      )),
    ],
  );

  Widget _boostButton() => Column(
    children: [
      GestureDetector(
        onTap: _pickImage,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: lightBlue,
              width: 5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(image.name, style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            )),
          ),
        ),
      ),
      SizedBox(height: 10),
      RoundButton(
        height: 72,
        width: 465,
        text: Text('Boost', style: TextStyle(
          color: Colors.white,
          fontSize: 28,
        )),
        onPress: _processImage,
      ),
    ],
  );

  Widget _inProcessing() => Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: lightBlue,
            width: 5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(image.name, style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          )),
        ),
      ),
      SizedBox(height: 10),
      Container(
        height: 72,
        width: 465,
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Center(
          child: Text('Processing...', style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          )),
        ),
      ),
    ],
  );

  Widget _download() => Column(
    children: [
      Container(
        width: 465,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: lightBlue,
                      width: 5,
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Center(
                    child: Text('Finished!', style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    )),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: RoundButton(
                height: 48,
                onPress: _reset,
                text: Text('New Image', style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                )),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 15),
      RoundButton(
        height: 72,
        width: 465,
        text: Text('Download', style: TextStyle(
          color: Colors.white,
          fontSize: 28,
        )),
        onPress: _downloadFile,
      ),
    ],
  );

  void _pickImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );
    if(result != null) {
      setState(() {
        image = result.files.first;
      });
    }
  }

  void _processImage() async {
    setState(() {
      processing = true;
    });
    output = await useSrcnn(image, refine);
    setState(() {
      processing = false;
    });
  }

  void _downloadFile() {
    final text = 'this is the text file';

    // prepare
    final blob = html.Blob([output]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = image.name;
    html.document.body.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  void _reset() {
    setState(() {
      output = null;
      image = null;
      refine = false;
      processing = false;
    });
  }

}

class MethodOption extends StatelessWidget {

  final bool selected;
  final String title;
  final Widget illustration;
  final String description;

  MethodOption({this.selected, this.title, this.illustration, this.description});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 370,
          width: 481,
          decoration: BoxDecoration(
            color: selected ? lightBlue : midBlue,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        Container(
          height: 354,
          width: 465,
          decoration: BoxDecoration(
            color: darkBlue,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 37,
                        width: 37,
                        decoration: BoxDecoration(
                          color: selected ? lightBlue : darkBlue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: midBlue,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(title, style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                      )),
                    ),
                  ],
                ),
                illustration,
                Text(description, textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RoundButton extends StatefulWidget {

  final double height;
  final double width;
  final Widget text;
  final VoidCallback onPress;

  RoundButton({this.height, this.width, this.text, this.onPress});

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {

  bool isPressedDown = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => setState(() => isPressedDown = true),
      onPointerUp: (event) => setState(() => isPressedDown = false),
      onPointerCancel: (event) => setState(() => isPressedDown = false),
      child: GestureDetector(
        onTap: widget.onPress,
        child: AnimatedOpacity(
          opacity: isPressedDown ? 0.6 : 1,
          duration: Duration(milliseconds: isPressedDown ? 10 : 100),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: widget.text,
            ),
          ),
        ),
      ),
    );
  }
}