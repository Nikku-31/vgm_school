import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../AppManager/ViewModel/AccountVM/student_details_view_model.dart';
import '../AppManager/ViewModel/HomeWorkVM/upcoming_classes_vm.dart';
import '../core/constants/app_colors.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {

  final days = ["MON","TUE","WED","THU","FRI","SAT"];
  int selectedDay = 0;
  @override
  void initState() {
    super.initState();

    int weekday = DateTime.now().weekday;

    if (weekday >= 1 && weekday <= 6) {
      selectedDay = weekday - 1;
    } else {
      selectedDay = 0;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FB),

      body: SafeArea(
        top: false,
        child: Column(
          children: [

            // HEADER
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 15,
                left: 20,
                right: 20,
                bottom: 30,
              ),

              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },

                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.background,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "My Classes",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color:AppColors.background,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color:AppColors.background,
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Row(
                      children: [
                        const Icon(Icons.book),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Consumer<StudentDetailViewModel>(
                            builder: (context,vm,child){

                              return Text(
                                "${vm.student?.className ?? ""} - ${vm.student?.sectionName ?? ""}",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            // DAYS
            SizedBox(
              height: MediaQuery.of(context).size.height * .08,
              child: ListView.builder(scrollDirection:
              Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context,index){
                  bool selected= selectedDay==index;
                  return GestureDetector(

                    onTap: (){
                      setState(() {
                        selectedDay=index;
                      });
                    },

                    child: Container(
                      width: MediaQuery.of(context).size.width*.18,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(

                        color:selected ?AppColors.primary
                            :AppColors.background,
                        borderRadius: BorderRadius.circular(
                            20),
                      ),

                      child: Center(
                        child: Text(days[index],

                          style: TextStyle(
                            color:selected ?AppColors.background :Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              child: Consumer<UpcomingClassesVM>(
                builder: (context,vm,child){

                  if(vm.isLoading){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final selectedDayName = {

                    0:"monday",
                    1:"tuesday",
                    2:"wednesday",
                    3:"thursday",
                    4:"friday",
                    5:"saturday",

                  };

                  final filteredClasses = vm.classes.where((e){
                    return e.day?.toLowerCase()==
                        selectedDayName[selectedDay];
                  }).toList();

                  if(filteredClasses.isEmpty){

                    return Center(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(30),

                        decoration: BoxDecoration(

                          color:AppColors.background,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Center(
                          child: Text(
                            "No Data Available",

                            style:
                            GoogleFonts
                                .poppins(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: filteredClasses.length,
                    itemBuilder: (context,index){

                      var item = filteredClasses[index];
                      return Card(
                        elevation: 2,
                        color: AppColors.background,
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),

                        child: Padding(

                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Container(

                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8,),

                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,

                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Text(

                                  "${item.fromTime} - ${item.toTime}",

                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),
                              Text(
                                item.subjectName
                                    ?? "",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                item.teacherName ?? "",
                                style: GoogleFonts.poppins(

                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}