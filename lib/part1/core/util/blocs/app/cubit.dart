import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:booking_app/part1/core/models/current_weather_model.dart';
import 'package:booking_app/part1/core/models/hotel_model.dart';
import 'package:booking_app/part1/core/models/login_model.dart';
import 'package:booking_app/part1/core/models/profile_model.dart';
import 'package:booking_app/part1/core/models/task_model.dart';
import 'package:booking_app/part1/core/util/blocs/app/states.dart';
import 'package:booking_app/part1/core/util/network/remote/dio_helper.dart';
import 'package:booking_app/part1/core/util/network/remote/end_points.dart';
import 'package:booking_app/part1/core/util/network/repository.dart';

class AppBloc extends Cubit<AppStates> {
  final Repository repository;


  AppBloc({
    required this.repository,
  }) : super(AppInitialState());

  static AppBloc get(context) => BlocProvider.of<AppBloc>(context);

  LoginModel? loginModel;

  Future userLogin() async {
    emit(UserLoginLoadingState());

    final response = await repository.login(
      email: 'abdullah.osama@gmail.com',
      password: '123456',
    );

    response.fold(
      (l) {
        emit(ErrorState(exception: l));
      },
      (r) {
        loginModel = r;

        emit(UserLoginSuccessState());
      },
    );
  }

  ProfileModel? profileModel;

  void userProfile() async {
    emit(UserProfileLoadingState());

    final response = await repository.getProfile(
      token: loginModel!.data!.token,
    );

    response.fold(
          (l) {
        emit(ErrorState(exception: l));
      },
          (r) {
            profileModel = r;

        emit(UserProfileSuccessState());
      },
    );
  }

  List<HotelModel> hotels = [];

  void getHotels() async {
    emit(HotelsLoadingState());

    final response = await repository.getHotels(
      page: 1,
    );

    response.fold(
          (l) {
        emit(ErrorState(exception: l));
      },
          (r) {
            hotels = r.data!.data;

        emit(HotelsSuccessState());
      },
    );
  }
}
