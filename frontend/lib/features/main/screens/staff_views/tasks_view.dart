import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/task.dart';
import '../../../../models/staff.dart';
import '../../../../services/api_service.dart';

class TasksView extends StatefulWidget {
  final String? staffId; // If provided, shows tasks only for this staff member
  const TasksView({super.key, this.staffId});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  late Future<List<StaffTask>> _tasksFuture;
  List<Staff> _staffMembers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      if (widget.staffId != null) {
        _tasksFuture = ApiService.getStaffTasks(widget.staffId!);
      } else {
        _tasksFuture = ApiService.getAllTasks();
      }
    });
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    try {
      final staff = await ApiService.getAllStaff();
      setState(() {
        _staffMembers = staff;
      });
    } catch (e) {
      print('Error loading staff: $e');
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'URGENT':
        return Colors.red.shade700;
      case 'HIGH':
        return Colors.red.shade400;
      case 'MEDIUM':
        return Colors.orange;
      case 'LOW':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return Colors.green;
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showTaskDetails(StaffTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title,
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Priority: ${task.priority}',
                style: TextStyle(
                    color: _getPriorityColor(task.priority),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Status: ${task.status}',
                style: TextStyle(color: _getStatusColor(task.status))),
            const SizedBox(height: 16),
            Text(task.description),
            const SizedBox(height: 16),
            if (task.dueDate != null) Text('Due Date: ${task.dueDate}'),
          ],
        ),
        actions: [
          if (task.status != 'COMPLETED')
            ElevatedButton(
              onPressed: () async {
                await ApiService.updateTaskStatus(task.taskId, 'COMPLETED');
                Navigator.pop(context);
                _loadData();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Mark Completed'),
            ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/staff_task_banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              const Color(0xFF0D47A1).withOpacity(0.9),
              const Color(0xFF0D47A1).withOpacity(0.3),
            ],
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.staffId != null ? 'My Daily Tasks' : 'Global Operations',
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage and track resort activities in real-time',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task Queue',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              IconButton(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh, color: Color(0xFF1565C0))),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<StaffTask>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final tasks = snapshot.data ?? [];
                if (tasks.isEmpty) {
                  return Center(
                      child: Text('No tasks found.',
                          style: GoogleFonts.montserrat(color: Colors.grey)));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final assignedStaff = _staffMembers.firstWhere(
                      (s) => s.staffId == task.assignedTo,
                      orElse: () => Staff(
                          staffId: '',
                          fullName: 'Unassigned',
                          email: '',
                          phone: '',
                          department: '',
                          position: '',
                          salary: 0,
                          status: '',
                          shift: ''),
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getPriorityColor(task.priority),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                task.title,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(task.status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.status,
                                style: GoogleFonts.montserrat(
                                  color: _getStatusColor(task.status),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(task.description,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(assignedStaff.fullName,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                                if (task.dueDate != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(task.dueDate!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () => _showTaskDetails(task),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
