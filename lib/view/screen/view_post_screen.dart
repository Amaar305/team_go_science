import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/auth_controller.dart';
import '../../services/current_user.dart';
import '../../controller/view_screen_controller.dart';
import '../../models/go_science_model.dart';
import '../../shimmers/post_details_skeleton.dart';
import '../utils/constants.dart';
import '../utils/custom_full_screen_dialog.dart';
import '../utils/method_utils.dart';
import '../widgets/details_widgets/build_header_image.dart';
import '../widgets/details_widgets/custom_detail_tile.dart';
import '../widgets/details_widgets/custom_divider.dart';
import '../widgets/details_widgets/custom_title.dart';
import 'edit_post.dart';
import 'user_view_screen.dart';

class ViewScreen extends StatefulWidget {
  ViewScreen({
    super.key,
    required this.blueBook,
  });
  final GoScience blueBook;

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final carouselController = CarouselController();
  final ViewScreenController controller = Get.find();

  final currentUser = CurrentLoggeedInUser.currentUserId!.uid;
  final _firestore = FirebaseFirestore.instance.collection("go_science");

  late GoScience goScience;

  @override
  void initState() {
    super.initState();
    controller.postUserInfo(widget.blueBook.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blueBook.name),
      ),
      body: StreamBuilder(
        stream: _firestore.doc(widget.blueBook.id).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: PostDetailsSkeleton());
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapshot.hasData) {
                return PostDetailsSkeleton();
              }

              final data = snapshot.data;
              goScience = GoScience.fromDocument(data!);
              controller.quillDescription(goScience.description);

              controller
                  .updateisLiked(goScience.favourites.contains(currentUser));
              controller.updateisViewed(goScience.views.contains(currentUser));

              // controller.updateLikedCount(goScience.favourites.length);
              controller.updateviewCount(goScience.views.length);

              if (!controller.isViewed) {
                // View the post.
                _firestore.doc(widget.blueBook.id).update({
                  'views': FieldValue.arrayUnion(
                    [currentUser],
                  )
                });
                controller.updateisViewed(true);
              }

              return Padding(
                padding: kDefaultAppPadding,
                child: ListView(
                  children: [
                    _header(),
                    const SizedBox(height: 20),
                    _builtViewAndFav(context),
                    _builtPostInfo(context),
                    CustomDivider(),
                    if (currentUser != widget.blueBook.userId)
                      _builtPostAction(context),
                    const SizedBox(height: 20),
                    CustomTitle(title: "Name"),
                    CustomDetailTile(title: goScience.name),
                    CustomDivider(),
                    const SizedBox(height: 10),
                    CustomTitle(title: "Description"),
                    quill.QuillEditor(
                      controller: controller.quillController!,
                      readOnly: true,
                      expands: false,
                      scrollController: ScrollController(),
                      autoFocus: false,
                      scrollable: true,
                      focusNode: FocusNode(),
                      padding: EdgeInsets.zero,
                    ),
                    CustomDivider(),
                    const SizedBox(height: 10),
                    CustomTitle(title: "Category"),
                    CustomDetailTile(title: goScience.category),
                    CustomDivider(),
                    const SizedBox(height: 10),
                    CustomTitle(title: "habitat"),
                    CustomDetailTile(title: goScience.habitat),
                    CustomDivider(),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Column _builtPostAction(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Get.to(() => EditScreen(goScience: goScience));
              },
              icon: Icon(Icons.edit),
              label: Text("Edit"),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                CustomFullScreenDialog.showAlertDialog(
                  () async {
                    Get.back();
                    Get.back();
                    toast(' Article deleted');
                    await Future.delayed(const Duration(seconds: 2))
                        .whenComplete(
                      () => AuthController.instance
                          .deletePost(widget.blueBook.id),
                    );
                    // await AuthController.instance
                    //     .deletePost(widget.blueBook.id);
                  },
                );
              },
              icon: Icon(Icons.delete),
              label: Text("Delete"),
            ),
          ],
        ),
        CustomDivider(),
      ],
    );
  }

  Column _header() {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: widget.blueBook.images.length,
          itemBuilder: (context, index, realIndex) {
            final urlImage = widget.blueBook.images[index];
            return buildImage(urlImage, index);
          },
          options: CarouselOptions(
            height: 250,

            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            viewportFraction: 1,
            // pageSnapping: false,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            // enableInfiniteScroll: false,

            onPageChanged: (index, reason) {
              controller.updateIndex(index);
            },
          ),
        ),
        const SizedBox(height: 20),
        buildIndicator(),
      ],
    );
  }

  Row _builtPostInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          MethodUtils.formatDate(widget.blueBook.createdAt),
          style: descriptionTextStyle,
        ),
        GetBuilder<ViewScreenController>(builder: (cont) {
          if (cont.goScienceUser != null) {
            return TextButton(
              child: Text(
                cont.goScienceUser!.name,
                style: descriptionTextStyle.copyWith(color: Colors.black),
              ),
              onPressed: () => Get.to(
                () => UserViewScreen(goScienceUser: cont.goScienceUser!),
              ),
            );
          } else {
            return SizedBox();
          }
        }),
      ],
    );
  }

  Widget _builtViewAndFav(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          MethodUtils.formatNumber(controller.viewCount),
        ),
        TextButton.icon(
          onPressed: () {
            if (controller.isLiked) {
              _firestore.doc(widget.blueBook.id).update({
                'favourites': FieldValue.arrayRemove(
                  [currentUser],
                )
              });
              toast('Article removed');
              // controller.likeCountDecrease();
              controller.updateisLiked(false);
            } else {
              // Save the post.
              _firestore.doc(widget.blueBook.id).update(
                {
                  'favourites': FieldValue.arrayUnion(
                    [currentUser],
                  )
                },
              );
              toast('Article saved');
              controller.updateisLiked(true);
            }
          },
          icon: Icon(
            controller.isLiked ? Icons.favorite : Icons.favorite_outline,
          ),
          label: Text(controller.isLiked ? "Unlike" : "Like"),
        ),
      ],
    );
  }

  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      onDotClicked: animateToSlide,
      activeIndex: controller.activeIndex,
      count: widget.blueBook.images.length,
      effect: const SlideEffect(
        dotHeight: 15,
        dotWidth: 15,
      ),
    );
  }

  void animateToSlide(int index) => carouselController.animateToPage(index);
}
