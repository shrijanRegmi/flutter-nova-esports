import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/viewmodels/create_post_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/common_widgets/appbar.dart';
import 'package:peaman/views/widgets/common_widgets/border_btn.dart';
import 'package:peaman/views/widgets/create_post_widgets/photos.dart';
import 'package:peaman/views/widgets/create_post_widgets/write_caption.dart';

class CreatePostScreen extends StatelessWidget {
  final TabController tabController;
  CreatePostScreen(this.tabController);

  @override
  Widget build(BuildContext context) {
    return ViewmodelProvider<CreatePostVm>(
      vm: CreatePostVm(context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
          backgroundColor: Color(0xffF3F5F8),
          appBar: vm.isLoading
              ? null
              : PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: CommonAppbar(
                    title: Text(
                      'New Post',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Color(0xff3D4A5A),
                      ),
                    ),
                  ),
                ),
          body: SafeArea(
            child: vm.isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Lottie.asset(
                          'assets/lottie/loader.json',
                          width: MediaQuery.of(context).size.width - 100.0,
                          height: MediaQuery.of(context).size.width - 100.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text('Uploading post. Please wait'),
                    ],
                  )
                : SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            CreatePostPhotos(vm),
                            WriteCaption(vm),
                            SizedBox(
                              height: 20.0,
                            ),
                            _featuredSection(vm),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar: vm.isLoading
              ? null
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: BorderBtn(
                    onPressed: () => vm.createPost(appUser, appVm, tabController),
                    title: 'Share',
                    textColor: Colors.green,
                  ),
                ),
        );
      },
    );
  }

  Widget _featuredSection(final CreatePostVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Make this post featured',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff3D4A5A),
              fontSize: 14.0,
            ),
          ),
          Switch(
            value: vm.isFeatured,
            onChanged: (val) {
              vm.updateIsFeatured(val);
            },
          ),
        ],
      ),
    );
  }
}
