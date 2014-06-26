angular.module("moBilling.controllers.claimEditDetails", [])

    .controller("ClaimEditDetailsController", function ($scope) {
        $scope.claim.details || ($scope.claim.details = []);

        $scope.add = function (attributes) {
            $scope.claim.details.push(attributes || {});
        };

        $scope.remove = function (detail) {
            var index = $scope.claim.details.indexOf(detail);

            $scope.claim.details.splice(index, 1);
        };

        // WARNING! $digest already in progress AHEAD!
        // workaround for changing the date before the first date
        $scope.$watch("claim.details", function () {
            setTimeout(function () {
                $scope.claim.details.sort(function (a, b) {
                    if (!a.day || !b.day) {
                        return -Infinity;
                    } else {
                        return new Date(a.day) - new Date(b.day);
                    }
                });
            }, 100);
        }, true);
    });
