(function () {
    'use strict';

    angular
        .module('app.support', ['ngRoute','ngSanitize','Tandem'])
        .config(function ($routeProvider) {

            $routeProvider
                .when('/tandem', {
                    templateUrl: '/assets/tandem.html',
                    controller: function ($scope, $modal, Tandem) {

                        Tandem.query().then(function(tandems) {
                            $scope.grudgeportraits = tandems;
                        });



                        $scope.portraits = [


                            {
                                title: 'Heike & Michael',
                                pic: 8,
                                text: 'haben sich beim Foto-Shooting kennengelernt, gut verstanden und sind einfach zusammen aufs Tandem gestiegen. Michael ist über Facebook auf die Tandem-Kampagne aufmerksam geworden und Heike über ihre Tandempartnerin.'
                            },

                            {
                                title: 'Julie & Jana',
                                pic: 4,
                                video: 'TjDPzA3JWcI',
                                text: 'Julie wünscht Jana Grundeinkommen, damit ihre Selbstständigkeit gelingt. Sie haben sich bei einer Lesebühne kennengelernt und sich dort über das Leben ausgetauscht. Julie wohnt derzeit bei Jana, ist aber dringend auf der Suche nach einem WG-Zimmer. '
                            },
                            {
                                title: 'Toni & Lisa',
                                pic: 6,
                                video: 'AvneReV2rZw',
                                text: 'Lisa gönnt Toni ein Grundeinnkommen, damit er mit seinem Sohn nach Afrika verreisen kann. Toni gönnt Lisa ein Grundeinkommen, damit sie auswandern kann. Gemeinsam würden sie sich einen VW-Bus kaufen. Lisa und Toni haben mal zusammen gewohnt, jetzt sind sie ein Paar.'
                            },
                            {
                                title: 'Anja & Flora',
                                pic: 3,
                                text: 'Ein Tandem-Grundeinkommen würde Anja dazu nutzen, ihre Doktorarbeit über Schlaganfallpatienten zu beenden. Flora würde mit dem Geld nach Südkorea fahren und einen Intensiv-Sprachkurs machen. Das Tandem-Foto wollen sie in ihrer WG aufhängen.'
                            },
                            {
                                title: 'Falk, Stefan & Nele',
                                pic: 9,
                                video: 'NcB2Aufd-3w',
                                text: 'haben zusammen untereinander Tandems gebildet. Alle drei sind Theaterschaffende. Unter der Woche stehen sie bis zu 40 Stunden auf der Bühne. Zur Zeit spielen sie gemeinsam in einem  Theaterprojekt zum Thema “Gewinnen”. Gerne würden sie auch im echten Leben gewinnen.'
                            },

                            {
                                title: 'Mathias & Susanne',
                                pic: 5,
                                text: 'Mit Grundeinkommen würden beide zusammen ein weiteres Musikvideo produzieren und einen Kurzgeschichten-Band herausgeben. Susanne ist Künstlerin und Autorin. Mathias ist Mitglied der Rock-Band heisskalt. Kennengelernt haben sie sich nachts um 5 Uhr in einem Leipziger Club.'
                            },
                            {
                                title: 'Frank & Tina',
                                pic: 1,
                                video: 'qgW5MviTciE',
                                text: 'Tina hat sich gerade als psychologische Beraterin selbstständig gemacht. Da Tina Franks große Liebe ist und er ihr Projekt super findet, gönnt er ihr vom ganzen Herzen  Grundeinkommen. Frank würde von dem Geld den Umbau seines Elternhauses  finanzieren.'
                            },

                            {
                                title: 'Marina & Janine',
                                pic: 7,
                                text: 'Beide gönnen sich gegenseitig Grundeinkommen, weil sie sich sicher sind, dass die jeweils andere einen Teil des Geldes in ihr gemeinsames Hausprojekt “die rote Insel” investieren würde. Janine hat als großer Grundeinkommens-Fan Marina auf die Tandemverlosung aufmerksam gemacht. '
                            },
                            {
                                title: 'Agatha & Daniel',
                                pic: 2,
                                text: 'gönnen sich gegenseitig Grundeinkommen, um gemeinsam Musikprojekte zu verwirklichen. Agatha ist Geigerin und Daniel macht 20er-Jahre-Musik und singt. Zusammen sind sie ein super Musik-Duo.'
                            },
                            {
                                title: 'Claudia & Heike',
                                pic: 10,
                                text: 'Claudia gönnt Heike Grundeinkommen, damit sie sich für eine bessere Welt einsetzen kann und mehr Zeit für ihre Tochter hat. Heike gönnt Claudia Grundeinkommen, damit sie in ihrer momentanen Lebensumbruchphase keine Existenzangst haben muss. Die beiden haben sich über ihre Tanzgruppe kennengelernt.'
                            },
                            {
                                title: 'Michael',
                                pic: 11,
                                video: 'xY5-dE5Pna0',
                                text: 'unterrichtet Deutsch. Für seine Tandempartnerin Maggie hat er eine wichtige Nachricht: Er möchte, dass sie ihre Kreativität und Genialität weiter auslebt.'
                            }


                        ]



                        $scope.openVideoModal = function(tandem) {
                          var VideoModal;
                          if (tandem.video) {
                              return VideoModal = $modal.open({
                                templateUrl: "videomodal.html",
                                size: 'lg',
                                controller: [
                                  "$scope", "tandem", "$modalInstance", "$sce", function($scope, tandem, $modalInstance,$sce) {

                                    $scope.slug = $sce.trustAsResourceUrl("//www.youtube.com/embed/" + tandem.video + "?autoplay=1");

                                  }
                                ],
                                resolve: {
                                  tandem: function() {
                                    return tandem;
                                  }
                                }
                              });
                        }
                        else {
                            void(0);
                        }
                        };

                    },
                })
                .when('/bgemitdir', {
                    redirectTo: '/tandem'
                })
                .when('/advocate-europe', {
                    templateUrl: '/assets/advocateEurope.html'
                })
                .when('/support', {
                    redirectTo: '/support/crowdfund'
                })
                .when('/support/crowdbar', {
                    templateUrl: '/assets/support/crowdbar.html',
                    label: 'Unterstützen'
                })
                .when('/support/crowdcard', {
                    templateUrl: '/assets/support/crowdcard.html',
                    label: 'Unterstützen'
                })
                .when('/support/cola', {
                    templateUrl: '/assets/support/cola.html',
                    label: 'Unterstützen'
                })
                .when('/support/donate', {
                    redirectTo: '/support/crowdfund'
                })
                .when('/support/crowdfund', {
                    templateUrl: '/assets/support/donate.html',
                    controllerAs: 'vm',
                    controller: function ($scope, $location, anchorSmoothScroll) {
                        var vm = this;

                        vm.changeOption = toggleOptions;

                        if ($scope.current.isAuthenticated()) {
                            vm.option = 'primary';
                        }
                        else {
                            vm.option = 'secondary';
                        }

                        function toggleOptions(option) {

                            vm.option = option;

                            anchorSmoothScroll.scrollTo('funding');
                        }

                    },
                    label: 'Unterstützen'
                });

        });

}());