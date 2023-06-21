import 'dart:async';
import 'dart:io';

import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/providers/places.dart';
import 'package:favorite_places/services/http/google_maps.dart';
import 'package:favorite_places/utils/get_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

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
  String? _address;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  _retrieveUserLocation() async {
    final loc = await determinePosition();

    print('loc: ${loc.latitude}, ${loc.longitude}');

    final address =
        await GoogleMapsService.getCoordsAddress(loc.latitude, loc.longitude);

    setState(() {
      _lat = loc.latitude;
      _lng = loc.longitude;
      _address = address;
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

      final image = await ImagePicker().pickImage(source: ImageSource.camera);
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
          Place(_name, imagePath: _image?.path, lat: _lat, lng: _lng),
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
      body: SingleChildScrollView(
        child: Form(
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
                (_address != null)
                    ? Text(
                        'Your address is $_address',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                const SizedBox(
                  height: 16,
                ),
                (_address != null)
                    ? Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                              maxHeight: 400,
                            ),
                            child: GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(_lat!, _lng!), zoom: 14.4746),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              markers: {
                                Marker(
                                  markerId: const MarkerId('1'),
                                  position: LatLng(_lat!, _lng!),
                                )
                              },
                              onTap: (argument) {
                                setState(() {
                                  _lat = argument.latitude;
                                  _lng = argument.longitude;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 0,
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
      ),
    );
  }
}
