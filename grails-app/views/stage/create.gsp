<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'stage.label', default: 'Stage')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <ckeditor:resources/>
    </head>
    <body>

        <div id="create-stage" class="container">
            <ol class="breadcrumb">
                <li><g:link controller="map" action="show" id="${map?.id}">${map?.title}</g:link></li>
                <li>Create Stage</li>
            </ol>

            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.stage}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.stage}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>

            <g:form action="save">
                <g:hiddenField name="version" value="${this.stage?.version}" />
                <g:hiddenField name="map" value="${params.mapId}" />
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" class="form-control" id="title" name="title" placeholder="Title">
                        </div>
                        <div class="form-group">
                            <label for="order">Sort Order</label>
                            <g:field type="number" class="form-control" name="sortOrder" placeholder="Sort Order" required="" />
                        </div>
                        <div class="form-group">
                            <label for="layer">Layer</label>
                            <g:select id="layer" name='layer'
                                      noSelection="${['null':'Select One...']}"
                                      from='${layers}' value="${map.layer?.id}"
                                      optionKey="id" optionValue="name" class="form-control" ></g:select>
                        </div>
                        <div class="form-group">
                            <label for="title">Latitude</label>
                            <input type="text" class="form-control" id="latitude" name="latitude" placeholder="Latitude">
                        </div>
                        <div class="form-group">
                            <label for="title">Longitude</label>
                            <g:field type="text" class="form-control" name="longitude" placeholder="Longitude" required=""/>
                        </div>
                        <div class="form-group">
                            <label for="title">Zoom Level</label>
                            <g:field type="number" class="form-control" name="zoom" min="1" max="20" required="" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div id="locationPicker" style="height: 440px;" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="content">Content</label>
                            <ckeditor:editor id="content" name="content" height="300px" width="100%" toolbar="Basic">
                                ${stage.content}
                            </ckeditor:editor>
                        </div>
                    </div>
                </div>
                <g:submitButton name="create" class="btn btn-primary" value="${message(code: 'default.button.create.label', default: 'Create')}" />
                <g:link class="btn btn-default" controller="map" action="show" id="${params.mapId}">Cancel</g:link>
            </g:form>

        </div>

        <g:javascript>
            var locationPicker = L.map('locationPicker').setView([44.0, -81], 6);
            var marker = L.marker([44.0, -81]).addTo(locationPicker);

            //Add tileLayer
            <g:if test="${map.layer}">
                L.tileLayer('${map.layer.url}', {
                attribution: '${map.layer.attribution}'
                }).addTo(locationPicker);
            </g:if>
            <g:else>
                L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpandmbXliNDBjZWd2M2x6bDk3c2ZtOTkifQ._QA7i5Mpkd_m30IGElHziw', {
                    maxZoom: 18,
                    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
                        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
                        'Imagery © <a href="http://mapbox.com">Mapbox</a>',
                    id: 'mapbox.streets'
                }).addTo(locationPicker);
            </g:else>

            var popup = L.popup();

            function onMapClick(e) {
                $('#latitude').val(e.latlng.lat);
                $('#longitude').val(e.latlng.lng);
                $('#zoom').val(locationPicker.getZoom());
                marker.setLatLng(e.latlng);
            }

            locationPicker.on('click', onMapClick);

            $('#latitude').change(setView);
            $('#longitude').change(setView);
            $('#zoom').change(setView);

            function setView() {
                var lat = $('#latitude').val();
                var lng = $('#longitude').val();
                var zoom = $('#zoom').val();

                locationPicker.setView([lat, lng], zoom);
            }
        </g:javascript>
    </body>
</html>
