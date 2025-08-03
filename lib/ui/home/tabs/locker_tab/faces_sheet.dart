import 'package:cached_network_image/cached_network_image.dart';
import 'package:cobble/domain/db/models/app.dart';
import 'package:flutter/material.dart';
import 'package:cobble/ui/common/components/cobble_button.dart';
import 'package:cobble/ui/common/icons/fonts/rebble_icons.dart';
import 'package:cobble/ui/common/components/cobble_divider.dart';
import 'package:cobble/ui/common/components/cobble_tile.dart';
import 'package:cobble/localization/localization.dart';
import 'package:cobble/ui/common/components/cobble_sheet.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cobble/ui/theme/with_cobble_theme.dart';
import 'package:cobble/domain/entities/hardware_platform.dart';

import '../../../../domain/logging.dart';

class FacesPreview extends StatelessWidget {
  FacesPreview(
      {required this.face,
      this.compatible = false,
      this.extended = false,
      this.circleConnected,
      this.listUrl});

  final App face;
  final bool compatible;
  final bool extended;
  final bool? circleConnected;
  final String? listUrl;

  @override
  Widget build(BuildContext context) {
    bool circleWatchface = false;
    bool circleOnly = face.supportedHardware.length == 1 &&
        face.supportedHardware[0] == WatchType.chalk;
    circleWatchface =
        compatible && (circleConnected ?? false) || !compatible && circleOnly;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(circleWatchface ? 46.0 : 6.0),
          child: listUrl == null
              ? Image(
                  image: const Svg('images/temp_watch_face.svg'),
                  width: 92,
                  height: circleWatchface ? 92 : 108,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: listUrl!,
                  width: 92,
                  height: circleWatchface ? 92 : 108,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  errorListener: (e) {
                    Log.e("Error loading face image: $e");
                  },
                  placeholder: (context, url) => Image(
                    image: const Svg('images/temp_watch_face.svg'),
                    width: 92,
                    height: circleWatchface ? 92 : 108,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          face.longName + (extended ? " ${face.version}" : ""),
          style: context.textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          face.company,
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.textTheme.bodyMedium!.color!.withOpacity(
              context.scheme!.muted.opacity,
            ),
          ),
        ),
      ],
    );
  }
}

class FacesSheet {
  static void showModal({
    required BuildContext context,
    required App face,
    bool compatible = false,
    //required AppManager appManager,
    PebbleWatchLine? lineConnected,
    bool? circleConnected,
    String? listUrl,
  }) {
    CobbleSheet.showModal(
      context: context,
      builder: (context) => Column(
        children: [
          const SizedBox(height: 8),
          FacesPreview(
            listUrl: listUrl,
            face: face,
            compatible: compatible,
            extended: true,
            circleConnected: (circleConnected ?? false),
          ),
          const SizedBox(height: 4),
          // TODO: Implement getting metadata from the store (including the preview)
          if (face.appstoreId != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CobbleButton(
                  outlined: false,
                  icon: RebbleIcons.rebble_store,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                CobbleButton(
                  outlined: false,
                  icon: RebbleIcons.health_heart,
                  label: "0",
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                CobbleButton(
                  outlined: false,
                  icon: RebbleIcons.share,
                  onPressed: () => Share.share(
                    "https://store-beta.rebble.io/app/${face.appstoreId}",
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          CobbleDivider(),
          if (compatible)
            Container(
              child: Column(
                children: [
                  CobbleTile.action(
                    leading: RebbleIcons.send_to_watch_unchecked,
                    title: tr.lockerPage.apply,
                    onTap: () {},
                  ),
                  CobbleDivider(),
                  // TODO: Implement permissions
                  CobbleTile.action(
                    leading: RebbleIcons.permissions,
                    title: tr.lockerPage.permissions,
                    onTap: () {},
                  ),
                  CobbleTile.action(
                    leading: RebbleIcons.settings,
                    title: tr.lockerPage.faceSettings,
                    onTap: () {},
                  ),
                ],
              ),
            )
          else
            CobbleTile.action(
              leading: RebbleIcons.unpair_from_watch,
              title: tr.lockerPage.notCompatible(
                watch: stringFromWatchLine(
                  lineConnected ?? PebbleWatchLine.unknown,
                ),
              ),
              onTap: () {},
            ),
          CobbleDivider(),
          CobbleTile.action(
            leading: RebbleIcons.delete_trash,
            title: tr.lockerPage.delete,
            onTap: () {
              //appManager.deleteApp(face.uuid);
            },
          ),
        ],
      ),
    );
  }
}
