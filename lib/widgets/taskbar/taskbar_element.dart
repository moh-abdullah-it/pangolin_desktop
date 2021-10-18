/*
Copyright 2021 The dahliaOS Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import 'package:flutter/material.dart';
import 'package:pangolin/components/shell/shell.dart';
import 'package:pangolin/utils/data/common_data.dart';

class TaskbarElement extends StatefulWidget {
  const TaskbarElement({
    Key? key,
    required this.child,
    this.overlayID,
    this.size,
  }) : super(key: key);

  final Widget child;
  final String? overlayID;
  final Size? size;

  @override
  _TaskbarElementState createState() => _TaskbarElementState();
}

class _TaskbarElementState extends State<TaskbarElement> {
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _accentColor = _theme.colorScheme.secondary;
    final _shell = Shell.of(context);
    final _darkMode = _theme.brightness == Brightness.dark;
    final _borderRadius =
        CommonData.of(context).borderRadius(BorderRadiusType.SMALL);
    return SizedBox.fromSize(
      size: widget.size ?? Size(48, 48),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: _borderRadius,
          child: ValueListenableBuilder<bool>(
            valueListenable: widget.overlayID != null
                ? _shell.getShowingNotifier(widget.overlayID!)
                : ValueNotifier(false),
            builder: (context, showing, child) {
              return IconTheme.merge(
                data: IconThemeData(
                  color: showing
                      ? _accentColor.computeLuminance() < 0.3
                          ? const Color(0xffffffff)
                          : const Color(0xff000000)
                      : _darkMode
                          ? const Color(0xffffffff)
                          : const Color(0xff000000),
                ),
                child: InkWell(
                  borderRadius: _borderRadius,
                  hoverColor: _accentColor.withOpacity(0.5),
                  mouseCursor: SystemMouseCursors.click,
                  onTap: () => widget.overlayID != null
                      ? _shell.toggleOverlay(widget.overlayID!)
                      : {},
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: showing
                          ? _accentColor.computeLuminance() < 0.3
                              ? const Color(0xffffffff)
                              : const Color(0xff000000)
                          : _darkMode
                              ? const Color(0xffffffff)
                              : const Color(0xff000000),
                    ),
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      color: showing ? _accentColor : Colors.transparent,
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
