import 'package:blue_book/view/utils/constants.dart';
import 'package:blue_book/view/widgets/create_widgets/create_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/add_category_controller.dart';

class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({super.key});
  final AddCategoryController controller = Get.find<AddCategoryController>();

  static const routeName = '/add-category';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add category"),
      ),
      body: Padding(
        padding: kDefaultAppPadding,
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyTextField(
                    hintText: "Category",
                    controller: controller.titleEditingController!,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.trySubmitCat();
                    },
                    child: Text(
                      "Add",
                      style: kTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
