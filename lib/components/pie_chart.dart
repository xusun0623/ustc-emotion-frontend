import 'package:emotion/components/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<Color> colors = [
  Color(0xff11B7CA),
  Color(0xdd11B7CA),
  Color(0xbb11B7CA),
  Color(0x9911B7CA),
  Color(0x7711B7CA),
  Color(0x5511B7CA),
  Color(0x3311B7CA),
  // Color(0xff9eca7f),
  // Color(0xfff2ca6b),
  // Color(0xffde6e6a),
  // Color(0xff85bedb),
  // Color(0xff59a076),
];

class InfoPieChart extends StatefulWidget {
  List numData;
  InfoPieChart({
    super.key,
    required this.numData,
  });

  @override
  State<StatefulWidget> createState() => InfoPieChartState();
}

class InfoPieChartState extends State<InfoPieChart> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 50),
        AspectRatio(
          aspectRatio: 1.4,
          child: AspectRatio(
            aspectRatio: 1,
            child: Transform.scale(
              scale: 1.4,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getRatio(index) {
    List numData = widget.numData;
    double total = 0;
    for (var i = 0; i < numData.length; i++) {
      total += double.parse(numData[i].toString());
    }
    return ((double.parse(numData[index].toString()) / total) * 100)
        .toStringAsFixed(0);
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: colors[0],
            value: double.parse(widget.numData[0].toString()),
            title: '${getRatio(0)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              '🥰',
              size: widgetSize,
              borderColor: colors[0],
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: colors[1],
            value: double.parse(widget.numData[1].toString()),
            title: '${getRatio(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              '😋',
              size: widgetSize,
              borderColor: colors[1],
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: colors[2],
            value: double.parse(widget.numData[2].toString()),
            title: '${getRatio(2)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              '🤤',
              size: widgetSize,
              borderColor: colors[2],
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: colors[3],
            value: double.parse(widget.numData[3].toString()),
            title: '${getRatio(3)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              '😅',
              size: widgetSize,
              borderColor: colors[3],
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: colors[4],
            value: double.parse(widget.numData[4].toString()),
            title: '${getRatio(4)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              '🥵',
              size: widgetSize,
              borderColor: colors[4],
            ),
            badgePositionPercentageOffset: .98,
          );
        case 5:
          return PieChartSectionData(
            color: colors[5],
            value: double.parse(widget.numData[5].toString()),
            title: '${getRatio(5)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgeWidget: _Badge(
              '🤡',
              size: widgetSize,
              borderColor: colors[5],
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(
          svgAsset,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
