import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:collab_tasker/core/utils/padding_extension.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_list_controller.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/config/app_router.dart';

class WorkspaceListScreen extends StatelessWidget {
  const WorkspaceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkspaceListController());

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Alex!', // This can be dynamic from AuthController
                        style: AppTextStyle.displayMedium.copyWith(
                          fontSize: 24.sp,
                        ),
                      ),
                      4.heightBox,
                      Text(
                        'Manage your team tasks effectively',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.glassBackground,
                    child: Icon(Icons.person, color: Colors.white, size: 24.w),
                  ),
                ],
              ).px(24.w),

              24.heightBox,
              // Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.glassBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 20.w,
                    ),
                    12.widthBox,
                    Expanded(
                      child: TextField(
                        style: AppTextStyle.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Search Workspaces...',
                          hintStyle: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              32.heightBox,
              // List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.workspaces.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.workspaces_outline,
                            size: 64.w,
                            color: AppColors.textSecondary,
                          ),
                          16.heightBox,
                          Text(
                            'No workspaces yet',
                            style: AppTextStyle.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          8.heightBox,
                          Text(
                            'Create your first workspace to start collaborating',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ).px(32.w),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount:
                        controller.workspaces.length +
                        (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < controller.workspaces.length) {
                        final workspace = controller.workspaces[index];
                        return WorkspaceCard(
                          workspace: workspace,
                          onTap: () => context.push(
                            AppRoutes.workspaceDetail,
                            extra: workspace,
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        ).py24();
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addWorkspace),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
