import 'dart:async';

Future<void> main() async {
  print("1- J'arrive en premier");
  print(await retour1());
  print("5- J'arrive en dernier");
}

Future<String> retour1()  {
  print("2- Je dois arriver en second");
  var retour = Future.delayed(const Duration(seconds: 5), () =>
  "3- J'arrive un peu en retard");
  print("4- Je dois arriver en quatrième position");
  return retour;
} 