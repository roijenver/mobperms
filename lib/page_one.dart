import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  int _selectedIndex = 0;
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imgTemporary = File(image.path);
      setState(() {
        this.image = imgTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Act 5 Perms"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 50, right: 50,top: 60),
            child: const Text(
              "Picture",
              style: TextStyle(
                fontSize: 50,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(75),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.lightBlueAccent.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                )
              ],
              border: Border.all(width: 5, color: Colors.black),
            ),
            child: image != null
                ? CircleAvatar(
              radius: 125,
              child: Image.file(
                image!,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ):
            const Image(
              image: AssetImage('assets/grass.jpg'),
              fit: BoxFit.cover,
              width: 250,
              height: 250,
            ),
          ),
          const Text(
            "",
          ),
          const Text(
            "You can select for Camera or from Gallery at the bottom!",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.image),
              label: 'Gallery'),
        ],
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.lightBlueAccent,
        onTap: (int index) async {
          if(index == _selectedIndex) {
            PermissionStatus cameraStatus = await Permission.camera.request();
            if (cameraStatus == PermissionStatus.granted) {
              pickImage(ImageSource.camera);
            } else if (cameraStatus == PermissionStatus.denied) {
              return;
            }
          }
          else{
            PermissionStatus galleryStatus = await Permission.storage.request();
            if (galleryStatus == PermissionStatus.granted) {
              pickImage(ImageSource.gallery);
            } else if (galleryStatus == PermissionStatus.denied) {
              return;
            }
          }
        },
      ),
    );
  }
}