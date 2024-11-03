import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/widgets/gradient_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Example
    return ListView(
      children: [
        const _EnergyCard(usage: 0),
        const Gap(8),
        const Divider(
          thickness: 0.5,
          indent: 50,
          endIndent: 50,
        ),
        const Gap(8),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 215),
          itemBuilder: (context, index) => const _DeviceCard(
            isOn: true,
            name: "Light",
            description: "Phillips hue",
          ),
          itemCount: 5,
        )
      ],
    );
  }
}

class _EnergyCard extends StatelessWidget {
  const _EnergyCard({this.usage = 0});

  final int usage;

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.energy_savings_leaf_outlined,
              size: 48,
            ),
            const Gap(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$usage k"),
                const Text("Energy Usage"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceCard extends StatefulWidget {
  const _DeviceCard(
      {this.isOn = true,
      this.name = "Light",
      this.description = "Phillips hue"});

  final bool isOn;
  final String name;
  final String description;

  @override
  State<_DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<_DeviceCard> {
  late bool isOn;

  @override
  void initState() {
    isOn = widget.isOn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors;
    Color color;
    if (isOn) {
      gradientColors = const [Color(0x3B3A4Fff), Color(0x46475Eff)];
      color = Colors.white;
    } else {
      gradientColors = [
        Theme.of(context).disabledColor,
        const Color(0x46475Eff),
        const Color(0x46475Eff),
        const Color(0x46475Eff),
        Theme.of(context).disabledColor,
      ];
      color = Theme.of(context).disabledColor;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GradientCard(
        gradientColors: gradientColors,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 48,
                    color: color,
                  ),
                  Switch.adaptive(
                    value: isOn,
                    onChanged: toggleSwitch,
                  ),
                ],
              ),
              const Gap(8),
              Text(
                widget.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: color),
                softWrap: true,
              ),
              Text(
                widget.description,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: color),
                softWrap: true,
              )
            ],
          ),
        ),
      ),
    );
  }

  void toggleSwitch(bool value) {
    setState(() {
      isOn = value;
    });
  }
}
