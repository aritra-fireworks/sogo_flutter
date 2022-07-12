import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/transaction_manager/transaction_manager.dart';
import 'package:sogo_flutter/src/models/transactions/transaction_history_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/transaction_history/transaction_details.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';

class TransactionHistoryView extends StatefulWidget {
  final String memberId;
  const TransactionHistoryView({Key? key, required this.memberId}) : super(key: key);

  @override
  State<TransactionHistoryView> createState() => _TransactionHistoryViewState();
}

class _TransactionHistoryViewState extends State<TransactionHistoryView> {

  String? currentMonth;
  String? selectedMonth;
  int? currentYear;
  int? selectedYear;
  int archive = 0;

  @override
  void initState() {
    super.initState();
    currentMonth = ApplicationGlobal.months[DateTime.now().month-1];
    currentYear = DateTime.now().year;
    selectedMonth = currentMonth;
    selectedYear = currentYear;
    transactionManager.getTransactionsList(archive: archive, month: DateTime.now().month, year: currentYear);
  }


  @override
  Widget build(BuildContext buildContext) {
    return KeyboardDismissWrapper(
      child: OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
          if (connectivity == ConnectivityResult.none) {
            return const Scaffold(
              body: Center(child: NetworkErrorPage()),
            );
          }
          return child;
        },
        child: Stack(
          fit: StackFit.loose,
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
                    Navigator.pop(buildContext);
                  },
                ),
                centerTitle: true,
                title: Text("Transaction History", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
              ),
              body: StreamBuilder<ApiResponse<TransactionHistoryModel>?>(
                  stream: transactionManager.transactionsList,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<TransactionHistoryModel>?> snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
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
                          debugPrint('Profile Loaded');
                          return transactionHistoryBody(buildContext, snapshot.data?.data);
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
          ],
        ),
      ),
    );
  }

  Widget transactionHistoryBody(BuildContext context, TransactionHistoryModel? transactionsData) {
    if(transactionsData?.result == null || transactionsData!.result!.isEmpty){
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
        ),
        child: Column(
          children: [
            filterBar(),
            Expanded(child: Center(child: Text("No transactions found", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),))),
          ],
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          filterBar(),
          Expanded(
            child: ListView.builder(
              itemCount: transactionsData.result![0].data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailsView(memberId: widget.memberId, type: transactionsData.result![0].data![index].type??"", transactionId: transactionsData.result![0].data![index].id??""),));
                  },
                  child: transactionTile(data: transactionsData.result![0].data![index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget filterBar() {
    return Container(
      height: 35.h,
      margin: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.textBlack, width: 1.sp),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: (){
                        openBottomSheet(ApplicationGlobal.months, (value){
                          selectedMonth = ApplicationGlobal.months[value];
                          transactionManager.getTransactionsList(archive: archive, month: value+1, year: selectedYear ?? currentYear,);
                        });
                      },
                      style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap, padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Text(selectedMonth??"",style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: const Color(0xFF636363))),
                    ),
                  ),
                  Image.asset('assets/images/ic_filter.png', height: 20.h, color: const Color(0xFF636363), fit: BoxFit.fitHeight,),
                  Expanded(
                    child: TextButton(
                      onPressed: (){
                        List<String> yearList = List.generate(4, (index) => (currentYear!-index).toString());
                        openBottomSheet(yearList, (value){
                          selectedYear = int.parse(yearList[value]);
                          transactionManager.getTransactionsList(archive: archive, month: selectedMonth != null ? ApplicationGlobal.months.indexWhere((element) => element == selectedMonth)+1 : DateTime.now().month, year: selectedYear);
                        });
                      },
                      style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap, padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Text(selectedYear.toString(),style:TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: const Color(0xFF636363))),
                    ),
                  )
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if(value == "Archive"){
                archive = 1;
                transactionManager.getTransactionsList(archive: archive, month: selectedMonth != null ? ApplicationGlobal.months.indexWhere((element) => element == selectedMonth)+1 : DateTime.now().month, year: selectedYear);
              } else {
                archive = 0;
                transactionManager.getTransactionsList(archive: archive, month: selectedMonth != null ? ApplicationGlobal.months.indexWhere((element) => element == selectedMonth)+1 : DateTime.now().month, year: selectedYear);
              }
            },
            icon: Image.asset("assets/images/ic_menu_vertical.png", height: 30.h, fit: BoxFit.fitHeight,),
            padding: EdgeInsets.symmetric(vertical: 4.h),
            itemBuilder: (BuildContext context) {
              String choice = ["Archive", "Unarchive"][archive];
              return [PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              )];
            },
          ),
        ],
      ),
    );
  }

  openBottomSheet(List<String> list, Function(int) onTap) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (context) {
          return listSelect(list, onTap);
        });
  }

  Widget listSelect(List<String> list, Function(int) onTap){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      itemBuilder: (context, index) => InkWell(onTap: (){
        onTap(index);
        Navigator.pop(context);
      }, child: Center(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Text(list[index], style: TextStyle(fontFamily: (list[index] == selectedYear.toString() || list[index] == selectedMonth) ? "GothamBold" : "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),),
      ))),
    );
  }

  Widget transactionTile({required TransactionDatum data}) {
    Color pointsTextColor = const Color(0xFF44A356);
    if(data.points?.contains("-")??false){
      pointsTextColor = Colors.red;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset("assets/images/ic_gift_box.png", width: 30.w, fit: BoxFit.fitWidth,),
              SizedBox(width: 20.w,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h,),
                    Text(data.name??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 14.sp, color: const Color(0xFF636363),),),
                    SizedBox(height: 15.h,),
                    Row(
                      children: [
                        Expanded(
                          child: Text(data.date2??"", style: TextStyle(fontFamily: "GothamBook", fontSize: 13.sp, color: const Color(0xFF636363),),),
                        ),
                        Flexible(
                          flex: 0,
                          child: Text("${data.points??""}${(data.points?.contains("-")??false) || (data.points?.contains("+")??false) ? " PTS" : ""}", style: TextStyle(fontFamily: "GothamBold", fontSize: 13.sp, color: pointsTextColor,),),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Divider(color: const Color(0xFFEDEDED), height: 1.sp, thickness: 1.sp,),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
