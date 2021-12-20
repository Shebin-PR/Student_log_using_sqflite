import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentsdetails/data_card.dart';
import 'package:studentsdetails/sqflite/datamodel.dart';
import 'package:studentsdetails/sqflite/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _myFormkey = GlobalKey<FormState>();

  String searchText = "";
  var ind;

  List<DataModel> datas = [];

  int currentIndex = 0;

  String imagePath = "";
  late DB db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DB();
    getData();
  }

  Future<void> getData() async {
    datas = await db.getData();
    setState(() {});
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.teal[900],
          elevation: 0,
          title: const Text(
            'Students',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(3),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                        print(searchText);
                      });
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: "search student"),
                  ),
                ),
                Builder(builder: (context) {
                  var result = searchText.isEmpty
                      ? datas.toList()
                      : datas
                          .where((element) => element.name
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .toList();
                  return result.isEmpty
                      ? Text("No results Found")
                      : Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(70)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: ListView.builder(
                                  itemCount: result.length,
                                  itemBuilder: (context, index) {
                                    var getIndex = datas.where((a) =>
                                        a.name.contains(result[index].name));
                                    ind = datas.indexOf(getIndex.first);

                                    return DataCard(
                                        data: datas[index],
                                        edit: edit,
                                        index: ind,
                                        delete: delete,
                                        result: result[index]);
                                  }),
                            ),
                          ),
                        );
                })
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: Builder(builder: (context) {
          return FloatingActionButton(
              backgroundColor: Colors.teal[900],
              foregroundColor: Colors.black54,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addStudents(context)));
              });
        }),
      ),
    );
  }

  addStudents(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.blue[800],
          elevation: 0,
          title: const Text(
            'Add New Student',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          centerTitle: true,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: _myFormkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                                labelText: 'Name',
                                hintText: 'Enter student name.',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            validator: (value) {
                              if (value!.isNotEmpty && value.length > 2) {
                                return null;
                              } else if (value.length < 3 && value.isNotEmpty) {
                                return "min 3 characters";
                              } else {
                                return "Name Required";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: dobController,
                              validator: (value) {
                                if (value!.isNotEmpty && value.length == 5) {
                                  return null;
                                } else if (value == "") {
                                  return " required field";
                                } else {
                                  return "Required no 5";
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'RegNo',
                                  hintText: 'Enter student RegNO',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextFormField(
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              hintText: 'Enter student age',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return "Age Required";
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextFormField(
                              validator: (value) {
                                if (value!.isNotEmpty && value.length == 10) {
                                  return null;
                                } else if (value == "") {
                                  return " required field";
                                } else {
                                  return "Required no 10";
                                }
                              },
                              controller: domainController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Phone',
                                  hintText: 'Enter student Phone Number',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)))),
                        )
                      ],
                    ),
                  )),
            )),
            ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    imagePath = image.path;
                  }
                  return null;
                  // print(image!.path);
                },
                child: Text('Pic')),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FittedBox(
          child: Builder(builder: (context) {
            return FloatingActionButton(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black,
                child: const Icon(Icons.done),
                onPressed: () async {
                  if (_myFormkey.currentState!.validate()) {
                    DataModel dataLocal = DataModel(
                        name: nameController.text,
                        dob: dobController.text,
                        age: ageController.text,
                        domain: domainController.text,
                        imagePath: imagePath);

                    db.insertData(dataLocal);
                    await getData();
                    dataLocal.id = datas[datas.length - 1].id! + 1;

                    setState(() {
                      // datas.add(dataLocal);
                    });

                    nameController.clear();
                    dobController.clear();
                    ageController.clear();
                    domainController.clear();
                    Navigator.pop(context);
                  }
                });
          }),
        ),
      ),
    );
  }

  Scaffold updateScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.blue[800],
          elevation: 0,
          title: const Text(
            'Update Student',
            style: TextStyle(
                color: Colors.black54,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5),
          ),
          centerTitle: true,
        ),
      ),

      /////////////////////
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  labelText: 'Name',
                                  hintText: 'Enter student name.',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextFormField(
                              controller: dobController,
                              decoration: InputDecoration(
                                  labelText: 'RegNo',
                                  hintText: 'Enter student RegNO',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextFormField(
                              controller: ageController,
                              decoration: InputDecoration(
                                  labelText: 'Age',
                                  hintText: 'Enter student age',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextFormField(
                              controller: domainController,
                              decoration: InputDecoration(
                                  labelText: 'Phone',
                                  hintText: 'Enter student Phone Number',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)))),
                        )
                      ],
                    ),
                  )),
            )),
            ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    imagePath = image.path;
                  }
                  print(image!.path);
                },
                child: Text('Pic')),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FittedBox(
          child: Builder(builder: (context) {
            return FloatingActionButton(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              child: const Icon(Icons.done),
              onPressed: () async {
                DataModel newData = datas[currentIndex];
                newData.name = nameController.text;
                newData.dob = dobController.text;
                newData.age = ageController.text;
                newData.domain = domainController.text;
                db.update(newData, newData.id!);
                setState(() {});

                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) {
                //   return detailpage();
                // }));
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          }),
        ),
      ),
    );
  }

  void edit(index) {
    currentIndex = index;
    nameController.text = datas[index].name;
    dobController.text = datas[index].dob;
    ageController.text = datas[index].age;
    domainController.text = datas[index].domain;

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return updateScreen(context);
    }));
  }

  void delete(int index) {
    db.delete(datas[index].id!);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));

    setState(() {
      datas.remove(index);
    });
  }
}
