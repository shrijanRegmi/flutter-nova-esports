import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peaman/models/app_models/user_model.dart';
import 'package:peaman/services/database_services/user_provider.dart';
import 'package:peaman/viewmodels/search_vm.dart';
import 'package:peaman/viewmodels/viewmodel_builder.dart';
import 'package:peaman/views/widgets/search_widgets/users_list_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<AppUser> _searchedNames = [];
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
  print(_searchedNames);
    return ViewmodelProvider<SearchVm>(
      vm: SearchVm(context: context),
      builder: (context, vm, appVm, appUser) {
        return Scaffold(
          backgroundColor: Color(0xffF3F5F8),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Color(0xff3D4A5A),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: _searchField(),
            backgroundColor: Color(0xffF3F5F8),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _usersList(appUser),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _searchField() {
    return TextFormField(
      autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Type here to search...',
      ),
      controller: _controller,
      onChanged: (val) {
        setState(() {});
      },
    );
  }

  Widget _usersList(AppUser appUser) {
    return _controller.text == ''
        ? Container()
        : StreamBuilder<List<AppUser>>(
            stream: AppUserProvider(searchKey: _controller.text.toUpperCase())
                .appUserFromKey,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<AppUser> _users = (snapshot.data ?? []);
                _searchedNames = _users;

                return _users.isEmpty
                    ? _emptySearch(context)
                    : Column(
                        children: [
                          _viewAllResultBuilder(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _users.length,
                            itemBuilder: (context, index) {
                              return UserListItem(
                                friend: _users[index],
                              );
                            },
                          ),
                        ],
                      );
              }
              return Container();
            },
          );
  }

  Widget _emptySearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset(
                'assets/lottie/search_empty.json',
                width: MediaQuery.of(context).size.width - 100.0,
                height: MediaQuery.of(context).size.width - 100.0,
              ),
              Text(
                "User not found !",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Color(0xff3D4A5A)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _viewAllResultBuilder() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ViewAllResultScreen(
        //         _searchedNames, _controller.text.toUpperCase()),
        //   ),
        // );
      },
      child: Container(
        color: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('View all results with ${_controller.text}'),
            ],
          ),
        ),
      ),
    );
  }
}
