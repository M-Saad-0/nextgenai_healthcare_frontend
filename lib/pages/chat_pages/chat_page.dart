import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_bloc/chat_bloc.dart';
import 'package:next_gen_ai_healthcare/widgets/query_and_response_widget.dart';

class ChatPage extends StatefulWidget {
  final String question;
  const ChatPage({super.key, this.question = ""});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.text = widget.question;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(Theme.of(context).brightness == Brightness.dark
                  ? "assets/images/chat_bg_dark.png"
                  : "assets/images/chat_bg_light.png"))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatEnded) {
              context.read<ChatBloc>().chatRepositoryImp.saveChat(
                    context.read<ChatBloc>().chatHistory,
                  );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.jumpTo(
                    scrollController.position.maxScrollExtent,
                  );
                }
              });
            }
          },
          builder: (context, state) {
            final chatHistory = context.read<ChatBloc>().chatHistory;
            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      chatHistory.isEmpty
                          ? SliverFillRemaining(
                              hasScrollBody: false,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.sizeOf(context).height / 4 +
                                            1,
                                    horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withValues(alpha: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    // gradient: LinearGradient(
                                    //   colors: [
                                    //     Color(0xff9090FF),
                                    //     Color(0xff1F7CFD)
                                    //   ],
                                    //   begin: Alignment.topLeft,
                                    //   end: Alignment.bottomRight,
                                    // ),
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(0, 0, 0, 0),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.chat_bubble,
                                              size: 90,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          const SizedBox(height: 20),
                                          const Text(
                                            "Your Health Assistant",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              // color: Colors.deepPurple,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            "Ask me about symptoms, treatments, or general wellness.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              // color: Colors.purple.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return QueryAndResponseWidget(
                                  isLoading: state is ChatStarted,
                                  model: chatHistory[index],
                                  isLastBlock: chatHistory.length - 1 == index,
                                );
                              }, childCount: chatHistory.length),
                            ),
                    ],
                  ),
                ),

                // Input Field
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FloatingActionButton(
                        onPressed: () {
                          final query = controller.text.trim();
                          if (query.isNotEmpty && (state is! ChatStarted)) {
                            context.read<ChatBloc>().add(
                                  StartTheChat(
                                    model: AiRequestModel(
                                      query: query,
                                      image: "",
                                      date: DateTime.now().toIso8601String(),
                                    ),
                                  ),
                                );
                            controller.clear();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (scrollController.hasClients) {
                                scrollController.jumpTo(
                                  scrollController.position.maxScrollExtent,
                                );
                              }
                            });
                          }
                        },
                        child: (state is ChatStarted)
                            ? const Icon(Icons.stop)
                            : const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
