
import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:next_gen_ai_healthcare/widgets/markdown_widget.dart';

class QueryAndResponseWidget extends StatelessWidget {
  final bool isLoading;
  final bool isLastBlock;
  final AiRequestModel model;


  const QueryAndResponseWidget({
    super.key,
    required this.isLoading,
    required this.model,
    required this.isLastBlock
  });

  @override
  Widget build(BuildContext context) {
    print(isLastBlock);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.sizeOf(context).width * .6,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(model.query)],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.sizeOf(context).width * .85,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              
            ),
            child:
                (model.reponse == null || isLoading) && isLastBlock
                    ? const Row(
                      children: [
                         SizedBox(
                          height: 15, width: 15,
                          child: CircularProgressIndicator()),
                      SizedBox(width: 5,),
                      Text("Searching...")
                      ],
                    )
                    : MarkdownWidgetCustom(markdownData: model.reponse!),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
