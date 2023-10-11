import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:get/get.dart';

import '../../controller/edit_post_controller.dart';
import '../../models/go_science_model.dart';
import '../utils/constants.dart';
import '../utils/custom_snackbar.dart';
import '../widgets/create_widgets/create_form.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.goScience});
  static const routeName = '/edit-post';

  final GoScience goScience;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final EditPostController controller = Get.find();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    controller.updateControllersText(
      title: widget.goScience.name,
      description: widget.goScience.description,
      habitat: widget.goScience.habitat,
    );

    controller.quillDescription(widget.goScience.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit a post"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: kDefaultAppPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                quil.QuillToolbar.basic(
                  controller: controller.quillController!,
                  iconTheme: quil.QuillIconTheme(
                    borderRadius: 12,
                    iconSelectedFillColor:
                        Theme.of(context).colorScheme.primary,
                  ),
                   fontFamilyValues: const {
                    "Merriweather": 'Merriweather',
                  },
                  fontSizeValues: const {
                    'Small': '17',
                    'Medium': '20.5',
                    'Large': '40'
                  },
                  showAlignmentButtons: false,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                      color: Theme.of(context).colorScheme.primary),
                  child: quil.QuillEditor.basic(
                    controller: controller.quillController!,
                    readOnly: false,
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: 'Name',
                  controller: controller.titleEditingController!,
                ),
                MyTextField(
                  hintText: 'Habitat',
                  controller: controller.habitatEditingController!,
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();
                    FocusScope.of(Get.context!).unfocus();

                    if (isValid) {
                      _formKey.currentState!.save();
                      var content = jsonEncode(controller
                          .quillController!.document
                          .toDelta()
                          .toJson());
                      if (content.isEmpty ||
                          content.length == 0 ||
                          controller.quillController!.document.isEmpty()) {
                        CustomSnackBar.showSnackBAr(
                          context: context,
                          title: "Warning",
                          message: "Description is empty",
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        );
                      } else {
                        // Send the data
                        controller.tryUpdate(
                          widget.goScience.id,
                          widget.goScience.userId,
                          content
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Update',
                    style: kTextStyle,
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
