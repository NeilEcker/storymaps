(function () {
   'use strict';

   // additional layers
   var layers = {
     'test' : L.tileLayer.wms('http://limes.grid.unep.ch/geoserver/wms?', {
         layers: 'limes:Balkash_173_20140830_LC8_NDVI',
         tiled: true,
         format: 'image/png',
         transparent: true,
         maxZoom: 14,
         minZoom: 0,
         continuousWorld: true
         })
   };

   var markers = {
       balkash: {lat: 44.9117998, lon: 74.1202449, zoom: 12, layer:layers['test']},
       oslo: {lat: 59.92173, lon: 10.75719, zoom: 7},
       trondheim: {lat: 63.4319, lon: 10.3988, zoom: 7},
       bergen: {lat: 60.3992, lon: 5.3227, zoom: 7},
       tromso: {lat: 69.632, lon: 18.9197, zoom: 7},
       kristiansand: {lat: 58.17993, lon: 8.12952, zoom: 7},
       stavanger: {lat: 58.9694, lon: 5.73, zoom: 7},
       bodo: {lat: 67.28319, lon: 14.38565, zoom: 7}
   };
   

   $('.main').storymap({markers: markers});
}());