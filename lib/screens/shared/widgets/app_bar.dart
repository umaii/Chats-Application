import 'package:chatz/constants/colors.dart';
import 'package:chatz/constants/text_styles.dart';
import 'package:chatz/routes/router.dart';
import 'package:chatz/screens/shared/widgets/app_bar_loading.dart';
import 'package:chatz/screens/shared/widgets/app_elevated_btn.dart';
import 'package:chatz/screens/shared/widgets/app_outline_btn.dart';
import 'package:chatz/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({
    Key? key,
    this.leading,
    required this.title,
    this.withProfile = true,
  }) : super(key: key);

  final Widget? leading;
  final Widget title;
  final bool? withProfile;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _CustomAppbarState extends State<CustomAppbar> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _profileStream;

  @override
  void initState() {
    _profileStream = FirebaseService().getCurrentUser()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _profileStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppBarLoading(leading: widget.leading, title: widget.title);
          }

          if (snapshot.data == null) {
            return AppBarLoading(leading: widget.leading, title: widget.title);
          }

          if (snapshot.hasData) {
            var data = snapshot.data;
            var imgUrl = data?.data()!['imgUrl'];
            return AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              leading: widget.leading,
              iconTheme: const IconThemeData(
                color: ConstColors.black87,
              ),
              actions: [
                widget.withProfile == true
                    ? InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.profileScreen,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Hero(
                            tag: 'profileImg',
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(imgUrl),
                              backgroundColor: ConstColors.lightBlueCyan,
                            ),
                          ),
                        ))
                    : IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                '${AppLocalizations.of(context)!.sureToLogOut}?',
                                style: TextStyles.style14,
                              ),
                              actions: [
                                AppOutlineBtn(
                                  text: AppLocalizations.of(context)!.cancel,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: AppElevatedBtn(
                                    text:
                                        AppLocalizations.of(context)!.xContinue,
                                    function: () {
                                      FirebaseService().signOut().then(
                                          (value) =>
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  AppRouter.landingScreen,
                                                  (route) => false));
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowRightFromBracket,
                        ),
                      )
              ],
              title: widget.title,
              titleTextStyle: TextStyles.style16Bold.copyWith(
                color: ConstColors.black87,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
