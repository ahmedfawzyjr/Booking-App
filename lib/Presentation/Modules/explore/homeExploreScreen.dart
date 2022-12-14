import 'package:booking_app/Application/Providers/themeProvider.dart';
import 'package:booking_app/Application/Utils/enum.dart';
import 'package:booking_app/Application/Utils/textStyles.dart';
import 'package:booking_app/Application/Utils/themes.dart';
import 'package:booking_app/Application/Widgets/bottomTopMoveAnimationView.dart';
import 'package:booking_app/Application/Widgets/commonButton.dart';
import 'package:booking_app/Application/Widgets/commonCard.dart';
import 'package:booking_app/Application/Widgets/commonSearchBar.dart';
import 'package:booking_app/Data/Language/appLocalizations.dart';
import 'package:booking_app/Data/Models/hotelListData.dart';
import 'package:booking_app/Presentation/Modules/explore/homeExploreSliderView.dart';
import 'package:booking_app/Presentation/Modules/explore/hotelListViewPage.dart';
import 'package:booking_app/Presentation/Modules/explore/popularListView.dart';
import 'package:booking_app/Presentation/Modules/explore/titleView.dart';
import 'package:booking_app/Presentation/Routes/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeExploreScreen extends StatefulWidget {
  final AnimationController animationController;

  const HomeExploreScreen({
    Key? key,
    required this.animationController,
  }) : super(
          key: key,
        );
  @override
  _HomeExploreScreenState createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen>
    with TickerProviderStateMixin {
  var hotelList = HotelListData.hotelList;
  late ScrollController controller;
  late AnimationController _animationController;
  var sliderImageHeight = 0.0;
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: 0,
      ),
      vsync: this,
    );
    widget.animationController.forward();
    controller = ScrollController(
      initialScrollOffset: 0.0,
    );
    controller.addListener(() {
      if (mounted) {
        if (controller.offset < 0) {
          // We Static Set the Just Below Half Scrolling Values

          _animationController.animateTo(0.0);
        } else if (controller.offset > 0.0 &&
            controller.offset < sliderImageHeight) {
          //  We Need Around Half Scrolling Values

          if (controller.offset < ((sliderImageHeight / 1.5))) {
            _animationController.animateTo(
              (controller.offset / sliderImageHeight),
            );
          } else {
            //  We Static Set the Just Above Half Scrolling Values " Around == 0.64 "

            _animationController.animateTo(
              (sliderImageHeight / 1.5) / sliderImageHeight,
            );
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    sliderImageHeight = MediaQuery.of(
          context,
        ).size.width *
        1.3;
    return BottomTopMoveAnimationView(
      animationController: widget.animationController,
      child: Consumer<ThemeProvider>(
        builder: (
          context,
          provider,
          child,
        ) =>
            Stack(
          children: <Widget>[
            Container(
              color: AppTheme.scaffoldBackgroundColor,
              child: ListView.builder(
                controller: controller,
                itemCount: 4,

                //  Padding on Top is Only for We Need Space for Sider

                padding: EdgeInsets.only(
                  top: sliderImageHeight + 32,
                  bottom: 16,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (
                  context,
                  index,
                ) {
                  //  Some List UI

                  var count = 4;
                  var animation = Tween(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval(
                        (1 / count) * index,
                        1.0,
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                  );
                  if (index == 0) {
                    return TitleView(
                      titleTxt: AppLocalizations(
                        context,
                      ).of(
                        "popular_destination",
                      ),
                      subTxt: '',
                      animation: animation,
                      animationController: widget.animationController,
                      click: () {},
                    );
                  } else if (index == 1) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),

                      // Popular Destinations Animation View

                      child: PopularListView(
                        animationController: widget.animationController,
                        callBack: (
                          index,
                        ) {},
                      ),
                    );
                  } else if (index == 2) {
                    return TitleView(
                      titleTxt: AppLocalizations(context).of(
                        "best_deal",
                      ),
                      subTxt: AppLocalizations(context).of(
                        "view_all",
                      ),
                      animation: animation,
                      isLeftButton: true,
                      animationController: widget.animationController,
                      click: () {},
                    );
                  } else {
                    return getDealListView(
                      index,
                    );
                  }
                },
              ),
            ),

            //  SliderUI with 3 Images are Moving

            _sliderUI(),

            //  View Hotels Button UI for Click Event

            _viewHotelsButton(
              _animationController,
            ),

            // Just Gradient for See the Time and Battry Icon on "TopBar"

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).backgroundColor.withOpacity(
                            0.4,
                          ),
                      Theme.of(context).backgroundColor.withOpacity(
                            0.0,
                          ),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            //   SerachUI on Top  Positioned

            Positioned(
              top: MediaQuery.of(
                context,
              ).padding.top,
              left: 0,
              right: 0,
              child: serachUI(),
            )
          ],
        ),
      ),
    );
  }

  Widget _viewHotelsButton(
    AnimationController _animationController,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        var opecity = 1.0 -
            (_animationController.value > 0.64
                ? 1.0
                : _animationController.value);
        return Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: sliderImageHeight * (1.0 - _animationController.value),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 32,
                left: context.read<ThemeProvider>().languageType ==
                        LanguageType.ar
                    ? null
                    : 24,
                right: context.read<ThemeProvider>().languageType ==
                        LanguageType.ar
                    ? 24
                    : null,
                child: Opacity(
                  opacity: opecity,
                  child: CommonButton(
                    onTap: () {
                      if (opecity != 0) {
                        NavigationServices(
                          context,
                        ).gotoHotelHomeScreen();
                      }
                    },
                    buttonTextWidget: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Text(
                        AppLocalizations(
                          context,
                        ).of(
                          "view_hotel",
                        ),
                        style: TextStyles(
                          context,
                        ).getRegularStyle().copyWith(
                              color: AppTheme.whiteColor,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sliderUI() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (
          BuildContext context,
          Widget? child,
        ) {
          //  We Calculate the Opecity Between 0.64 to 1.0

          var opecity = 1.0 -
              (_animationController.value > 0.64
                  ? 1.0
                  : _animationController.value);
          return SizedBox(
            height: sliderImageHeight * (1.0 - _animationController.value),
            child: HomeExploreSliderView(
              opValue: opecity,
              click: () {},
            ),
          );
        },
      ),
    );
  }

  Widget getDealListView(
    int index,
  ) {
    var hotelList = HotelListData.hotelList;
    List<Widget> list = [];
    hotelList.forEach((
      f,
    ) {
      var animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: widget.animationController,
          curve: Interval(
            0,
            1.0,
            curve: Curves.fastOutSlowIn,
          ),
        ),
      );
      list.add(
        HotelListViewPage(
          callback: () {
            Scaffold();
          },
          hotelData: f,
          animation: animation,
          animationController: widget.animationController,
        ),
      );
    });
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: Column(
        children: list,
      ),
    );
  }

  Widget serachUI() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
      ),
      child: CommonCard(
        radius: 36,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(
              38,
            ),
          ),
          onTap: () {
            NavigationServices(
              context,
            ).gotoSearchScreen();
          },
          child: CommonSearchBar(
            iconData: FontAwesomeIcons.search,
            enabled: false,
            text: AppLocalizations(
              context,
            ).of(
              "where_are_you_going",
            ),
          ),
        ),
      ),
    );
  }
}
