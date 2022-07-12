import 'package:cached_network_image/cached_network_image.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/facilities_manager/facilities_manager.dart';
import 'package:sogo_flutter/src/models/facility/facilities_list_model.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/screens/mall_list/facilities_and_services/facility_details.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';

class FacilitiesAndServicesView extends StatefulWidget {
  const FacilitiesAndServicesView({Key? key}) : super(key: key);

  @override
  State<FacilitiesAndServicesView> createState() => _FacilitiesAndServicesViewState();
}

class _FacilitiesAndServicesViewState extends State<FacilitiesAndServicesView> {

  Mall? selectedMall;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  final FocusNode _searchFocus = FocusNode();

  final debouncer = Debouncer<String>(const Duration(milliseconds: 500), initialValue: "");

  @override
  void initState() {
    super.initState();
    facilitiesManager.getFacility();

    _searchController.addListener(() => debouncer.value = _searchController.text);
    debouncer.values.listen((search) {
      if(search.isNotEmpty) {
        //search
        facilitiesManager.getFacility(searchTerm: search);
      } else {
        //reset
        facilitiesManager.getFacility();
      }
    });
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
              title: Text("Facilities & Services", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocus,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.none,
                                style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamRegular"),
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
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: StreamBuilder<ApiResponse<FacilitiesListModel>?>(
                    stream: facilitiesManager.facilitiesList,
                    builder: (BuildContext context, AsyncSnapshot<ApiResponse<FacilitiesListModel>?> facilitiesListSnapshot) {
                      if (facilitiesListSnapshot.hasData) {
                        switch (facilitiesListSnapshot.data!.status) {
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
                            return facilitiesBody(context, facilitiesListSnapshot.data?.data);
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

  Widget facilitiesBody(BuildContext context, FacilitiesListModel? data) {
    if(data?.results != null && data!.results!.isEmpty) {
      return Center(child: Text("No facilities found.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),));
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: data?.results?.length??0,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => FacilityDetails(facilityId: data!.results![index].id!,),));
          },
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: data!.results![index].featuredIcon??"", fit: BoxFit.fitWidth,
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
                    child: Text(data.results?[index].title ?? "", style: TextStyle(fontFamily: "GothamBook", fontSize: 16.sp, color: const Color(0xFF080808)),),
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