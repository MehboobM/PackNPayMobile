import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/m_font_styles.dart';

class DetailsUploadPopup extends StatefulWidget {
  final String title;
  final String hintText;
  final Function(String description, List<File> images)? onSave;

  const DetailsUploadPopup({
    super.key,
    required this.title,
    this.hintText = "Enter a description...",
    this.onSave,
  });

  @override
  State<DetailsUploadPopup> createState() => _DetailsUploadPopupState();
}

class _DetailsUploadPopupState extends State<DetailsUploadPopup> {
  final TextEditingController descriptionController =
  TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> selectedImages = [];

  /// Pick images from Gallery
  Future<void> _pickFromGallery() async {
    final List<XFile> images =
    await _picker.pickMultiImage(imageQuality: 70);

    if (images.isNotEmpty) {
      setState(() {
        for (var img in images) {
          if (selectedImages.length < 5) {
            selectedImages.add(File(img.path));
          }
        }
      });
    }
  }

  /// Pick images from Files
  Future<void> _pickFromFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        for (var path in result.paths) {
          if (path != null && selectedImages.length < 5) {
            selectedImages.add(File(path));
          }
        }
      });
    }
  }

  /// Show picker options
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Files"),
              onTap: () {
                Navigator.pop(context);
                _pickFromFiles();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() => selectedImages.removeAt(index));
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: TextStyles.f14w600Gray9),
                IconButton(
                  icon: const Icon(Icons.close,color: Colors.grey,size: 18,),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            /// Description Label
            /*Text("Description",
                style: TextStyles.f12w500Gray7),
            const SizedBox(height: 6),

            /// Description Field
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:  BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:  BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:  BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),*/

            /// Attach Images Label
            Text("Attach images",
                style: TextStyles.f12w500Gray7),
            const SizedBox(height: 6),

            /// Upload Box
            GestureDetector(
              onTap: _showPickerOptions,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor:
                      AppColors.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.file_upload_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                     Text(
                      "You can upload up to 5 files (JPG, PNG).\nMax size: 10 MB each.",
                      textAlign: TextAlign.center,
                      style:
                      TextStyles.f10w500Gray5
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                        AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:  Text(
                        "Upload files",
                        style: TextStyles.f12w600primary
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Selected Images Preview
            if (selectedImages.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                            BorderRadius.circular(10),
                            child: Image.file(
                              selectedImages[index],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding:
                                const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            /// Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (widget.onSave != null) {
                    widget.onSave!(
                      descriptionController.text,
                      selectedImages,
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}