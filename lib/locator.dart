import 'package:get_it/get_it.dart';

import './services/api.dart';
import './states/directions.dart';

GetIt locator = GetIt.instance();

void setupLocator() {
  locator.registerLazySingleton(() => Api('items'));
  locator.registerLazySingleton(() => DirectionsModel()) ;
}