import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_bloc/chat_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/symptoms_bloc/symptoms_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/chat_pages/ai_chatbot.dart';
import 'package:next_gen_ai_healthcare/widgets/ai_prognosis.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AiDiagnosisPage extends StatefulWidget {
  const AiDiagnosisPage({super.key});

  @override
  State<AiDiagnosisPage> createState() => _AiSymptomsPageState();
}

class _AiSymptomsPageState extends State<AiDiagnosisPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool symptomsIsEntered = false;
  final GlobalKey _key = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final Set<String> _visibleCards = {};
  List<String> symptomsHistory = [];
  late DiagnosisChatSave chatSave;
  List<bool> selectableSymptoms =
      List.generate(AiPrognosis.symptomsDict.length, (index) => false);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    chatSave = DiagnosisChatSave();
    symptomsHistory = chatSave.getSymtomsData();
    // _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget reusableInfoCard(String title, String content) {
    return VisibilityDetector(
      key: Key(title),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) {
          setState(() {
            _visibleCards.add(title); // Add to a Set<String> of visible titles
          });
        }
      },
      child: TweenAnimationBuilder(
        tween:
            Tween(begin: 0.0, end: _visibleCards.contains(title) ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 600),
        builder: (context, double opacity, child) => Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, (1 - opacity) * 20),
            child: child,
          ),
        ),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:  TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor)),
                  const SizedBox(height: 8),
                  Text(content, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget diseaseProbability(String disease, double probability) {
    Color getColor(double value) {
      if (value < 0.33) return Colors.greenAccent.shade700;
      if (value < 0.66) return Colors.blueAccent;
      return Colors.redAccent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          disease,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0, end: probability),
          builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 7,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(getColor(value)),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(value * 100).toStringAsFixed(1)}% likelihood',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Symptoms Analysis'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<SymptomsBloc>().add(SymptomsResetEvent());
                _textController.clear();
              })
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Symptoms History",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: symptomsHistory.length,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(
                            symptomsHistory[index],
                            maxLines: 1,
                            style: const TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                          onTap: () {
                            context.read<SymptomsBloc>().add(
                                SymptomsPredictEvent(
                                    symptoms: symptomsHistory[index]
                                        .split(",")
                                        .map((e) => e.trim())
                                        .toList()));
                                        Navigator.pop(context);
                          },
                        )),
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(Theme.of(context).brightness == Brightness.dark
              ? "assets/images/chat_bg_dark.png"
              : "assets/images/chat_bg_light.png"),
          repeat: ImageRepeat.repeat,
        )),
        child: BlocBuilder<SymptomsBloc, SymptomsState>(
          builder: (context, state) {
            switch (state) {
              case SymptomsInitial():
                return Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.biotech_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 80,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Enter your symptoms",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              autofocus: true,
                              autocorrect: true,
                              controller: _textController,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Please enter your symptom";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "e.g. headache, nausea",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    List<String> allSymptoms =
                                        AiPrognosis.symptomsDict.keys.toList();
                                    List<String> searchedSymptoms =
                                        allSymptoms;
                                    TextEditingController searchcontroller =
                                        TextEditingController();

                                    showDialog(
                                      context: context,
                                      builder: (_) => StatefulBuilder(
                                        builder: (_, setState) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Please select symptoms", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
                                            content: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.7,
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                              ),
                                              child: SingleChildScrollView(
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          searchcontroller,
                                                      decoration:
                                                          const InputDecoration(
                                                              prefixIcon: Icon(
                                                                  Icons.search),
                                                              hintText:
                                                                  "Search for symptoms"),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          searchedSymptoms = allSymptoms
                                                              .where((e) => e
                                                                  .toLowerCase()
                                                                  .contains(value
                                                                      .toLowerCase()))
                                                              .toList();
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Column(
                                                      children: [
                                                        for (int i = 0;
                                                            i <
                                                                searchedSymptoms
                                                                    .length;
                                                            i++)
                                                          Builder(
                                                            builder: (context) {
                                                              int index = AiPrognosis
                                                                          .symptomsDict[
                                                                      searchedSymptoms[
                                                                          i]] ??
                                                                  0;
                                                              final name =
                                                                  searchedSymptoms[
                                                                          i]
                                                                      .split(
                                                                          "_")
                                                                      .map((e) {
                                                                e = e[0].toUpperCase() +
                                                                    e.substring(
                                                                        1);
                                                                return e;
                                                              }).join(" ");
                                                              return ListTile(
                                                                leading: selectableSymptoms[
                                                                        index]
                                                                    ? const Icon(
                                                                        Icons
                                                                            .check_box)
                                                                    : const Icon(
                                                                        Icons
                                                                            .check_box_outline_blank),
                                                                title:
                                                                    Text(name),
                                                                selected:
                                                                    selectableSymptoms[
                                                                        index],
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectableSymptoms[
                                                                            index] =
                                                                        !selectableSymptoms[
                                                                            index];
                                                                  });
                                                                },
                                                              );
                                                            },
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  List<String>
                                                      selectedSymptoms = [];
                                                  for (int i = 0;
                                                      i <
                                                          selectableSymptoms
                                                              .length;
                                                      i++) {
                                                    if (selectableSymptoms[i]) {
                                                      selectedSymptoms
                                                          .add(allSymptoms[i]);
                                                    }
                                                  }
                                                  if (selectedSymptoms
                                                      .isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              "Please select at least one symptom")),
                                                    );
                                                    return;
                                                  }
                                                  _textController.text =
                                                      selectedSymptoms
                                                          .join(", ");
                                                  selectableSymptoms =
                                                      List.filled(
                                                          selectableSymptoms
                                                              .length,
                                                          false);

                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Select"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectableSymptoms =
                                                        List.generate(
                                                      AiPrognosis
                                                          .symptomsDict.length,
                                                      (index) => false,
                                                    );
                                                  });
                                                  selectableSymptoms =
                                                      List.filled(
                                                          selectableSymptoms
                                                              .length,
                                                          false);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.list),
                                  tooltip: "Select Symptoms",
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if ((_key.currentState as FormState)
                                      .validate()) {
                                    chatSave
                                        .saveSymptomsData(_textController.text);
                                    context.read<SymptomsBloc>().add(
                                          SymptomsPredictEvent(
                                              symptoms: _textController.text
                                                  .split(',')
                                                  .map((e) => e.trim())
                                                  .toList()),
                                        );
                                  }
                                },
                                icon: const Icon(Icons.search),
                                label: const Text("Submit Symptoms"),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              case SymptomsLoadingState():
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case SymptomsErrorState():
                return const Center(
                  child: Text(
                    'An error occurred. Please try again later.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              case SymptomsSuccessState():
                return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 12),
                        //   child: Text(
                        //     'Most Probable Diseases',
                        //     textAlign: TextAlign.start,
                        //     style: TextStyle(
                        //       fontSize: 22,
                        //       fontWeight: FontWeight.bold,
                        //       color: Theme.of(context).colorScheme.primary,
                        //     ),
                        //   ),
                        // ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                diseaseProbability(
                                    state.result.keys.toList()[0],
                                    state.result.values.toList()[0]),
                                const SizedBox(
                                  height: 8,
                                ),
                                diseaseProbability(
                                    state.result.keys.toList()[1],
                                    state.result.values.toList()[1]),
                                const SizedBox(
                                  height: 8,
                                ),
                                diseaseProbability(
                                    state.result.keys.toList()[2],
                                    state.result.values.toList()[2]),
                                const SizedBox(
                                  height: 8,
                                ),
                                diseaseProbability(
                                    state.result.keys.toList()[3],
                                    state.result.values.toList()[3]),
                                const SizedBox(
                                  height: 8,
                                ),
                                diseaseProbability(
                                    state.result.keys.toList()[4],
                                    state.result.values.toList()[4]),
                              ],
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 12),
                        //   child: Text(
                        //     textAlign: TextAlign.start,
                        //     'Other Information',
                        //     style: TextStyle(
                        //       fontSize: 22,
                        //       fontWeight: FontWeight.bold,
                        //       color: Theme.of(context).colorScheme.primary,
                        //     ),
                        //   ),
                        // ),
                        reusableInfoCard('Disease (Most Probable)',
                            state.result.entries.first.key),
                        reusableInfoCard('Description',
                            state.description ?? "No Description Information"),
                        reusableInfoCard('Diet Recommendation',
                            state.diets ?? "No Diet Information"),
                        reusableInfoCard('Medications',
                            state.medications ?? "No Medication Information"),
                        reusableInfoCard('Precautions',
                            state.precautionDf ?? "No Precautions Information"),
                        // reusableInfoCard(
                        //     'Severity',
                        //     state.symptomSeverity?.toString() ??
                        //         "No Severity Information"),
                        const SizedBox(
                          height: 8,
                        ),

                        SizedBox(
                          width: MediaQuery.sizeOf(context).width - 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => ChatBloc(
                                        ChatRequestImp(), ChatRepositoryImp()),
                                    child: AiChatBot(
                                      question:
                                          "What are the most effective treatment options available for ${state.result.entries.first.key}, and how soon can I expect to see improvement?",
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text("Get More Info"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ));
            }
          },
        ),
      ),
    );
  }
}
