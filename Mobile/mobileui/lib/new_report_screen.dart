
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({super.key});

  @override
  State<NewReportScreen> createState() =>
      _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController descriptionController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  Uint8List? selectedImage;
  bool isSubmitting = false;

  // PICK IMAGE
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();

        setState(() {
          selectedImage = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image error: $e')),
      );
    }
  }

  // REMOVE IMAGE
  void removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  // SUBMIT REPORT
  void submitReport() {
    if (descriptionController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the description and location.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report form is ready! Connect your API to submit it.'),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Report',
          style: TextStyle(
            color: Color(0xFF292936),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Tell us what needs fixing in your barangay.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            // DESCRIPTION
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText:
                      'What exactly is wrong, and since when? Add anything that helps the crew find it.',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // LOCATION
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.pink,
                      ),
                      hintText: 'Street, purok or nearest landmark',
                      filled: true,
                      fillColor: const Color(0xFFF9F9FC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Reports are routed to your barangay hall.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // PHOTO SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Add a photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Optional, but reports with a photo are triaged faster.',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 18),

                  // PHOTO PREVIEW / PICKER
                  GestureDetector(
                    onTap: () => pickImage(ImageSource.gallery),

                    child: Container(
                      height: 165,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFDCE8),
                        ),
                      ),

                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.memory(
                                selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.pink,
                                  size: 40,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Take or choose a photo',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  if (selectedImage != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: removeImage,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Remove photo'),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // CAMERA AND GALLERY BUTTONS
                  Row(
                    children: [

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Camera'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.pink,
                            side: const BorderSide(
                              color: Color(0xFFE8E8EF),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_outlined),
                          label: const Text('Gallery'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.pink,
                            side: const BorderSide(
                              color: Color(0xFFE8E8EF),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: submitReport,
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                label: const Text(
                  'Submit New Report',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED2870),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
