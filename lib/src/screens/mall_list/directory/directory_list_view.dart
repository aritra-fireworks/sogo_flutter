import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/directory_manager/directory_manager.dart';
import 'package:sogo_flutter/src/models/directory/directory_list_model.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/screens/mall_list/directory/directory_details.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:textfield_search/textfield_search.dart';

class DirectoryListView extends StatefulWidget {
  final String title;
  final List<DirectoryResult>? directories;
  final String? categoryId;
  const DirectoryListView({Key? key, required this.title, this.directories, this.categoryId}) : super(key: key);

  @override
  State<DirectoryListView> createState() => _DirectoryListViewState();
}

class _DirectoryListViewState extends State<DirectoryListView> {

  Mall? selectedMall;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      FocusManager.instance.primaryFocus?.unfocus();
    });
    directoryManager.getDirectoryList(categoryId: widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissWrapper(
      child: Stack(
        children: [
          Container(
            height: 200.h,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: Text(widget.title, style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
              ),
              alignment: Alignment.topCenter,
              child: NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverAppBar(
                        floating: true,
                        pinned: false,
                        snap: true,
                        toolbarHeight: 80.h,
                        leading: const SizedBox(),
                        actions: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                              child: TextFieldSearch(
                                initialList: const [],
                                label: "Search",
                                minStringLength: 1,
                                future: () async {
                                  DirectoryListModel? response = await directoryManager.getDirectoryList(categoryId: widget.categoryId, searchTerm: _searchController.text, withStream: false);
                                  return response?.results;
                                },
                                getSelectedValue: (value){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DirectoryDetails(directoryId: value.id??""),));
                                },
                                controller: _searchController,
                                textStyle: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamRegular"),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                                    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                                    hintText: "Search",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp, height: 1.3, fontFamily: "GothamRegular"),
                                    suffix: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                      child: Image.asset("assets/images/ic_search.png", height: 16.sp, width: 16.sp, fit: BoxFit.contain,),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: StreamBuilder<ApiResponse<DirectoryListModel>?>(
                    stream: directoryManager.directoryList,
                    builder: (BuildContext context, AsyncSnapshot<ApiResponse<DirectoryListModel>?> directoryListSnapshot) {
                      if (directoryListSnapshot.hasData) {
                        switch (directoryListSnapshot.data!.status) {
                          case Status.LOADING:
                            debugPrint('Loading');
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                              ),
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(color: AppColors.primaryRed,),
                            );
                          case Status.COMPLETED:
                            debugPrint('Dashboard Loaded');
                            return directoriesBody(context, directoryListSnapshot.data?.data);
                          case Status.NODATAFOUND:
                            debugPrint('Not found');
                            return const SizedBox();
                          case Status.ERROR:
                            debugPrint('Error');
                            return const SizedBox();
                        }
                      }
                      return Container();
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget directoriesBody(BuildContext context, DirectoryListModel? data, ) {
    if(widget.directories != null){
      if(widget.directories!.isNotEmpty){
        return listView(widget.directories);
      } else {
        return Center(child: Text("No merchant found.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),));
      }
    }
    if(data?.results != null && data!.results!.isEmpty) {
      return Center(child: Text("No merchant found.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),));
    }
    return listView(data?.results);
  }

  Widget listView(List<DirectoryResult>? directories) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: directories?.length??0,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DirectoryDetails(directoryId: directories?[index].id??""),));
          },
          child: Row(
            children: [
              directories?[index].featuredImg != null ? CachedNetworkImage(
                imageUrl: directories![index].featuredImg??"", fit: BoxFit.fitWidth,
                placeholder: (context, url) => LoadingIndicator(
                  indicatorType: Indicator.ballScale,
                  colors: [AppColors.primaryRed, AppColors.secondaryRed],
                ),
                width: 25.sp,
                errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", width: 25.sp, fit: BoxFit.fitWidth,),
              ) : SizedBox(width: 25.sp,),
              SizedBox(width: 15.w,),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text(directories?[index].label ?? "", style: TextStyle(fontFamily: "GothamBook", fontSize: 16.sp, color: const Color(0xFF080808)),),
                  ),
                  Divider(color: AppColors.grey.withOpacity(0.2), height: 1.sp, thickness: 1.sp,),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}