import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/directory_manager/directory_manager.dart';
import 'package:sogo_flutter/src/models/directory/directory_categories_model.dart';
import 'package:sogo_flutter/src/models/directory/directory_floor_model.dart';
import 'package:sogo_flutter/src/models/directory/directory_list_model.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/screens/mall_list/directory/directory_details.dart';
import 'package:sogo_flutter/src/screens/mall_list/directory/directory_list_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:textfield_search/textfield_search.dart';

class DirectoryView extends StatefulWidget {
  final String title;
  const DirectoryView({Key? key, required this.title}) : super(key: key);

  @override
  State<DirectoryView> createState() => _DirectoryViewState();
}

class _DirectoryViewState extends State<DirectoryView> {

  Mall? selectedMall;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    directoryManager.getDirectoryCategories(merchantId: "44");
    directoryManager.getDirectoryFloor();
    directoryManager.getAllDirectoryList();
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
                                  DirectoryListModel? response = await directoryManager.getDirectoryList(searchTerm: _searchController.text, withStream: false);
                                  return response?.results;
                                },
                                getSelectedValue: (value){
                                  _searchController.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
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
                body: StreamBuilder<ApiResponse<DirectoryFloorModel>?>(
                    stream: directoryManager.directoryFloor,
                    builder: (BuildContext context, AsyncSnapshot<ApiResponse<DirectoryFloorModel>?> directoryFloorSnapshot) {
                      if (directoryFloorSnapshot.hasData) {
                        switch (directoryFloorSnapshot.data!.status) {
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
                            return StreamBuilder<ApiResponse<DirectoryCategoriesModel>?>(
                                stream: directoryManager.directoryCategories,
                                builder: (BuildContext context, AsyncSnapshot<ApiResponse<DirectoryCategoriesModel>?> directoryCategoriesSnapshot) {
                                  if (directoryCategoriesSnapshot.hasData) {
                                    switch (directoryCategoriesSnapshot.data!.status) {
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
                                        return StreamBuilder<ApiResponse<DirectoryListModel>?>(
                                            stream: directoryManager.allDirectoryList,
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
                                                    return directoriesBody(context, directoryFloorSnapshot.data?.data, directoryCategoriesSnapshot.data?.data, directoryListSnapshot.data?.data);
                                                  case Status.NODATAFOUND:
                                                    debugPrint('Not found');
                                                    return const SizedBox();
                                                  case Status.ERROR:
                                                    debugPrint('Error');
                                                    return const SizedBox();
                                                }
                                              }
                                              return Container();
                                            });
                                      case Status.NODATAFOUND:
                                        debugPrint('Not found');
                                        return const SizedBox();
                                      case Status.ERROR:
                                        debugPrint('Error');
                                        return const SizedBox();
                                    }
                                  }
                                  return Container();
                                });
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

  Widget directoriesBody(BuildContext context, DirectoryFloorModel? floors, DirectoryCategoriesModel? categories, DirectoryListModel? directoryList) {
    List<FloorResult> floorsList = floors?.results ?? [];
    var contain = floorsList.where((element) => element.floorUnit == "All");
    if(contain.isEmpty){
      floorsList.insert(0, FloorResult(floorUnit: "All"));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Wrap(
              spacing: 10.sp, //horizontal spacing
              runSpacing: 5.sp, //vertical spacing
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: floorsList.map((floor) => floorButton(context, floor, directoryList)).toList(),
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            children: categories?.result?.map((category) => categoryTile(context, category)).toList() ?? [],
          ),
        ],
      ),
    );
  }

  Widget floorButton(BuildContext context, FloorResult floor, DirectoryListModel? directoryList){
    Size size = MediaQuery.of(context).size;
    return IconButton(
      onPressed: (){
        List<DirectoryResult> directories = [];
        directories = directoryList?.results?.where((element) => element.floor == floor.floorId).toList() ?? [];
        if(floor.floorId == null) {
          directories = directoryList?.results ?? [];
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => DirectoryListView(title: floor.floorName ?? "All", directories: directories,),));
      },
      alignment: Alignment.center,
      constraints: BoxConstraints.expand(
        width: size.width / 4,
        height: size.width / 4,
      ),
      icon: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: AppColors.primaryRed.withOpacity(0.4), spreadRadius: 0.5.sp, blurRadius: 10.sp)],
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(floor.floorUnit ?? "", textAlign: TextAlign.center, style: TextStyle(color: AppColors.primaryRed, fontFamily: "GothamMedium", fontSize: 30.sp),),
      ),
    );
  }

  Widget categoryTile(BuildContext context, Result category) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DirectoryListView(title: category.title ?? "All", categoryId: category.id),));
      },
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: category.featuredImg??"", fit: BoxFit.fitWidth,
            placeholder: (context, url) => LoadingIndicator(
              indicatorType: Indicator.ballScale,
              colors: [AppColors.primaryRed, AppColors.secondaryRed],
            ),
            width: 25.sp,
            errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", width: 25.sp, fit: BoxFit.fitWidth,),
          ),
          SizedBox(width: 15.w,),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(category.title ?? "", style: TextStyle(fontFamily: "GothamBook", fontSize: 16.sp, color: const Color(0xFF080808)),),
              ),
              Divider(color: AppColors.grey.withOpacity(0.2), height: 1.sp, thickness: 1.sp,),
            ],
          ),
        ],
      ),
    );
  }
}