<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'map.label', default: 'Map')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">

                <div class="col-sm-9 col-md-7 main">

                    <div class="row">
                        <h1 class="page-header">${map.title}</h1>
                    </div>
                    <div class="row">
                        <g:link class="btn-link btn-sm" action="edit" id="${map.id}">Edit</g:link>
                        <g:link class="btn-link btn-sm" action="stages" id="${map.id}">Stages</g:link>
                    </div>
                    <div class="row">
                        <section id="mainSection" data-place="overview" data-titles="${titles}" data-coordinates="${coordinates}">
                            ${raw(map.overview)}
                        </section>
                    </div>

                    <g:each in="${map.stages.sort { it.sortOrder } }" var="stage">

                        <div class="row">
                            <h2 id="${stage.title.replaceAll('\\s','')}">${stage.title}</h2>
                        </div>
                        <div class="row">
                            <g:link class="btn-link btn-sm" controller="stage" action="edit" id="${stage.id}">Edit</g:link>
                            <g:link class="btn-link btn-sm" controller="stage" action="addPhotos" id="${stage.id}">Add Photos</g:link>
                        </div>
                        <div class="row">
                            <section data-place="${stage.title.replaceAll('\\s','')}">

                                ${raw(stage.content)}

                                <div class="row">

                                    <g:each in="${stage.photos}" var="photo">
                                        <div class="col-lg-3 col-md-3 col-xs-6" style="padding-bottom: 10px;">
                                            <a href="/photo/getWebPhoto/${photo.id}" data-type="image" data-title="${photo.description}" data-toggle="lightbox" data-gallery="example-gallery">
                                                <img src="/photo/getThumbnail/${photo.id}" class="img-responsive">
                                            </a>
                                        </div>
                                    </g:each>
                                </div>
                            </section>
                        </div>

                    </g:each>

                </div>

                <div id="map" class="col-sm-3 col-md-5 sidebar"></div>

            </div>
        </div>

        <g:javascript>
            $(document).on('click', '[data-toggle="lightbox"]', function(event) {
                event.preventDefault();
                $(this).ekkoLightbox({
                    left_arrow_class: '.glyphicon .glyphicon-chevron-left',
                });
            });

            // WMS layers
            /*var layers = {
                'test' : L.tileLayer.wms('http://limes.grid.unep.ch/geoserver/wms?', {
                layers: 'limes:Balkash_173_20140830_LC8_NDVI',
                tiled: true,
                format: 'image/png',
                transparent: true,
                maxZoom: 14,
                minZoom: 0,
                continuousWorld: true
                })
            };*/

            var layers = {
            <g:each in="${layers}" var="layer">
                '${layer.name}' : L.tileLayer('${layer.url}', {
                    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                }),
            </g:each>
            };

            var markers = {
                'overview': {layer:layers['${map.layer?.name ?: "OpenStreetMap"}']},
                <g:each in="${map.stages}" var="stage">
                    ${stage.title.replaceAll("\\s","")}: {lat: ${stage.latitude}, lon: ${stage.longitude}, zoom: ${stage.zoom}, layer:layers['${stage.layer?.name ?: "OpenStreetMap"}']},
                </g:each>
            };

            $('.main').storymap({markers: markers});

            /*$('#mainSection').trigger('viewing');*/

        </g:javascript>
    </body>
</html>
