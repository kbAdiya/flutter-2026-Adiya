import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  File? _avatar;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final String? path = await _prefs.getString('avatarPath');

    if (path == null) {
      return;
    }

    final File file = File(path);

    final bool exists = await file.exists();

    if (!mounted) {
      return;
    }

    if (exists) {
      setState(() {
        _avatar = file;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickPhoto(ImageSource source) async {
    if (_saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (picked == null) {
        return;
      }

      final directory = await getApplicationDocumentsDirectory();

      final String newPath = '${directory.path}/avatar.jpg';

      final File savedFile = await File(picked.path).copy(newPath);

      await FileImage(savedFile).evict();

      await _prefs.setString('avatarPath', savedFile.path);

      if (!mounted) {
        return;
      }

      setState(() {
        _avatar = savedFile;
      });

      _showMessage('Profile photo saved');
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage('Failed to select photo');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _choosePhoto() async {
    await _pickPhoto(ImageSource.gallery);
  }

  Future<void> _takePhoto() async {
    final PermissionStatus status = await Permission.camera.request();

    if (!mounted) {
      return;
    }

    if (status.isGranted) {
      await _pickPhoto(ImageSource.camera);
      return;
    }

    if (status.isPermanentlyDenied) {
      await _showPermissionDialog();
      return;
    }

    if (status.isDenied) {
      _showMessage('Camera permission is needed to take a photo');
      return;
    }

    if (status.isRestricted) {
      _showMessage('Camera access is restricted on this device');
      return;
    }

    if (status.isLimited) {
      _showMessage('Camera permission is limited');
      return;
    }

  }

  Future<void> _showPermissionDialog() async {
    final bool? openSettings = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Camera permission denied'),
          content: const Text(
            'Camera access is permanently disabled. '
            'Please enable it in your phone settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Open settings'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    if (openSettings == true) {
      final bool opened = await openAppSettings();

      if (!mounted) {
        return;
      }

      if (!opened) {
        _showMessage('Could not open settings');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 65,
                backgroundImage: _avatar == null ? null : FileImage(_avatar!),
                child: _avatar == null
                    ? const Icon(Icons.person, size: 65)
                    : null,
              ),

              const SizedBox(height: 24),

              const Text(
                'My Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _choosePhoto,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose photo'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take photo'),
                ),
              ),

              if (_saving) ...[
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
