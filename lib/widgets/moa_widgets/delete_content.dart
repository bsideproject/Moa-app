import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/file_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/button.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

enum ContentType { folder, hashtag }

class DeleteContent extends HookWidget {
  const DeleteContent({
    super.key,
    required this.contentName,
    required this.type,
    required this.onPressed,
  });
  final String contentName;
  final ContentType type;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    void deleteContent() {
      onPressed();
      context.pop();
    }

    return SizedBox(
      width: double.infinity,
      child:

          /// 해시태그 삭제 뷰
          type == ContentType.hashtag
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.folderColorFAE3CB,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Text(
                        '#$contentName',
                        style: const Hash1TextStyle().merge(
                          const TextStyle(color: AppColors.placeholder),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${"#$contentName"}\n태그를 삭제하시겠어요?',
                      textAlign: TextAlign.center,
                      style: const H2TextStyle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: Assets.alert,
                            width: 13,
                            height: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '태그를 삭제하면 모은 취향이 모두 사라져요!',
                            style: const Body1TextStyle().merge(
                              const TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Button(
                      text: '삭제하기',
                      onPress: deleteContent,
                    )
                  ],
                )

              /// 폴더 삭제 뷰
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: Assets.folder,
                          colorFilter: const ColorFilter.mode(
                            AppColors.folderColorD7E5FC,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${"’$contentName"}\n폴더를 삭제하시겠어요?',
                      textAlign: TextAlign.center,
                      style: const H2TextStyle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: Assets.alert,
                            width: 13,
                            height: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '폴더를 삭제하면 모은 취향이 모두 사라져요!',
                            style: const Body1TextStyle().merge(
                              const TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Button(
                      text: '삭제하기',
                      onPress: deleteContent,
                    )
                  ],
                ),
    );
  }
}
