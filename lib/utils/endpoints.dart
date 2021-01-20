class Endpoints {
  static const REALTIME_DATABASE =
      'https://flutter-testapp-49112.firebaseio.com/';
  static const AUTH_SIGNUP_API = 'https://identitytoolkit.googleapis.com/v1/'
      'accounts:signUp?key=AIzaSyCG2yXsAyUwanTK1huLBeRnH889k7etKu4';
  static const AUTH_SIGNIN_API = 'https://identitytoolkit.googleapis.com/v1/'
      'accounts:signInWithPassword?key=AIzaSyCG2yXsAyUwanTK1huLBeRnH889k7etKu4';

  static const USER_FAVORITES = '${REALTIME_DATABASE}userFavorites';
  static const PRODUCTS = '${REALTIME_DATABASE}products';
  static const ORDERS = '${REALTIME_DATABASE}orders';
}
