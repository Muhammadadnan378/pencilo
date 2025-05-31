import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadVideo extends StatelessWidget {
  const UploadVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Video"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UploadVideoForm(),
          ],
        ),
      ),
    );
  }
}

class UploadVideoForm extends StatefulWidget {
  const UploadVideoForm({super.key});

  @override
  _UploadVideoFormState createState() => _UploadVideoFormState();
}

class _UploadVideoFormState extends State<UploadVideoForm> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _videoFile;
  bool _isUploading = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Get the video reference
      final videoRef = _storage.ref().child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');

      // Upload video to Firebase Storage
      final uploadTask = videoRef.putFile(_videoFile!);
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the video URL
      final videoUrl = await snapshot.ref.getDownloadURL();

      // Save video metadata to Firestore
      await _firestore.collection('videos').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'video_url': videoUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isUploading = false;
        _videoFile = null; // Clear selected video
        _titleController.clear();
        _descriptionController.clear();
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Video Picker Button
        ElevatedButton(
          onPressed: _pickVideo,
          child: Text("Pick Video from Gallery"),
        ),
        SizedBox(height: 20),

        // Video Thumbnail Preview (if video selected)
        _videoFile != null
            ? Container(
          height: 150,
          width: 150,
          color: Colors.black,
          child: Icon(Icons.video_library, color: Colors.white),
        )
            : Text("No Video Selected"),
        SizedBox(height: 20),

        // Title and Description Input Fields
        TextField(
          controller: _titleController,
          decoration: InputDecoration(labelText: "Video Title"),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(labelText: "Video Description"),
        ),
        SizedBox(height: 20),

        // Upload Button
        _isUploading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: _uploadVideo,
          child: Text("Upload Video"),
        ),
      ],
    );
  }
}
