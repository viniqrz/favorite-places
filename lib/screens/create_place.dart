import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/providers/places.dart';
import 'package:favorite_places/utils/get_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// MAPS_API_KEY='AIzaSyD8W18KHM6WziOkjQS0JkWpUWvrcuofs2g'

class CreatePlace extends ConsumerStatefulWidget {
  const CreatePlace({super.key});

  @override
  ConsumerState<CreatePlace> createState() => _CreatePlaceState();
}

class _CreatePlaceState extends ConsumerState<CreatePlace> {
  String _name = '';
  final _formKey = GlobalKey<FormState>();
  File? _image;

  double? _lat;
  double? _lng;

  _retrieveUserLocation() async {
    final location = await determinePosition();
    print('Location: ${location.latitude}, ${location.longitude}');

    setState(() {
      _lat = location.latitude;
      _lng = location.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveUserLocation();
  }

  Future pickImage() async {
    try {
      bool accessAllowed = await Permission.storage.request().isGranted;
      // Either the permission was already granted before or the user just granted it.
      if (!accessAllowed) {
        print('Parabéns');
        return;
      }

      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => _image = imageTemp);
      print(imageTemp.path);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _submit() {
    ref.read(placesProvider.notifier).addPlace(
          Place(_name, imagePath: _image?.path),
        );
  }

  bool _checkDuplicity() {
    return ref.read(placesProvider.notifier).isNameDuplicate(_name);
  }

  void _handleAdd() {
    if (!_formKey.currentState!.validate()) return;
    _submit();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: Form(
        onWillPop: () async {
          return true;
        },
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _image != null
                  ? Image.file(
                      _image!,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * (3 / 4),
                      fit: BoxFit.scaleDown,
                    )
                  : Container(),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (name) {
                  if (_name.isEmpty || _name.trim().isEmpty) {
                    return 'Please enter a name';
                  }

                  if (_name.trim() != _name) {
                    return 'Please enter a valid name';
                  }

                  if (_checkDuplicity()) {
                    return 'This place already exists';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Add image'),
              ),
              const SizedBox(
                height: 16,
              ),
              (_lat != null && _lng != null)
                  ? Text(
                      'Your coords are $_lat, $_lng',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                onPressed: _handleAdd,
                label: const Text('Add'),
                icon: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
