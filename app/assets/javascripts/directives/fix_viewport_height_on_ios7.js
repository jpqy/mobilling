angular.module("moBilling.directives")

    .directive("mbFixViewportHeightOnIos7", function ($document, $window, $interval) {
        return {
            restrict: "A",
            link: function (scope, element, attributes) {
                // function fixViewportHeightOnIOS7() {
                //     var height = Math.min($($window).height(), $window.innerHeight || Infinity);

                //     element.height(height);
                //     $window.scrollTo(0, 0);
                // }

                // $($window).on("resize orientationchange native.keyboardhide native.keyboardshow", fixViewportHeightOnIOS7);

                // fixViewportHeightOnIOS7();
            }
        };
    });
