import 'checkin.dart';

class Streak {
  int count;
  CheckIn? lastCheckIn;

  Streak({this.count = 0, this.lastCheckIn});
}
