// Generated by CoffeeScript 1.10.0
(function() {
  var IndexController,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  angular.module('app').controller('mainCtrl', IndexController = (function() {
    IndexController.$inject = ['$scope', '$log', '$location', '$mdDialog', '$mdIcon', '$mdSidenav', '$mdToast', 'cart', 'breadcrumb', 'user'];

    function IndexController(scope, log, location, mdDialog, mdIcon, mdSidenav, mdToast, cart, breadcrumb, user) {
      this.scope = scope;
      this.log = log;
      this.location = location;
      this.mdDialog = mdDialog;
      this.mdIcon = mdIcon;
      this.mdSidenav = mdSidenav;
      this.mdToast = mdToast;
      this.cart = cart;
      this.breadcrumb = breadcrumb;
      this.user = user;
      this.showAdd = bind(this.showAdd, this);
      this.updateBreadcrumb = bind(this.updateBreadcrumb, this);
      this.sidenavToggle = bind(this.sidenavToggle, this);
      this.scope.user = this.user;
      this.scope.breadcrumb = this.breadcrumb;
      this.scope.cart = this.cart;
      this.scope.buttonsrc = "img/icon/add.svg";
      this.scope.menuItems = [
        {
          icon: 'img/icon/products.svg',
          title: 'Products',
          href: '/client-website/'
        }, {
          icon: 'img/icon/cart.svg',
          title: 'Cart',
          href: 'Cart/' + this.user.loggedUser.userId
        }
      ];
      this.scope.userItems = [
        {
          icon: 'img/icon/hamburger.svg',
          title: 'Orders'
        }, {
          icon: 'img/icon/balance.svg',
          title: 'Credits'
        }, {
          icon: 'img/icon/settings.svg',
          title: 'Settings'
        }
      ];
      angular.extend(this.scope, {
        sidenavToggle: this.sidenavToggle,
        updateBreadcrumb: this.updateBreadcrumb,
        showAdd: this.showAdd
      });
    }

    IndexController.prototype.sidenavToggle = function() {
      return this.mdSidenav('sideNav').toggle();
    };

    IndexController.prototype.updateBreadcrumb = function(index) {
      return this.breadcrumb.splice(index + 1, this.breadcrumb.length - index - 1);
    };

    IndexController.prototype.showAdd = function(ev) {
      var confirm, name;
      if (this.user.loggedUser.userId < 0) {
        return this.mdDialog.show({
          controller: 'loginCtrl',
          templateUrl: 'ngview/login/login.html',
          targetEvent: ev,
          clickOutsideToClose: true,
          onRemoving: function() {
            var toast;
            if (this.user.loggedUser.userId > 0) {
              toast = this.mdToast.simple().content(this.user.loggedUser.name + ' has logged in').hideDelay(500).position("top right");
              this.mdToast.show(toast);
              return this.scope.buttonsrc = "img/icon/account.svg";
            }
          }
        });
      } else {
        confirm = this.mdDialog.confirm({
          title: 'Logout',
          content: 'You are about to log out from your account',
          ok: 'OK',
          cancel: 'Cancel'
        });
        name = this.user.loggedUser.name;
        return this.mdDialog.show(confirm).then((function(_this) {
          return function() {
            var toast;
            _this.user.currentUser = {
              userId: -1,
              name: '',
              email: '',
              telephone: '',
              username: '',
              password: '',
              balance: 0.0,
              nfcCards: []
            };
            _this.user.loggedUser = {
              userId: -1,
              name: 'Login',
              email: '',
              telephone: '',
              username: '',
              password: '',
              balance: 0.0,
              nfcCards: []
            };
            _this.log.debug('User is logged out');
            _this.location.path('/');
            _this.scope.buttonsrc = "img/icon/add.svg";
            toast = _this.mdToast.simple().content(name + ' is logged out').hideDelay(500).position("top right");
            return _this.mdToast.show(toast);
          };
        })(this), (function(_this) {
          return function() {
            return _this.log.debug('User cancels logging out');
          };
        })(this));
      }
    };

    return IndexController;

  })());

}).call(this);

//# sourceMappingURL=index.js.map
