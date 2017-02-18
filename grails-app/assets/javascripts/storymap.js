    (function ($) {
    'use strict';

    var map;
    var fg;

    $.fn.storymap = function(options) {

        var defaults = {
            selector: '[data-place]',
            breakpointPos: '33.333%',
            createMap: function () {
                map = L.map('map').setView([65, 18], 5);
                return map;
            }
        };

        var settings = $.extend(defaults, options);

        if (typeof(L) === 'undefined') {
            throw new Error('Storymap requires Laeaflet');
        }
        if (typeof(_) === 'undefined') {
            throw new Error('Storymap requires underscore.js');
        }

        function getDistanceToTop(elem, top) {
            var docViewTop = $(window).scrollTop();

            var elemTop = $(elem).offset().top;

            var dist = elemTop - docViewTop;

            var d1 = top - dist;

            if (d1 < 0) {
                return $(document).height();
            }
            return d1;

        }

        function highlightTopPara(paragraphs, top) {

            var distances = _.map(paragraphs, function (element) {
                var dist = getDistanceToTop(element, top);
                return {el: $(element), distance: dist};
            });

            var closest = _.min(distances, function (dist) {
                return dist.distance;
            });

            _.each(paragraphs, function (element) {
                var paragraph = $(element);
                if (paragraph[0] !== closest.el[0]) {
                    paragraph.trigger('notviewing');
                }
            });

            if (!closest.el.hasClass('viewing')) {
                closest.el.trigger('viewing');
            }
        }

        function watchHighlight(element, searchfor, top) {
            var paragraphs = element.find(searchfor);
            highlightTopPara(paragraphs, top);
            $(window).scroll(function () {
                highlightTopPara(paragraphs, top);
            });
        }

        var makeStoryMap = function (element, markers) {

            var topElem = $('<div class="breakpoint-current"></div>')
                .css('top', settings.breakpointPos);
            $('body').append(topElem);

            var top = topElem.offset().top - $(window).scrollTop();

            var searchfor = settings.selector;

            var paragraphs = element.find(searchfor);

            paragraphs.on('viewing', function () {
                $(this).addClass('viewing');
            });

            paragraphs.on('notviewing', function () {
                $(this).removeClass('viewing');
            });

            watchHighlight(element, searchfor, top);

            var map = settings.createMap();

            map.on('click', function(e) {
              console.log("Lat, Lon : " + e.latlng.lat + ", " + e.latlng.lng)
            });

            var initPoint = map.getCenter();
            var initZoom = map.getZoom();

            fg = L.featureGroup().addTo(map);
            var current = L.featureGroup().addTo(map);

            function showMapView(key) {

                if (key === 'overview') {
                    fg.clearLayers();
                    setOverview();
                } else if (markers[key]) {
                    //If layer is different, remove and add layer
                    var marker = markers[key];
                    var layer = marker.layer;

                    if (map.hasLayer(layer)) {
                        //fg.clearLayers();
                        //console.log("hasLayer");
                    } else {
                        if(typeof layer !== 'undefined'){
                            //console.log("Clearing and adding new layer");
                          fg.clearLayers();
                          fg.addLayer(layer);
                        };
                    }

                    current.clearLayers();
                    current.addLayer(L.marker([marker.lat, marker.lon], {
                       icon: greenFlag
                    }));

                    map.setView([marker.lat, marker.lon], marker.zoom, 1);
                }

            }

            paragraphs.on('viewing', function () {
                showMapView($(this).data('place'));
            });
        };

        var blueFlag = L.icon({
            iconUrl: '/assets/flag_map_blue.png',
            iconSize:     [64, 64],
            iconAnchor:   [32, 64],
            popupAnchor:  [-3, -76]
        });

        var greenFlag = L.icon({
            iconUrl: '/assets/flag_map_green.png',
            iconSize:     [64, 64],
            iconAnchor:   [32, 64],
            popupAnchor:  [-3, -76]
        });

        function setOverview() {
            var marker = markers['overview'];
            var layer = marker.layer;
            fg.addLayer(layer);

            var coordinates = $("#mainSection").data('coordinates');
            var titles = $("#mainSection").data('titles').split(",");

            //Show path
            L.polyline(coordinates).addTo(map);

            for (var i = 0; i < coordinates.length; i++) {
                var m = L.marker(coordinates[i], {
                    icon: blueFlag,
                    alt: titles[i]
                })
                m.on('click', function(e) {
                    $('html, body').animate({
                        scrollTop:$('#' + e.target.options.alt).offset().top
                    }, 'slow');
                });
                m.addTo(map);
            }

            var bounds = L.latLngBounds(coordinates);
            map.fitBounds(bounds);
            if (map.getZoom() > 14) {
                map.setZoom(14);
            }
        }

        makeStoryMap(this, settings.markers);

        setOverview();

        return this;
    }

}(jQuery));
