import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/userListController.dart'; // Asegúrate de tenerlo bien importado
import '../models/user.dart';
import '../widgets/userCard.dart';
import '../widgets/paginatedListView.dart';

class HomeDoctorPageScreen extends StatefulWidget {
  @override
  _homeDoctorPageScreenState createState() => _homeDoctorPageScreenState();
}

class _homeDoctorPageScreenState extends State<HomeDoctorPageScreen> {
  final UserListController _userListController = Get.put(UserListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de usuarios'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Obx((){
        if (_userListController.isLoading.value){
          return const Center(child: CircularProgressIndicator());
        }

        return PaginatedListView<UserModel>(
          items: _userListController.userList,
          itemBuilder: (user) => UserCard(user: user),
          currentPage: _userListController.currentPage.value,
          onNextPage: _userListController.nextPage,
          onPreviousPage: _userListController.previousPage,
          );
      }),
    );
  }
}
