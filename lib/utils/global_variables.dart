import 'package:flutter/material.dart';

const webScreenSize = 600;


const clothingTypes = ['Top', 'Bottom', 'Outerwear', 'Footwear', 'Accessories'];
const accessoriesSubTypes = ['Headwear', 'Jewelry', 'Bag', 'Eyewear', 'Scarves'];
const generateSettingsHero = "generate-hero";
const addClothingSettingsHero = "additional-settings-hero";
const editClothingSettingsHero = "edit-settings-hero";
List<Map<String, dynamic>> typesToFeatures = [
  {"id": "Top", "feature": "formal"},
  {"id": "Bottom", "feature": "formal"},
  {"id": "Bottom", "feature": "shorts"},
  {"id": "Outerwear", "feature": "formal"},
  {"id": "Outerwear", "feature": "waterproof"},
  {"id": "Outerwear", "feature": "light"},
  {"id": "Footwear", "feature": "formal"},
  {"id": "Accessories", "feature": "formal"},
  {"id": "Accessories", "feature": "subtype"},
];