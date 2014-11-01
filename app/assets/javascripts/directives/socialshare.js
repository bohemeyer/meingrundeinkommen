// Code goes here
'use strict';

/*
 *  * angular-socialshare v0.0.2
 *   * ♡ CopyHeart 2014 by Dayanand Prabhu http://djds4rce.github.io
 *    * Copying is an act of love. Please copy.
 *     */

angular.module('djds4rce.angular-socialshare', [])
.factory('$FB',['$window',function($window){
  return {
    init: function(fbId){
      if(fbId){
        this.fbId = fbId;
        $window.fbAsyncInit = function() {
          FB.init({
            appId: fbId,
            channelUrl: 'app/channel.html',
            status: true,
            xfbml: true
          });
        };
        (function(d){
          var js,
          id = 'facebook-jssdk',
          ref = d.getElementsByTagName('script')[0];
          if (d.getElementById(id)) {
            return;
          }

          js = d.createElement('script');
          js.id = id;
          js.async = true;
          js.src = "//connect.facebook.net/en_US/all.js";

          ref.parentNode.insertBefore(js, ref);

        }(document));
      }
      else{
        throw("FB App Id Cannot be blank");
      }
    }
  };

}]).directive('facebook', ['$timeout','$http', function($timeout,$http) {
  return {
    scope: {
      shares: '='
    },
    transclude: true,
    template: '<div class="btn btn-small btn-grey">' +
      '<i class="icon-facebook"></i> &nbsp; Facebook' +
    '</div>' +
    '<div class="facebookCount">' +
      '<div class="pluginCountButton pluginCountNum">' +
        '<span ng-transclude></span>' +
      '</div>' +
      '<div class="pluginCountButtonNub"><s></s><i></i></div>' +
    '</div>',
    link: function(scope, element, attr) {
      if(attr.shares){
        attr.$observe('url', function(){
          $http.get('https://api.facebook.com/method/links.getStats?urls='+attr.url+'&format=json').success(function(res){
            var count = res[0] ? res[0].share_count.toString() : 0;
            var decimal = '';
            if(count.length > 6){
              if(count.slice(-6,-5) != "0"){
                decimal = '.'+count.slice(-6,-5);
              }
              count = count.slice(0, -6);
              count = count + decimal + 'M';
            }else if(count.length > 3){
              if(count.slice(-3,-2) != "0"){
                decimal = '.'+count.slice(-3,-2);
              }
              count = count.slice(0, -3);
              count = count + decimal + 'k';
            }
            scope.shares = count;
          }).error(function(){
            scope.shares = 0;
          });
        });
      }
      $timeout(function(){
        element.bind('click',function(e){
          FB.ui(
            {method: 'share',
              href: attr.url
          });
          e.preventDefault();
        });
      });
    }
  };
}]).directive('twitter',['$timeout', '$window',function($timeout, $window) {
  return {
    link: function(scope, element, attr) {
      $timeout(function() {
        $timeout(function() {
          twttr.widgets.createShareButton(
            attr.url || $window.location.href,
            element[0],
            function() {}, {
              count: attr.count,
              text: attr.text,
              via: attr.via,
              size: attr.size
            }
          );
        });
      });
    }
  };
}]).directive('gplus',[function(){
  return {
    link: function(scope,element,attr){
      if(typeof gapi == "undefined"){
        (function() {
          var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
          po.src = 'https://apis.google.com/js/plusone.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
        })();
      }
    }
  };
}]);