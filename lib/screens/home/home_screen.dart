import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myraid_demo/modal_classes/task.dart';
import 'package:myraid_demo/providers/task_provider.dart';
import 'package:myraid_demo/utils/custom_widgets/custom_button.dart';
import 'package:myraid_demo/utils/custom_widgets/custom_textformfield.dart';
import 'package:myraid_demo/utils/padding.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _addOrEditTask(BuildContext context, {Task? task, int? index}) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final provider = Provider.of<TaskProvider>(context, listen: false);
   String taskId = task?.id??'';
    final nameController = TextEditingController(text: task?.taskName ?? "");
    final descriptionController =
        TextEditingController(text: task?.description ?? "");
    DateTime? selectedDate = task?.deadline == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(task!.deadline!.toInt());
    bool isDone = task?.isDone ?? false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Task",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: nameController,
                      hint: 'Task Name',
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      controller: descriptionController,
                      hint: 'Description',
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        DateTime now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? now,
                          firstDate: now,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.cardColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          selectedDate == null
                              ? "Select Deadline"
                              : DateFormat('dd MMM yyyy').format(selectedDate!),
                          style: const TextStyle(color: Color(0xFFB3B3B3)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isDone,
                          activeColor: const Color(0xff31c0df),
                          onChanged: (value) {
                            setModalState(() {
                              isDone = value!;
                            });
                          },
                        ),
                        const Text(
                          "Mark as Done",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      onTap: () async {
                        if (validateForm(formKey)) {
                          if (task == null) {
                            await provider.addTask(
                                isDone: isDone,
                                context: context,
                                deadline: selectedDate!.millisecondsSinceEpoch,
                                description: descriptionController.text,
                                taskName: nameController.text
                            );
                          } else {
                            provider.updateTask(
                              Task(
                                id: taskId,
                                isDone: isDone,
                                  deadline: selectedDate!.millisecondsSinceEpoch,
                                  description: descriptionController.text,
                                  taskName: nameController.text
                              ),
                              context
                                );
                          }
                          Navigator.pop(context);
                        }
                      },
                      btnText: "Save",
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks(context);
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Tasks",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:  AppColors.primaryColor,
        onPressed: () => _addOrEditTask(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<TaskProvider>(builder: (context, provider, child) {
        return RefreshIndicator(
          color: const Color(0xff31c0df),
          backgroundColor: AppColors.cardColor,
          onRefresh:()=> provider.refreshTasks(context),
          child: provider.tasks.isEmpty
              ? ListView(
            children: const [
              SizedBox(height: 300),
              Center(
                child: Text(
                  "No tasks yet. Pull to refresh.",
                  style: TextStyle(color: Color(0xFFB3B3B3)),
                ),
              ),
            ],
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];

              return Card(
                color: AppColors.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  onTap: () =>
                      _addOrEditTask(context, task: task, index: index),
                  leading: Checkbox(
                    value: task.isDone,
                    activeColor: AppColors.primaryColor,
                    onChanged: (_) {},
                  ),
                  title: Text(
                    task.taskName ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      decoration: task.isDone != null
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('dd MMM yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            task.deadline!)),
                    style: const TextStyle(color: AppColors.subTextColor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () => provider.deleteTask(task.id!,context),
                  ),
                ),
              );
            },
          ),
        );
      },

      ),
    );
  }
}
