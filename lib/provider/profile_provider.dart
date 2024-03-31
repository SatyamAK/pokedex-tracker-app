import 'package:flutter/material.dart';
import 'package:pokedex_tracker/database/database_helper.dart';
import 'package:pokedex_tracker/model/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  Profile _activeProfile = Profile(name: "", generation: "");
  List<Profile> _profiles = List.empty(growable: true);

  Future<void> getActiveProfile() async {
    if(_activeProfile.id != null) return;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? activeProfileId = sharedPreferences.getInt("activeProfileId");

    if(activeProfileId!.isNaN) return;

    _activeProfile = await DataBaseHelper.instance.getActiveProfile(activeProfileId);
    notifyListeners();
  }

  Future<void> getProfiles() async {
    if(_profiles.isNotEmpty) return;

    _profiles = await DataBaseHelper.instance.getProfiles();
    notifyListeners();
  }

  void updateProfiles(Profile profile) {
    _profiles.add(profile);
    notifyListeners();
  }

  void removeProfile(Profile profile) {
    if(profile.id == _activeProfile.id) {
      return;
    }
    _profiles.remove(profile);
    if(_profiles.isEmpty) {
      _activeProfile = Profile(name: "", generation: "");
    }
    notifyListeners();
  }

  void updateSelectedProfile(Profile profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  Profile get activeProfile => _activeProfile;
  List<Profile> get profiles => _profiles;
}