import 'dart:async';
import 'package:rxdart/rxdart.dart';

class NavBarManager{
  final _navIndex = BehaviorSubject<int?>();
  Stream<int?> get navIndexStream => _navIndex.stream;
  StreamSink<int?> get navIndexSink => _navIndex.sink;

  updateNavIndex(int index){
    navIndexSink.add(index);
  }

  reset(){
    navIndexSink.add(null);
  }

  dispose(){
    _navIndex.close();
  }
}

final NavBarManager navManager = NavBarManager();