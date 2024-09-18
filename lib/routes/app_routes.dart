part of 'app_pages.dart';

abstract class Routes{
  Routes._();
  static const LOGIN= _Paths.LOGIN;
  static const MAINSCREEN= _Paths.MAINSCREEN;
  static const INTRODUCTION= _Paths.INTRODUCTION;



}

abstract class _Paths{
  static const LOGIN = '/login';
  static const MAINSCREEN = '/mainscreen';
  static const INTRODUCTION = '/introduction';


}
