import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/common/apis/api.dart';
import 'package:flutter_rss_reader/common/utils/utils.dart';
import 'package:flutter_rss_reader/global.dart';
import 'package:flutter_rss_reader/pages/application/floatingActionButton.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BodyWidget extends StatefulWidget {
  PanelController panelController;
  BodyWidget(PanelController controller) {
    this.panelController = controller;
  }
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final double _minPanelHeight = 35;
    final double _maxPanelHeight = height / 2.3;

    return Container(
      child: SlidingUpPanel(
        controller: widget.panelController,
        minHeight: _minPanelHeight,
        maxHeight: _maxPanelHeight,
        backdropEnabled: true,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        onPanelClosed: () {
          Global.appState.changePanelOpen(false);
        },
        onPanelOpened: () {
          Global.appState.changePanelOpen(true);
        },
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Center(
                    child: Text("这么是页面区"),
                  ),
                  FlatButton(
                    onPressed: () {
                      widget.panelController.open();
                    },
                    child: Text("test"),
                  ),
                ],
              ),
            ),
          ],
        ),
        panel: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: _minPanelHeight / 1.5,
                    width: size.width,
                    child: FlatButton(
                      onPressed: () {
                        if (widget.panelController.isPanelOpen()) {
                          widget.panelController.close();
                        } else if (widget.panelController.isPanelClosed()) {
                          widget.panelController.open();
                        }
                      },
                      child: Center(
                        child: Container(
                          height: 5,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Global.appState.panelOpen
                                ? Colors.blue
                                : Colors.grey[300],
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
                height: 5,
              ),
              Container(
                child: Wrap(
                  spacing: 8.0,
                  children: Global.appState.showCategory.rssSettings
                      .map((rssSetting) {
                    var index = Global.appState.showCategory.rssSettings
                        .indexOf(rssSetting);
                    return ActionChip(
                      label: Text(rssSetting.rssName),
                      labelStyle: TextStyle(
                        color: Global.appState.showRssOpened(index)
                            ? Colors.white
                            : Colors.black,
                      ),
                      backgroundColor: Global.appState.showRssOpened(index)
                          ? Colors.blue
                          : Colors.grey[300],
                      onPressed: () {
                        Global.appState.changeShowRssOpened(index);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
