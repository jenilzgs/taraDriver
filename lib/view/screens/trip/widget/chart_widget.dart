import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/trip/controller/trip_controller.dart';



class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<Color> gradientColors = [
    const Color(0xFF00A08D),
    const Color(0x80FFFFFF),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
        Positioned(left: 0,right: 0,
          child: AspectRatio(
            aspectRatio: 1.95,
            child: DecoratedBox(
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Padding(padding: const EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12,),
                child: GetBuilder<TripController>(
                  builder: (tripController) {
                    return LineChart(mainData(tripController.earningChartList, tripController.maxValue));
                  }
                ))))),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.normal, fontSize: 12);
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('', style: style);
        break;
      case 1:
        text = const Text('Sun', style: style);
        break;
      case 2:
        text = const Text('Mon', style: style);
        break;
      case 3:
        text = const Text('Tue', style: style);
        break;
      case 4:
        text = const Text('Wed', style: style);
        break;
      case 5:
        text = const Text('Thu', style: style);
        break;
      case 6:
        text = const Text('Fri', style: style);
        break;
      case 7:
        text = const Text('Sat', style: style);
        break;

      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  LineChartData mainData(List<FlSpot>? spots, double maxValue) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 0);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 0);
        },
      ),
      titlesData: FlTitlesData(show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false),),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: bottomTitleWidgets,)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: maxValue/5 <=0? 1 : maxValue/5, reservedSize: 50))),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 8,
      minY: 0,
      maxY: maxValue,
      lineBarsData: [
        LineChartBarData(
          spots: spots??[],
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true,),
          belowBarData: BarAreaData(show: true,
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: gradientColors.map((color) => color.withOpacity(0.15)).toList()),
          ),
        ),
      ],
    );
  }
}