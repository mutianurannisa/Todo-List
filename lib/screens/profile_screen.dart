import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; 
import '../providers/task_provider.dart'; 
import 'package:todolist/screens/start_screen.dart'; 
import 'package:todolist/screens/edit_profile_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
        style: TextStyle(
          fontFamily: 'baloo', 
          fontSize: 30, 
          ),
        ),
        centerTitle: true,
      ),
      body: uid == null
          ? const Center(child: Text('User belum login'))
          : FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                final name = (data['name'] as String?) ?? user?.email ?? 'No user';
                final String? photoUrl = (data['photoUrl'] as String?);

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl)
                              : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Consumer<TaskProvider>(
                          builder: (context, taskProvider, child) {
                            if (taskProvider.isLoading) {
                              return const CircularProgressIndicator();
                            }
                            if (taskProvider.errorMessage != null) {
                              return Text('Error loading tasks: ${taskProvider.errorMessage!}');
                            }

                            final int pendingTasks = taskProvider.pendingTasksCount;
                            final int completedTasks = taskProvider.completedTasksCount;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ProfileBox(label: '$pendingTasks Task left', color: Colors.pink.shade300),
                                const SizedBox(width: 10),
                                ProfileBox(label: '$completedTasks Task done', color: Colors.green.shade400),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/edit-profile');
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();

                            Provider.of<TaskProvider>(context, listen: false).setUser(null); 

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const StartScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Log out'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ProfileBox extends StatelessWidget {
  final String label;
  final Color color;
  const ProfileBox({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}