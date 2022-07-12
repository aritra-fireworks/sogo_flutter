import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/transaction_manager/transaction_manager.dart';
import 'package:sogo_flutter/src/models/transactions/transaction_details_model.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';

class TransactionDetailsView extends StatefulWidget {
  final String memberId;
  final String type;
  final String transactionId;
  const TransactionDetailsView({Key? key, required this.type, required this.transactionId, required this.memberId}) : super(key: key);

  @override
  State<TransactionDetailsView> createState() => _TransactionDetailsViewState();
}

class _TransactionDetailsViewState extends State<TransactionDetailsView> {

  @override
  void initState() {
    super.initState();
    transactionManager.getTransactionDetails(type: widget.type, transactionId: widget.transactionId);
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
              body: StreamBuilder<ApiResponse<TransactionDetailsModel>?>(
                  stream: transactionManager.transactionDetails,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<TransactionDetailsModel>?> snapshot) {
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
                          return transactionDetailsBody(buildContext, snapshot.data?.data);
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

  Widget transactionDetailsBody(BuildContext context, TransactionDetailsModel? data) {
    Color pointsTextColor = const Color(0xFF44A356);
    if(data?.points?.contains("-")??false){
      pointsTextColor = Colors.red;
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          children: [
            detailTile(title: "Member ID", value: widget.memberId),
            (data?.receiptNo?.isNotEmpty??false) ? detailTile(title: "Receipt No.", value: data?.receiptNo??"") : const SizedBox(),
            detailTile(title: "Date", value: data?.date??""),
            detailTile(title: "Title", value: data?.name??""),
            detailTile(title: "Status", value: data?.status??""),
            Divider(color: const Color(0xFFEDEDED), height: 60.sp, thickness: 1.sp,),
            detailTile(title: "Points", value: "${data?.points??""}${(data?.points?.contains("-")??false) || (data?.points?.contains("+")??false) ? " PTS" : ""}", valueColor: pointsTextColor),
            detailTile(title: "Remarks", value: data?.remarks??""),
            detailTile(title: "Type", value: data?.type??""),
          ],
        ),
      ),
    );
  }

  Widget detailTile({required String title, required String value, Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title : ', style: TextStyle(fontFamily: "GothamMedium", fontSize: 14.sp, color: AppColors.textBlack),),
          Text(value, style: TextStyle(fontFamily: "GothamRegular", fontSize: 13.sp, color: valueColor ?? AppColors.textBlack),),
        ],
      ),
    );
  }
}
