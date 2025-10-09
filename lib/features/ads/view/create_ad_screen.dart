// lib/features/ads/view/merchant_create_ad_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/ad_provider.dart';
import 'merchant_ad_list.dart';

class MerchantCreateAdScreen extends ConsumerStatefulWidget {
  const MerchantCreateAdScreen({super.key});

  @override
  ConsumerState<MerchantCreateAdScreen> createState() =>
      _MerchantCreateAdScreenState();
}

class _MerchantCreateAdScreenState
    extends ConsumerState<MerchantCreateAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  List<TextEditingController> imageControllers = [];
  List<TextEditingController> videoControllers = [];

  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    imageControllers.add(TextEditingController());
    videoControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (var c in imageControllers) {
      c.dispose();
    }
    for (var c in videoControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _buildMediaSection(
    String type,
    List<TextEditingController> controllers,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type == "image" ? "Image URLs" : "Video URLs",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...controllers.map(
          (c) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: c,
                    decoration: InputDecoration(
                      hintText: "Enter $type link",
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? "Please enter $type link"
                        : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      controllers.remove(c);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: Text("Add $type link"),
            onPressed: () {
              setState(() {
                controllers.add(TextEditingController());
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final adState = ref.watch(merchantAdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ad"),
        backgroundColor: const Color(0xFF571094),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(titleController, "Ad Title", "Enter ad title"),
              const SizedBox(height: 16),
              _buildTextField(
                descController,
                "Description",
                "Enter description",
              ),
              const SizedBox(height: 16),
              _buildTextField(categoryController, "Category", "Enter category"),
              const SizedBox(height: 16),
              _buildTextField(locationController, "Location", "Enter location"),
              const SizedBox(height: 16),

              _buildMediaSection("image", imageControllers),
              const SizedBox(height: 16),
              _buildMediaSection("video", videoControllers),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text("Premium Ad"),
                activeThumbColor: const Color(0xFF571094),
                value: isPremium,
                onChanged: (val) => setState(() => isPremium = val),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: adState.status == AdStatus.loading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            List<Map<String, String>> mediaList = [];
                            for (var c in imageControllers) {
                              if (c.text.isNotEmpty) {
                                mediaList.add({
                                  "url": c.text.trim(),
                                  "type": "image",
                                });
                              }
                            }
                            for (var c in videoControllers) {
                              if (c.text.isNotEmpty) {
                                mediaList.add({
                                  "url": c.text.trim(),
                                  "type": "video",
                                });
                              }
                            }

                            ref
                                .read(merchantAdProvider.notifier)
                                .createAd(
                                  title: titleController.text.trim(),
                                  description: descController.text.trim(),
                                  category: categoryController.text.trim(),
                                  location: locationController.text.trim(),
                                  media: mediaList,
                                  isPremium: isPremium,
                                );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF571094),
                  ),
                  child: adState.status == AdStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Create Ad",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF571094), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MerchantAdsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "View My Ads",
                    style: TextStyle(
                      color: Color(0xFF571094),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
  ) {
    return TextFormField(
      controller: controller,
      validator: (value) =>
          value == null || value.isEmpty ? "Please enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
