import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Line_Chart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<TooltipData> tooltipData;
  final String selectedPeriod;
  final Color lineColor;

  Line_Chart({
    required this.spots,
    required this.tooltipData,
    required this.selectedPeriod,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return Center(child: Text('No data available'));
    }

    final double minValue = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final double maxValue = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final double yRange = maxValue - minValue;
    final double padding = yRange * 0.5;

    final double minY = minValue - padding;
    final double maxY = maxValue + padding;

    final double minX = spots.first.x - 0.1;
    final double maxX = spots.last.x + 0.1;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1500),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            horizontalInterval: yRange / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: yRange / 5,
                getTitlesWidget: (value, meta) {
                  if (value != minY && value != maxY) {
                    String formattedValue;
                    if (value >= 1000 || value * -1 >= 1000) {
                      formattedValue = '${(value / 1000).toStringAsFixed(2)}k';
                    } else {
                      formattedValue = value.toStringAsFixed(2);
                    }

                    return Text(
                      formattedValue,
                      style: TextStyle(fontSize: 8),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 20,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: lineColor,
              barWidth: 2.5,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withOpacity(0.3),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchSpotThreshold: 20,
            touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 8,
              tooltipMargin: 8,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final TooltipData data = tooltipData.firstWhere((e) => e.time == spot.x);
                  return LineTooltipItem(
                    '${data.timeString}\n${spot.y.toStringAsFixed(2)} USD',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
              if (touchResponse == null || event is! FlPanEndEvent) {
                return;
              }
            },
          ),
        ),
        key: ValueKey<String>(selectedPeriod),
      ),
    );
  }
}

class TooltipData {
  final String timeString;
  final double time;
  final double value;

  TooltipData(this.timeString, this.time, this.value);
}
