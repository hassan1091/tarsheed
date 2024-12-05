import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tarsheed/models/device.dart';
import 'package:tarsheed/modules/home/blocs/home_bloc/home_bloc.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';
import 'package:tarsheed/shared/widgets/gradient_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TextEditingController roomController;
  int selectedRoom = 0;

  static const List<IconData> icons = [
    Icons.home_outlined,
    Icons.kitchen,
    Icons.chair_outlined,
    Icons.bed_outlined
  ];
  static const List<String> categories = [
    "All Rooms",
    "Kitchen",
    "Living Room",
    "Bedroom"
  ];

  @override
  void initState() {
    roomController = TextEditingController(text: "All Rooms");
    super.initState();
  }

  @override
  void dispose() {
    roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: _homeListener,
      builder: (context, state) {
        List<Device> devices = state.props
            .where(
              (element) =>
                  selectedRoom == 0 || element.room == categories[selectedRoom],
            )
            .toList();
        int totalUsage = 0;
        for (Device d in devices) {
          totalUsage += d.usage;
        }

        return RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: ListView(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: icons.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index != icons.length - 1 ? 8 : 0,
                      ),
                      child: _RoomCard(
                        icon: icons[index],
                        category: categories[index],
                        isSelected: index == selectedRoom,
                        onTap: () {
                          setState(() {
                            selectedRoom = index;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(
                thickness: 0.5,
                indent: 50,
                endIndent: 50,
              ),
              _EnergyCard(usage: totalUsage),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateTime.now().toIso8601String().substring(0, 10),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
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
                  return _DeviceCard(device: devices[index]);
                },
                itemCount: devices.length,
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
    String description = "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SimpleDialog(
        title: const Text("Link New Device"),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        backgroundColor: Theme.of(context).primaryColor,
        children: [
          const Text("Device Code *"),
          TextFormField(
            onChanged: (value) {
              input = value;
            },
          ),
          const Gap(2),
          const Text("Device Description"),
          TextFormField(
            maxLength: 24,
            onChanged: (value) {
              description = value;
            },
          ),
          const Gap(2),
          Align(
            child: DropdownMenu(
              controller: roomController,
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                  value: "All Rooms",
                  label: "All Rooms",
                ),
                DropdownMenuEntry(
                  value: "Kitchen",
                  label: "Kitchen",
                ),
                DropdownMenuEntry(
                  value: "Living Room",
                  label: "Living Room",
                ),
                DropdownMenuEntry(
                  value: "Bedroom",
                  label: "Bedroom",
                ),
              ],
            ),
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
                    if (input.isEmpty) return;
                    Navigator.pop(context); // Close the Simple Dialog
                    context.read<HomeBloc>().add(AddLinkHomeEvent(
                          input,
                          description,
                          roomController.text,
                        ));
                  },
                  child: const Text("confirm")),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final IconData icon;
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoomCard({
    required this.icon,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: InkWell(
        onTap: onTap,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaY: isSelected ? 0 : 2,
            tileMode: TileMode.repeated,
          ),
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GradientCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 128),
                  Text(
                    category,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                Text("$usage kWh"),
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
    IconData deviceIcon = switch (device.name) {
      "AC" => Icons.ac_unit,
      _ => Icons.lightbulb_outline,
    };
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
                    deviceIcon,
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
              const Gap(0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      device.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: color),
                      softWrap: true,
                    ),
                    Text(
                      "${device.usage} kWh",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: color),
                      softWrap: true,
                    ),
                  ],
                ),
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
    if (context.read<HomeBloc>().state is! HomeLoadingState) {
      context.read<HomeBloc>().add(ToggleSwitchEvent(device, value));
    }
  }
}
