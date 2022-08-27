import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

Faker faker = Faker();
List names = List<String>.generate(40, (index) => faker.person.firstName(),
    growable: true);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: MyHome()),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final alphabets =
      List.generate(26, (index) => String.fromCharCode(index + 65));
  int _searchIndex = 0;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  void setSearchIndex(String searchLetter) {
    setState(() {
      _searchIndex = names.indexWhere((element) => element[0] == searchLetter);
      if (_searchIndex > 0) _itemScrollController.jumpTo(index: _searchIndex);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    names.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: ScrollablePositionedList.builder(
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                itemCount: names.length,
                itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          names[index],
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          names[index][0],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    )),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: alphabets
                  .map((alphabet) => InkWell(
                        onTap: () {
                          setSearchIndex(alphabet);
                        },
                        child: Text(
                          alphabet,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
