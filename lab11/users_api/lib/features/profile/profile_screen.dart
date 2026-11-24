import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _prefs = SharedPreferencesAsync();
  final _picker = ImagePicker();

  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    unawaited(_restorePhoto());
  }

  Future<void> _restorePhoto() async {
    final path = await _prefs.getString('avatarPath');

    if (path == null) return;

    final exists = await File(path).exists();

    if (!mounted || !exists) return;

    setState(() {
      _avatarPath = path;
    });
  }

  void _message(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (picked == null) return;
      if (!mounted) return;

      final directory = await getApplicationDocumentsDirectory();

      final path = '${directory.path}/avatar.jpg';

      final file = await File(picked.path).copy(path);

      await FileImage(file).evict();

      await _prefs.setString('avatarPath', path);

      if (!mounted) return;

      setState(() {
        _avatarPath = path;
      });
    } catch (_) {
      _message('Could not load photo');
    }
  }

  Future<void> _takePhoto() async {
    final status = await Permission.camera.request();

    if (!mounted) return;

    switch (status) {
      case PermissionStatus.granted:
        await _pickPhoto(ImageSource.camera);

      case PermissionStatus.denied:
        _message(
          'Camera permission denied. '
          'You can still choose a photo.',
        );

      case PermissionStatus.permanentlyDenied:
        await _showPermissionDialog();

      case PermissionStatus.restricted:
        _message('Camera access is restricted.');

      case PermissionStatus.limited:
        _message('Camera access is limited.');

      case PermissionStatus.provisional:
        _message('Camera access is not fully granted.');
    }
  }

  Future<void> _showPermissionDialog() async {
    final open = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Camera permission required'),
          content: const Text(
            'Camera permission is permanently denied. '
            'Open settings to allow camera access.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Open settings'),
            ),
          ],
        );
      },
    );

    if (open == true) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = _avatarPath;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: path == null ? null : FileImage(File(path)),
                child: path == null
                    ? const Text('U', style: TextStyle(fontSize: 48))
                    : null,
              ),
              const SizedBox(height: 24),
              const Text('My profile', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  await _pickPhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo_library),
                label: const Text('Choose photo'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take photo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
