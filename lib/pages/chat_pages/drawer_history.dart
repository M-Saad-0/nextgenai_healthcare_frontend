import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_history_bloc/chat_history_bloc.dart';

class DrawerHistory extends StatefulWidget {
  final User user;
  const DrawerHistory({super.key, required this.user});

  @override
  State<DrawerHistory> createState() => _DrawerHistoryState();
}

class _DrawerHistoryState extends State<DrawerHistory> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<ChatHistoryBloc>().add(LoadChatHistoryByDay());
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.sizeOf(context).width * .70,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Text(
                "Your History",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
                builder: (context, state) {
                  switch (state) {
                    case ChatHistoryLoading():
                      return const Center(child: CircularProgressIndicator());
                    case ChatHistoryError():
                      return Center(child: Text(state.message));
                    case ChatHistoryLoaded():
                      return Container(
                        child: 
                                 state.keys.isEmpty?const Center(child: Text("No History!!"),)
                              : Expanded(
                                child: ListView.builder(
                                  // Get the list of keys and reverse it once
                                  itemCount: state.keys.length,
                                  itemBuilder: (context, index) {
                                    // Access the keys in reversed order using the index
                                    final reversedKeys = state.keys.toList().reversed.toList();
                                    final key = reversedKeys[index];
                                
                                    return ListTile(
                                      leading: const Icon(Icons.history),
                                      // Split the key by "T" and take the first part (date) for the title
                                      title: Text(key.split("T")[0]),
                                      onTap: () async {
                                        // Dispatch the LoadChatHistoryOfADay event with the selected key
                                        context
                                            .read<ChatHistoryBloc>()
                                            .add(LoadChatHistoryOfADay(key));
                                        // You might want to navigate or update the UI here
                                      },
                                    );
                                  },
                                ),
                              )
,
                        
                      );
                    default:
                      return const Center(child: Text('No chat history found'));
                  }
                },
              ),
             
              Divider(
                height: 0,
              ),
              ListTile(
                // tileColor: Theme.of(context).colorScheme.surface,
                leading: CircleAvatar(
                  backgroundImage: widget.user.picture != null &&
                          widget.user.picture!.isNotEmpty
                      ? NetworkImage(widget.user.picture!)
                      : null,
                  child: widget.user.picture == null ||
                          widget.user.picture!.isEmpty
                      ? Text(widget.user.userName
                          .trim()
                          .split(" ")
                          .map((e) => e[0])
                          .join()
                          .toUpperCase())
                      : null,
                ),
                title: Text(widget.user.userName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
