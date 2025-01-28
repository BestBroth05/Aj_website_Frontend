import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:guadalajarav2/main.dart';
import 'package:guadalajarav2/utils/about_us/about_us_handler.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/about_view/about_project_tile.dart';

class AboutOurProjects extends StatefulWidget {
  AboutOurProjects({Key? key}) : super(key: key);

  @override
  State<AboutOurProjects> createState() => _AboutOurProjectsState();
}

class _AboutOurProjectsState extends State<AboutOurProjects> {
  List<ImageProvider> images = [];
  Map<String, int> values = {};

  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      String manifestJson =
          await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      Iterable<String> imagesIt = json
          .decode(manifestJson)
          .keys
          .where((String key) => key.startsWith('assets/images/projects'));
      values = await getProjectLikes();
      Map<String, String> noValues = {};
      for (String image in imagesIt) {
        String imgStr = image.replaceAll('%20', ' ');
        // images.add(AssetImage(imgStr));
        imgStr = imgStr.replaceAll('assets/images/projects/', '');
        if (values.containsKey(imgStr)) {
        } else {
          noValues.putIfAbsent(
            noValues.length.toString(),
            () => imgStr,
          );
          values.putIfAbsent(
            noValues.length.toString(),
            () => 0,
          );
        }

        if (prefs.containsKey(imgStr)) {
        } else {
          prefs.setBool(imgStr, false);
        }
      }

      if (noValues.isNotEmpty) {
        await putProjectLikes(noValues);
      }

      List<MapEntry<String, int>> v = values.entries.toList();
      v.sort(
        (a, b) => a.value.compareTo(b.value),
      );

      v = v.reversed.toList();

      values = Map.fromEntries(v);

      // for (MapEntry<String, int> entry in v) {
      //   images.add(AssetImage('assets/images/projects/' + entry.key));
      // }
      for (var i = 1; i < 21; i++) {
        images
            .add(AssetImage("assets/images/projects/" + i.toString() + ".jpg"));
      }

      setState(() {
        //images.removeRange(20, 40);
      });
    });
  }

  int hoveringIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GridView.custom(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 8,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          // repeatPattern: QuiltedGridRepeatPattern.inverted,
          pattern: [
            QuiltedGridTile(2, 2),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(3, 2),
            QuiltedGridTile(2, 2),
            QuiltedGridTile(2, 2),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 1),
            QuiltedGridTile(1, 1),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) => AboutProjectTile(
            images[index],
            onTap: () async {
              MapEntry<String, int> entry = values.entries.elementAt(index);
              bool liked = prefs.getBool(entry.key)!;
              if (liked) {
                values[entry.key] = entry.value - 1;
              } else {
                values[entry.key] = entry.value + 1;
              }
              setState(() {
                prefs.setBool(entry.key, !liked);
              });

              patchProjectLikes({entry.key: values[entry.key]!});
            },
            likes: values.entries.elementAt(index).value,
            liked: prefs.getBool(values.entries.elementAt(index).key)!,
          ),
          childCount: images.length,
        ),
      ),
    );
  }
}
