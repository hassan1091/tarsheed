import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/models/device.dart';
import 'package:tarsheed/modules/home/blocs/home_bloc/home_bloc.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';
import 'package:tarsheed/shared/widgets/gradient_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: _homeListener,
      builder: (context, state) {
        int totalUsage = 0;
        for (Device d in state.props) {
          totalUsage += d.usage;
        }
        return RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: ListView(
            children: [
              _EnergyCard(usage: totalUsage),
              const Gap(8),
              const Divider(
                thickness: 0.5,
                indent: 50,
                endIndent: 50,
              ),
              IconButton(
                  onPressed: () => _addLink(context),
                  icon: const Icon(
                    Icons.add_link,
                    size: 42,
                    color: Colors.white,
                  )),
              GridView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(
                    parent: ClampingScrollPhysics()),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 215),
                itemBuilder: (context, index) {
                  return _DeviceCard(device: state.props[index]);
                },
                itemCount: state.props.length,
              )
            ],
          ),
        );
      },
    );
  }

  void _homeListener(BuildContext context, HomeState state) {
    if (state is HomeLoadingState) {
      AppTheme.showLoadingDialog(context);
    } else if (state is HomeSuccessState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, 'Device loading successful!');
    } else if (state is HomeErrorState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, state.message);
    }
  }

  Future<void> _refresh(BuildContext context) async {
    context.read<HomeBloc>().add(LoadHomeEvent());
  }

  void _addLink(BuildContext context) {
    String input = "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimpleDialog(
        title: const Text("Link New Device"),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Theme.of(context).primaryColor,
        children: [
          const Text("Device Code"),
          TextFormField(
            onChanged: (value) {
              input = value;
            },
          ),
          const Gap(2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the Simple Dialog
                  },
                  child: const Text("cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the Simple Dialog
                    context.read<HomeBloc>().add(AddLinkHomeEvent(input));
                  },
                  child: const Text("confirm")),
            ],
          ),
        ],
      ),
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

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
  });

  final Device device;

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors;
    Color color;
    if (device.isOn()) {
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
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return Switch.adaptive(
                        value: device.isOn(),
                        onChanged: (value) => toggleSwitch(context, value),
                      );
                    },
                  ),
                ],
              ),
              const Gap(8),
              Text(
                device.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: color),
                softWrap: true,
              ),
              Text(
                device.description,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: color),
                softWrap: true,
              ),
              Text(
                device.id,
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

  void toggleSwitch(BuildContext context, value) {
    context.read<HomeBloc>().add(ToggleSwitchEvent(device, value));
  }
}
