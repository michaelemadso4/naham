import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naham/feutcher/Groups/controller/groupcontroller/groupcontroller.dart';
import 'package:naham/feutcher/Groups/model/groupmodel.dart';
import 'package:naham/feutcher/Groups/view/widgets/groupContainer.dart';
import 'package:naham/helper/scalesize.dart';

class Groupscreen extends StatelessWidget {
  const Groupscreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25)
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 30,
                left: 10,right: 10
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/logo.webp',width:width*0.1 ,),
                Text('Groups', textScaleFactor:
                ScaleSize.textScaleFactor(
                    context),),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: Colors.white.withOpacity(0.3,),
                  ),
                  child: Icon(Icons.person),
                ),
              ],),
          ),
          SizedBox(height: 80,),
          GetBuilder(
            init: GroupController(),
            builder: (controller) {
              return FutureBuilder(future: controller.GetGroupList(), builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasError){
                  return Center(child:Text('Connection State has Error') ,);
                }else if(snapshot.hasData){
                  GroupModel groupmodel = GroupModel();
                  groupmodel = GroupModel.fromJson(snapshot.data);
                  return Flexible(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(35),topLeft: Radius.circular(35))
                      ),
                      child: ListView.builder(
                          itemCount: groupmodel.data!.length,
                          itemBuilder: (context,index){
                            return Groupcontainer(
                              grouptitle: groupmodel.data![index].name,
                              msgtxt: '',
                              sendrmsg: '',
                            );
                          }),
                    ),
                  );
                }else{
                  return Center(child: Text('No Data'));
                }
              });
            }
          )
        ],
      ),
    );
  }
}
