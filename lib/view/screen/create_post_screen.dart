import 'dart:convert';

import 'package:blue_book/view/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;

import '../../controller/article_controller.dart';
import '../utils/constants.dart';
import '../widgets/create_widgets/create_form.dart';

class CreateArticleScreen extends StatelessWidget {
  CreateArticleScreen({super.key});
  static const routeName = '/article-post';

  final ArticleController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a post"),
        elevation: 2,
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
                  maxLines: 2,
                ),
                Obx(() {
                  return DropdownButtonFormField(
                    isExpanded: true,
                    key: const ValueKey('Category'),
                    validator: (value) {
                      if (value != null) {
                        return null;
                      }
                      return 'Please select a category option';
                    },
                    decoration: InputDecoration(
                      label: const Text(
                        'Category',
                        style: TextStyle(color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      fillColor: Theme.of(context).colorScheme.primary,
                      filled: true,
                    ),
                    onSaved: (cat) {
                      controller.updateCategory(cat!);
                    },
                    items: controller.categories
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(
                              option.toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (cat) {
                      controller.updateCategory(cat!);
                    },
                  );
                }),
                Row(
                  children: [
                    GetBuilder<ArticleController>(builder: (control) {
                      return Expanded(
                        child: CustomPickerThumbnail(
                          child: control.pickedImagePath == null
                              ? const Center(
                                  child: Text("Tap to select images"))
                              : Image.file(
                                  control.pickedImagePath!,
                                  fit: BoxFit.cover,
                                ),
                          onSend: () {
                            control.selectMultiplesImages();
                          },
                        ),
                      );
                    }),
                  ],
                ),
                GetBuilder<ArticleController>(builder: (controller) {
                  if (controller.isUploaded != null &&
                      controller.isUploaded! == true) {
                    return ElevatedButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        FocusScope.of(Get.context!).unfocus();

                        if (isValid) {
                          _formKey.currentState!.save();
                          var content = jsonEncode(controller
                              .quillController!.document
                              .toDelta()
                              .toJson());
                          if (controller.quillController!.document.isEmpty() ||
                              content.isEmpty ||
                              content.length == 0) {
                            CustomSnackBar.showSnackBAr(
                              context: context,
                              title: "Warning",
                              message: "Description is empty",
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            );
                          } else {
                            // Send the data
                            controller.submitPost(content);
                          }
                        }
                      },
                      child: const Text(
                        'Create',
                        style: kTextStyle,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPickerThumbnail extends StatelessWidget {
  const CustomPickerThumbnail({
    super.key,
    required this.child,
    required this.onSend,
  });
  final Widget child;
  final void Function() onSend;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSend(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        height: 100,
        // padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: child,
      ),
    );
  }
}
