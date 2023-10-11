import 'package:get/get.dart';

import 'controller/add_category_controller.dart';
import 'controller/article_controller.dart';
import 'controller/draft_controller.dart';
import 'controller/edit_post_controller.dart';
import 'controller/go_science_users_controller.dart';
import 'controller/view_screen_controller.dart';
import 'view/pages/favourites/favourite_controller.dart';
import 'view/pages/dashboard/dashboard_controller.dart';
import 'view/pages/search/search_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DraftPostController(), fenix: true);
    Get.lazyPut(() => ViewScreenController(), fenix: true);
    Get.lazyPut(() => AddCategoryController(), fenix: true);
    Get.lazyPut(() => ArticleController(), fenix: true);
    Get.lazyPut(() => EditPostController(), fenix: true);

    Get.lazyPut(() => DashBoardController(), fenix: true);
    Get.lazyPut(() => FavouriteController(), fenix: true);
    Get.lazyPut(() => SearchsController(), fenix: true);
    Get.lazyPut(() => GoScienceUsersController(), fenix: true);
  }
}
