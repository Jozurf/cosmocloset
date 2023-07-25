import 'package:cosmocloset/model/user.dart';
import 'package:cosmocloset/provider/user_provider.dart';
import 'package:cosmocloset/resources/firestore_methods.dart';
import 'package:cosmocloset/resources/fonts.dart';
import 'package:cosmocloset/screens/closet_screen.dart';
import 'package:cosmocloset/utils/colors.dart';
import 'package:cosmocloset/utils/global_variables.dart';
import 'package:cosmocloset/utils/utils.dart';
import 'package:cosmocloset/widgets/custom_animation.dart';
import 'package:cosmocloset/widgets/dropdown_input.dart';
import 'package:cosmocloset/widgets/hero_animation.dart';
import 'package:cosmocloset/widgets/more_clothing_settings.dart';
import 'package:cosmocloset/widgets/text_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class AddClothingScreen extends StatefulWidget {
  final Uint8List selectedImage;
  const AddClothingScreen({super.key, required this.selectedImage});

  @override
  State<AddClothingScreen> createState() => _AddClothingScreenState();
}

class _AddClothingScreenState extends State<AddClothingScreen> {
  PaletteGenerator? paletteGenerator;
  Color defaultColor = Colors.white;
  bool _colorHasChanged = false;
  Color? originalColor;
  bool _isLoading = false;
  final TextEditingController _textEditingController = TextEditingController();
  String? dropDownValue;
  Color? selectedColor;
  // other features
  bool _canBeFormal = false;
  bool _isWaterProof = false;
  bool _isLight = false;
  bool _areShorts = false;
  String? subTypes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generatePalette();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  void generatePalette() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
        MemoryImage(widget.selectedImage));
    setState(() {
      selectedColor = paletteGenerator == null
          ? defaultColor
          : paletteGenerator!.dominantColor!.color;
      originalColor = selectedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // picture
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: MemoryImage(widget.selectedImage),
                        fit: BoxFit.cover,
                        alignment: Alignment.center)),
              ),
              const SizedBox(
                height: 12,
              ),
              // options
              Expanded(
                // color: Colors.blue,
                // width: double.infinity,
                // padding: const EdgeInsets.only(top: 16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //name,
                      TextFieldInput(
                        hintText: 'name your clothing',
                        textEditingController: _textEditingController,
                        textInputType: TextInputType.name,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //type,
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: buttonColor, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButton<String>(
                          hint: Text(
                            "set clothing type",
                            style: descriptionStyleBlack,
                          ),
                          value: dropDownValue,
                          icon: const Icon(Icons.expand_more),
                          onChanged: (newValue) {
                            setState(() {
                              dropDownValue = newValue;
                            });
                          },
                          items: clothingTypes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: descriptionStyleBlack,
                              ),
                            );
                          }).toList(),
                          dropdownColor: textFieldColor,
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: descriptionStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //color,
                      GestureDetector(
                        onTap: () => showColorPicker(context),
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 12, bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: buttonColor, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "set clothing color",
                                style: descriptionStyle,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: selectedColor,
                                ),
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _colorHasChanged == true
                          ? Container(
                              padding: const EdgeInsets.only(right: 8),
                              width: double.infinity,
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: revertColorToOriginal,
                                child: Text(
                                  "revert to original",
                                  style: descriptionStyle,
                                ),
                              ))
                          : const SizedBox(),
                      //more options
                      dropDownValue == null
                          ? const SizedBox()
                          : Row(
                              children: [
                                Text(
                                  "set more features (optional)",
                                  style: descriptionStyle,
                                ),
                                Hero(
                                    tag: addClothingSettingsHero,
                                    createRectTween: (begin, end) {
                                      return CustomRectTween(
                                          begin: begin!, end: end!);
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                          onPressed: showClothingSettings,
                                          icon: const Icon(
                                              Icons.settings_rounded)),
                                    ))
                              ],
                            )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => postClothing(user.uid, _textEditingController.text,
                    dropDownValue, selectedColor, widget.selectedImage),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    color: buttonColor,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.black,
                        ))
                      : Text(
                          "add clothing",
                          style: buttonTextStyle,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ));
  }

  void showColorPicker(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("pick your color"),
          content: Column(
            children: [
              buildColorPicker(),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("close"))
            ],
          )));

  Widget buildColorPicker() => ColorPicker(
        pickerColor: selectedColor == null ? defaultColor : selectedColor!,
        onColorChanged: (color) => setState(() {
          selectedColor = color;
          _colorHasChanged = true;
        }),
        enableAlpha: false,
        labelTypes: const [],
      );

  void revertColorToOriginal() {
    setState(() {
      selectedColor = originalColor;
      _colorHasChanged = false;
    });
  }

  void postClothing(String uid, String name, String? clothingType,
      Color? selectedColor, Uint8List file) async {
    Map<String, dynamic> additionalSettings = getAdditionalSettings();
    if (name.isEmpty) {
      showSnackBar("please give clothing a name", context);
    } else if (dropDownValue == null) {
      showSnackBar("please give clothing a type", context);
    } else if (selectedColor == null) {
      showSnackBar("please select a color", context);
    } else {
      try {
        setState(() {
          _isLoading = true;
        });
        String res = await FirestoreMethods().uploadClothing(uid, name, file,
            clothingType!, selectedColor.value.toString(), additionalSettings);
        setState(() {
          _isLoading = false;
        });
        if (res == "success") {
          showSnackBar("added!", context);
          // navigate back to closet
          Navigator.of(context).pop();
        } else {
          showSnackBar(res, context);
        }
      } catch (err) {
        showSnackBar(err.toString(), context);
      }
    }
  }

  void setFormal(bool value) {
    setState(() {
      _canBeFormal = value;
    });
    print('formal :$_canBeFormal');
  }

  void setWaterProof(bool value) {
    setState(() {
      _isWaterProof = value;
    });
    print('waterproof :$_isWaterProof');
  }

  void setLight(bool value) {
    setState(() {
      _isLight = value;
    });
    print('is Light Jacket :$_isLight');
  }

  void setAreShorts(bool value) {
    setState(() {
      _areShorts = value;
    });
    print('are shorts :$_areShorts');
  }

  void changeSubType(String subType) {
    setState(() {
      subTypes = subType;
    });
    print('subtype :$subTypes');
  }

  void showClothingSettings() {
    Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return MoreClothingSettings(
        heroTag: addClothingSettingsHero,
        clothingType: dropDownValue!,
        setFormal: setFormal,
        setAreShorts: setAreShorts,
        setLight: setLight,
        setWaterProof: setWaterProof,
        changeSubType: changeSubType,
        initialFormal: _canBeFormal,
        initialAreShorts: _areShorts,
        initialLight: _isLight,
        initialWaterproof: _isWaterProof,
        initialSubType: subTypes,
      );
    }));
  }

  Map<String, dynamic> getAdditionalSettings() {
    return {
      "formal": _canBeFormal,
      "waterproof": _isWaterProof,
      "light": _isLight,
      "shorts": _areShorts,
      "subtype": subTypes
    };
  }
}
