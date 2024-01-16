class ApiVariables {
  static const baseURL = "192.168.1.8:3005";
  static const signUpURL = "/api/auth/signup";
  static const signInURL = "/api/auth/signin";
  static const tokenValidURL = "/api/auth/tokenvalid";
  static const getUserURL = "/api/auth/getuser";
  
  static const addProductURL = "/api/admin/add-product";
  static const getAllProductURL = "/api/admin/get-product";
  static const deleteProductURL = "/api/admin/delete-product";
  static const getAdminOrdersURL = "/api/admin/get-admin-orders";
  static const changeOrderStatusURL = "/api/admin/change-order-status";
  static const getAnalyticsURL = "/api/admin/analytics";

  static const getProductsCategoryURL = "/api/product/get-products";
  static const searchProductsURL = "/api/product/search-products/";
  static const rateProductsURL = "/api/product/rate-product";
  static const dealOfDayURL = "/api/product/get-dealofday";

  static const addToCartURL = "/api/user/add-to-cart";
  static const removeFromCartURL = "/api/user/remove-cart/";
  static const saveUserAddressURL = "/api/user/save-user-address";
  static const placeOrderURL = "/api/user/order-product";
  static const getUserOrdersURL = "/api/user/get-user-orders";
}