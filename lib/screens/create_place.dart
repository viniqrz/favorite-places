import 'package:favorite_places/model/place.dart';
import 'package:favorite_places/providers/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePlace extends ConsumerStatefulWidget {
  const CreatePlace({super.key});

  @override
  ConsumerState<CreatePlace> createState() => _CreatePlaceState();
}

class _CreatePlaceState extends ConsumerState<CreatePlace> {
  String _name = '';

  final _formKey = GlobalKey<FormState>();

  void _submit() {
    ref.read(placesProvider.notifier).addPlace(
          Place(_name),
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
