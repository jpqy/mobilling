angular.module("moBilling")

    .config(function ($routeProvider) {
        $routeProvider.when("/sign-in", {
            templateUrl: "sign-in.html",
            controller: "SignInController",
            guest: true
        });

        $routeProvider.when("/sign-up", {
            templateUrl: "sign-up.html",
            controller: "SignUpController",
            guest: true,
            resolve: {
                agents: function (Agent) {
                    return Agent.query().$promise;
                }
            }
        });

        $routeProvider.when("/sign-out", {
            templateUrl: "loading.html",
            controller: "SignOutController"
        });

        $routeProvider.when("/unlock", {
            templateUrl: "unlock.html",
            controller: "UnlockController",
            resolve: {
                user: function (User) {
                    return User.get().$promise;
                }
            }
        });

        $routeProvider.when("/password-reset", {
            templateUrl: "password-reset.html",
            controller: "PasswordResetController",
            guest: true
        });

        $routeProvider.when("/profile", {
            templateUrl: "profile.html",
            controller: "ProfileController",
            resolve: {
                agents: function (Agent) {
                    return Agent.query().$promise;
                },
                user: function (User) {
                    return User.get().$promise;
                }
            }
        });

        $routeProvider.when("/claims", {
            templateUrl: "claim-list.html",
            controller: "ClaimListController",
            resolve: {
                claims: function (Claim) {
                    return Claim.query().$promise;
                },
                user: function (User) {
                    return User.get().$promise;
                }
            }
        });

        $routeProvider.when("/:specialty/claims/new", {
            templateUrl: "claim-edit.html",
            controller: "ClaimEditController",
            resolve: {
                claim: function ($route, Claim) {
                    return new Claim({ specialty: $route.current.params.specialty });
                },
                claims: function (Claim) {
                    return Claim.query().$promise;
                },
                diagnoses: function (Diagnosis) {
                    return Diagnosis.promise;
                },
                hospitals: function (Hospital) {
                    return Hospital.promise;
                },
                serviceCodes: function (ServiceCode) {
                    return ServiceCode.promise;
                }
            }
        });

        $routeProvider.when("/claims/:claim_id/edit", {
            templateUrl: "claim-edit.html",
            controller: "ClaimEditController",
            resolve: {
                claim: function ($route, Claim) {
                    return Claim.get({ id: $route.current.params.claim_id }).$promise;
                },
                claims: function (Claim) {
                    return Claim.query().$promise;
                },
                diagnoses: function (Diagnosis) {
                    return Diagnosis.promise;
                },
                hospitals: function (Hospital) {
                    return Hospital.promise;
                },
                serviceCodes: function (ServiceCode) {
                    return ServiceCode.promise;
                }
            }
        });

        $routeProvider.when("/claims/:claim_id", {
            templateUrl: "claim-show.html",
            controller: "ClaimEditController",
            resolve: {
                claim: function ($route, Claim) {
                    return Claim.get({ id: $route.current.params.claim_id }).$promise;
                },
                claims: function (Claim) {
                    return Claim.query().$promise;
                },
                diagnoses: function (Diagnosis) {
                    return Diagnosis.promise;
                },
                hospitals: function (Hospital) {
                    return Hospital.promise;
                },
                serviceCodes: function (ServiceCode) {
                    return ServiceCode.promise;
                }
            }
        });

        $routeProvider.otherwise({
            redirectTo: "/claims"
        });
    })

    .run(function ($rootScope, $location) {
        $rootScope.$on("$routeChangeStart", function (event, next, current) {
            var authenticationToken = window.localStorage.getItem("authenticationToken");

            if (next.guest && authenticationToken) {
                $location.path("/claims").replace();
            }

            if (!next.guest && !authenticationToken) {
                $location.path("/sign-in").replace();
            }

            $rootScope.loading = true;
        });

        $rootScope.$on("$routeChangeError", function (event, next, current, error) {
            if (error.status === 401) {
                window.localStorage.removeItem("authenticationToken");
                $location.path("/sign-in").replace();
            }
        });

        $rootScope.$on("$routeChangeSuccess", function () {
            $rootScope.loading = false;
        });
    });
