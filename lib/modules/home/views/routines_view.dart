import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/core/utils/field_validation.dart';
import 'package:tarsheed/models/routine.dart';
import 'package:tarsheed/modules/home/blocs/home_bloc/home_bloc.dart';
import 'package:tarsheed/modules/home/blocs/routines_bloc/routines_bloc.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';
import 'package:tarsheed/shared/widgets/my_text_form_field.dart';

class RoutinesView extends StatelessWidget {
  const RoutinesView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? nameStyle = Theme.of(context).textTheme.headlineSmall;
    final TextStyle? descriptionStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey);
    return BlocBuilder<RoutinesBloc, RoutinesState>(
      builder: (context, state) {
        final routines = state.props;
        return MultiBlocListener(
          listeners: [
            BlocListener<HomeBloc, HomeState>(
              listener: _homeListener,
            ),
            BlocListener<RoutinesBloc, RoutinesState>(
              listener: _routinesListener,
            ),
          ],
          child: RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: ListView.builder(
              itemCount: routines.length + 1,
              itemBuilder: (context, index) {
                if (index == routines.length) {
                  return IconButton(
                    onPressed: () => _addRoutine(context),
                    icon: const Icon(Icons.add_circle_outline),
                  );
                }
                return Card(
                  color: Colors.blueGrey.shade900,
                  shape: AppConstants.cardShape,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routines[index].name,
                              style: nameStyle,
                            ),
                            Text(
                              routines[index].description,
                              style: descriptionStyle,
                            )
                          ],
                        ),
                        IconButton(
                          onPressed: () =>
                              _editRoutine(context, routines[index]),
                          icon: const Icon(
                            Icons.mode_edit_outline_outlined,
                            size: 32,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
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
      AppTheme.showSnackBar(context, 'Routines loading successful!');
    } else if (state is HomeErrorState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, state.message);
    }
  }

  void _routinesListener(BuildContext context, RoutinesState state) {
    if (state is RoutinesLoadingState) {
      AppTheme.showLoadingDialog(context);
    } else if (state is RoutinesSuccessState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, 'Routines loading successful!');
    } else if (state is RoutinesErrorState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, state.message);
    }
  }

  Future<void> _refresh(BuildContext context) async {
    context.read<RoutinesBloc>().add(LoadRoutinesEvent());
  }

  void _addRoutine(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => HomeBloc()..add(LoadHomeEvent()),
        child: const RoutinesForm(),
      ),
    ))
        .then((value) {
      if (value is Routine) {
        context.read<RoutinesBloc>().add(AddRoutinesEvent(value));
      }
    });
  }

  void _editRoutine(BuildContext context, Routine routine) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => HomeBloc()..add(LoadHomeEvent()),
        child: RoutinesForm(routine: routine),
      ),
    ))
        .then((value) {
      if (value is Routine) {
        context.read<RoutinesBloc>().add(UpdateRoutinesEvent(value));
      }
    });
  }
}

class RoutinesForm extends StatefulWidget {
  const RoutinesForm({super.key, this.routine});

  final Routine? routine;

  @override
  State<RoutinesForm> createState() => _RoutinesFormState();
}

class _RoutinesFormState extends State<RoutinesForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController deviceController;
  late final TextEditingController actionController;
  late final TextEditingController conditionController;
  late final TextEditingController sensorController;
  late final TextEditingController valueController;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.routine?.name);
    descriptionController =
        TextEditingController(text: widget.routine?.description);
    deviceController = TextEditingController(
        text: widget.routine == null
            ? null
            : "${widget.routine?.device?.id}: ${widget.routine?.device?.name}");
    actionController = TextEditingController(text: widget.routine?.action);
    conditionController =
        TextEditingController(text: widget.routine?.condition);
    sensorController = TextEditingController(text: widget.routine?.sensor);
    valueController =
        TextEditingController(text: widget.routine?.value.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Routine")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height - kToolbarHeight * 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyTextFormField(
                  label: "Name",
                  validator: FieldValidation.validateRequired,
                  controller: nameController,
                ),
                MyTextFormField(
                  label: "Description",
                  validator: FieldValidation.validateRequired,
                  controller: descriptionController,
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    List<DropdownMenuEntry> dropMenu = List.generate(
                      state.props.length,
                      (index) => DropdownMenuEntry(
                        value: state.props[index].id,
                        label:
                            "${state.props[index].id}: ${state.props[index].name}",
                      ),
                    );
                    return DropdownMenu(
                      label: const Text("Device"),
                      controller: deviceController,
                      expandedInsets: const EdgeInsets.all(0),
                      dropdownMenuEntries: dropMenu,
                    );
                  },
                ),
                DropdownMenu(
                  label: const Text("Action"),
                  controller: actionController,
                  expandedInsets: const EdgeInsets.all(0),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: "Turn off", label: "Turn off"),
                    DropdownMenuEntry(value: "Turn on", label: "Turn on"),
                  ],
                ),
                DropdownMenu(
                  label: const Text("Condition"),
                  controller: conditionController,
                  expandedInsets: const EdgeInsets.all(0),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: "Equal to",
                      label: "Equal to",
                    ),
                    DropdownMenuEntry(
                      value: "Greater Than",
                      label: "Greater Than",
                    ),
                    DropdownMenuEntry(
                        value: "Greater Than Or Equal to",
                        label: "Greater Than Or Equal to"),
                    DropdownMenuEntry(
                      value: "Less Than Or Equal to",
                      label: "Less Than Or Equal to",
                    ),
                    DropdownMenuEntry(
                      value: "Less Than",
                      label: "Less Than",
                    ),
                  ],
                ),
                DropdownMenu(
                  label: const Text("Sensor"),
                  controller: sensorController,
                  expandedInsets: const EdgeInsets.all(0),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                        value: "Energy Usage", label: "Energy Usage"),
                  ],
                ),
                MyTextFormField(
                  label: "Value",
                  type: TextInputType.number,
                  validator: FieldValidation.validateRequired,
                  controller: valueController,
                ),
                widget.routine != null
                    ? IconButton(
                        onPressed: _onSafePressed,
                        icon: const Icon(
                          Icons.save_outlined,
                          size: 64,
                        ),
                      )
                    : IconButton(
                        onPressed: _onAddPressed,
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 64,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSafePressed() {
    if (!_formKey.currentState!.validate() ||
        deviceController.text.isEmpty ||
        conditionController.text.isEmpty ||
        actionController.text.isEmpty ||
        deviceController.text.isEmpty) {
      return;
    }
    Navigator.pop(
      context,
      Routine(
        id: widget.routine!.id,
        name: nameController.text,
        description: descriptionController.text,
        deviceId: FirebaseFirestore.instance
            .doc("/devices/${deviceController.text.split(":")[0]}"),
        userId: widget.routine!.userId,
        action: actionController.text,
        condition: conditionController.text,
        sensor: sensorController.text,
        value: int.parse(valueController.text),
      ),
    );
  }

  void _onAddPressed() {
    if (!_formKey.currentState!.validate() ||
        deviceController.text.isEmpty ||
        conditionController.text.isEmpty ||
        actionController.text.isEmpty ||
        deviceController.text.isEmpty) {
      return;
    }
    Navigator.pop(
      context,
      Routine(
        name: nameController.text,
        description: descriptionController.text,
        deviceId: FirebaseFirestore.instance
            .doc("/devices/${deviceController.text.split(":")[0]}"),
        action: actionController.text,
        condition: conditionController.text,
        sensor: sensorController.text,
        value: int.parse(valueController.text),
      ),
    );
  }
}
