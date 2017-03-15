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

                <div class="col-sm-8 col-md-6 main">

                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h4 class="pull-left">${map.title}</h4>
                            <g:if test="${isCreator}">
                                <div class="dropdown pull-right">
                                    <button class="btn btn-default btn-sm dropdown-toggle" type="button" id="editMap" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                        Settings <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                                        <li><g:link action="edit" id="${map.id}">Edit</g:link></li>
                                        <li><g:link action="stages" id="${map.id}">Stages</g:link></li>
                                    </ul>
                                </div>
                            </g:if>
                            <div class="clearfix"></div>
                        </div>
                        <div class="panel-body">
                            <section id="mainSection" data-place="overview" data-titles="${titles}" data-coordinates="${coordinates}">
                                <div style="margin-right: 20px;">
                                    ${raw(map.overview)}
                                </div>
                            </section>
                        </div>
                    </div>

                    <g:each in="${map.stages.sort { it.sortOrder } }" var="stage">

                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <h4 class="pull-left" id="${stage.title.replaceAll('\\s','')}">${stage.title}</h4>
                                <g:if test="${isCreator}">
                                    <g:link controller="stage" action="edit" class="btn btn-default btn-sm pull-right" id="${stage.id}">
                                        <span class="glyphicon glyphicon-cog"></span>
                                    </g:link>
                                </g:if>
                                <div class="clearfix"></div>
                            </div>
                            <div class="panel-body">
                                <section data-place="${stage.title.replaceAll('\\s','')}">

                                    <div class="col-md-12">
                                        ${raw(stage.content)}

                                        <div class="photos">
                                            <g:each in="${stage.photos}" var="photo">
                                                <div class="photo-thumbnail-div">
                                                    <a href="/photo/getWebPhoto/${photo.id}" data-type="image" data-title="${photo.description}" data-toggle="lightbox" data-gallery="example-gallery">
                                                        <img src="/photo/getThumbnail/${photo.id}" class="photo-thumbnail object-fit_cover">
                                                    </a>
                                                </div>
                                            </g:each>
                                        </div>

                                    </div>
                                </section>
                            </div>
                        </div>

                    </g:each>

                </div>

                <div id="map" class="col-sm-4 col-md-6 sidebar"></div>

            </div>
        </div>

        <g:javascript>
            $(document).on('click', '[data-toggle="lightbox"]', function(event) {
                event.preventDefault();
                $(this).ekkoLightbox({
                    left_arrow_class: '.glyphicon .glyphicon-chevron-left',
                });
            });

            $('.photos').slick({
                infinite: true,
                slidesToShow: 3,
                slidesToScroll: 3
            });

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
                    ${stage.title.replaceAll("\\s","")}: {lat: ${stage.latitude}, lon: ${stage.longitude}, zoom: ${stage.zoom}, layer:layers['${map.layer?.name ?: "OpenStreetMap"}']},
                </g:each>
            };

            $('.main').storymap({markers: markers});

        </g:javascript>
    </body>
</html>
