import 'package:cosmocloset/model/user.dart';
import 'package:cosmocloset/provider/user_provider.dart';
import 'package:cosmocloset/screens/add_clothing_screen.dart';
import 'package:cosmocloset/screens/search_screen.dart';
import 'package:cosmocloset/screens/tab_screen.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/utils.dart';
import 'package:cosmocloset/widgets/clothing_card.dart';
import 'package:cosmocloset/widgets/feed_screen.dart';
import 'package:cosmocloset/widgets/tab_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  Uint8List? _file;
  bool isShowSearch = false;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void navigateToAddClothingScreen(Uint8List selectedImage) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddClothingScreen(
          selectedImage: selectedImage,
        ),
      ),
    );
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("add clothing"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                  navigateToAddClothingScreen(_file!);
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                  navigateToAddClothingScreen(_file!);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // search and add clothing tab
            Container(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_rounded),
                          hintText: "search for item...",
                          fillColor: textFieldColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          if (value != '') {
                            setState(() {
                            isShowSearch = true;
                          });
                          } else {
                            setState(() {
                            isShowSearch = false;
                          });
                          }
                        },
                      ),
                      ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                    onPressed: () => _selectImage(context),
                    icon: const Icon(
                      Icons.add_box_rounded,
                      size: 36,
                    ),
                    color: buttonColor,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isShowSearch == false
                // tab bar
                ? const TabScreen()
                // searchScreen
                : SearchScreen(searchController: searchController,)
          ],
        ),
      ),
    );
  }
}
