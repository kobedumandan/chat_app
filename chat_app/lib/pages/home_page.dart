import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // rebuild when returning to this page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3), // shadow below AppBar
              ),
            ],
          ),
          child: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.message,
                  size: 28,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.greenAccent
                      : Colors.grey.shade800,
                ),
                // SizedBox(width: 7),
                // Text(
                //   "Home",
                //   style: TextStyle(
                //     color: Theme.of(context).brightness == Brightness.dark
                //         ? Colors.white
                //         : Colors.grey.shade800,
                //   ),
                // ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color.fromARGB(255, 79, 79, 79),
            elevation: 0,
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          SizedBox(height: 18),
          _buildChatHeads(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Divider(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 2),
            child: Row(
              children: [
                Text(
                  "Conversations",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.grey.shade800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  // Widget _buildUserList() {
  //   return StreamBuilder(
  //     stream: _chatService.getUsersStream(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Text("Error");
  //       }

  //       // loading
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Text("Loading...");
  //       }

  //       return ListView(
  //         children: snapshot.data!
  //             .map<Widget>((userData) => _buildUserListItem(userData, context))
  //             .toList(),
  //       );
  //     },
  //   );
  // }
  Widget _buildUserList() {
    final currentUser = _authService.getCurentUser()!;

    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!
            .where((userData) => userData["email"] != currentUser.email)
            .toList();

        // Filter users who have existing messages
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _filterUsersWithConversations(users),
          builder: (context, filteredSnapshot) {
            if (filteredSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final filteredUsers = filteredSnapshot.data ?? [];

            if (filteredUsers.isEmpty) {
              return const Center(child: Text("No conversations yet"));
            }

            return ListView(
              children: filteredUsers
                  .map<Widget>(
                    (userData) => _buildUserListItem(userData, context),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _filterUsersWithConversations(
    List<Map<String, dynamic>> users,
  ) async {
    List<Map<String, dynamic>> filtered = [];
    for (var user in users) {
      bool hasChat = await _chatService.hasConversation(user["uid"]);
      if (hasChat) filtered.add(user);
    }
    return filtered;
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    if (userData["email"] != _authService.getCurentUser()!.email) {
      return UserTile(
        text:
            userData["f_name"].toString() + " " + userData["l_name"].toString(),
        color: Color(userData['color']),
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverName:
                    userData["f_name"].toString() +
                    " " +
                    userData["l_name"].toString(),
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
                color: Color(userData['color']),
              ),
            ),
          ).then((_) => setState(() {})),
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildChatHeads() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Error");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 80, // reserve space for chat heads
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final users = snapshot.data!
            .where(
              (userData) =>
                  userData["email"] != _authService.getCurentUser()!.email,
            )
            .toList();

        return SizedBox(
          height: 80, // height of the chat heads row
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        recieverName: "${user["f_name"]} ${user["l_name"]}",
                        receiverEmail: user["email"],
                        receiverID: user["uid"],
                        color: Color(user['color']),
                      ),
                    ),
                  ).then((_) => setState(() {}));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15.5),
                        decoration: BoxDecoration(
                          color: Color(user['color']),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey.shade800,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user["f_name"].toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
