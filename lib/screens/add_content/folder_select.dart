import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/models/folder_model.dart';
import 'package:moa_app/repositories/folder_repository.dart';
import 'package:moa_app/utils/router_provider.dart';
import 'package:moa_app/widgets/alert_dialog.dart';
import 'package:moa_app/widgets/app_bar.dart';
import 'package:moa_app/widgets/button.dart';

class FolderSelect extends HookWidget {
  const FolderSelect({super.key});

  @override
  Widget build(BuildContext context) {
    void editFolder() {}

    void selectFolder({required int index}) {
      alertDialog.confirm(
        context,
        title: '선택',
        content: '이미지를 추가하시겠습니까?\n아니면 링크를 추가하시겠습니까?',
        confirmText: '이미지',
        cancelText: '링크',
        showCancelButton: true,
        onPressCancel: () {
          context.push(
              '${GoRoutes.folderSelect.fullPath}/${GoRoutes.addLinkContent.path}');
        },
        onPress: () {
          context.push(
              '${GoRoutes.folderSelect.fullPath}/${GoRoutes.addImageContent.path}');
        },
      );
    }

    return Scaffold(
      appBar: AppBarBack(
        isBottomBorderDisplayed: false,
        title: '폴더 선택',
        actions: [
          CircleIconButton(
            backgroundColor: AppColors.whiteColor,
            icon: Image(
              width: 20,
              height: 20,
              image: Assets.pencil,
            ),
            onPressed: editFolder,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder<List<FolderModel>>(
            future: FolderRepository.instance.getFolderList(),
            builder: (context, snapshot) {
              // var folderList = snapshot.data;
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const LoadingIndicator();
              // }
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: 20,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.3,
                    mainAxisSpacing: 30.0,
                    crossAxisSpacing: 20.0,
                    mainAxisExtent: 115,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 85,
                              child: Ink(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: Assets.folder,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.folderColorFFD4D7,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => selectFolder(index: index),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'text',
                          style: H4TextStyle(),
                        )
                      ],
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
