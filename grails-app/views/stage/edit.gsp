<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'stage.label', default: 'Stage')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
        <ckeditor:resources/>

        <asset:stylesheet href="uploadr.manifest.css"/>
        <asset:javascript src="uploadr.manifest.js"/>
    </head>
    <body>

        <div id="edit-stage" class="container-fluid">

            <ol class="breadcrumb">
                <li><g:link controller="map" action="index">Map List</g:link></li>
                <li><g:link controller="map" action="show" id="${stage.map.id}">${stage.map.title}</g:link></li>
                <li><g:link controller="map" action="stages" id="${stage.map.id}">Stages</g:link></li>
                <li>Edit ${stage}</li>
            </ol>

            <div class="col-md-2">
                <ul class="nav nav-pills nav-stacked" role="tablist" data-tabs="tabs">

                    <li role="presentation" ${!tab ? 'class=active' : ''}><a href="#locationTab" aria-controls="locationTab" role="tab" data-toggle="tab">Location</a></li>
                    <li role="presentation" ${tab == "photos" ? 'class=active' : ''}><a href="#photosTab" aria-controls="photosTab" role="tab" data-toggle="tab">Photos</a></li>
                    <li role="presentation" ${tab == "content" ? 'class=active' : ''}><a href="#contentTab" aria-controls="contentTab" role="tab" data-toggle="tab">Content</a></li>
                </ul>

            </div>

            <div class="col-md-10">

                <g:if test="${flash.message}">
                    <div class="alert alert-danger" role="alert">${flash.message}</div>
                </g:if>

                <div class="tab-content">
                    <div role="tabpanel" class="tab-pane fade ${!tab ? 'in active' : ''}" id="locationTab">
                        <g:hasErrors bean="${this.stage}">
                            <ul class="errors" role="alert">
                                <g:eachError bean="${this.stage}" var="error">
                                    <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                                </g:eachError>
                            </ul>
                        </g:hasErrors>
                        <g:form resource="${this.stage}" method="PUT">
                            <g:hiddenField name="version" value="${this.stage?.version}" />
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="title">Title</label>
                                        <input type="text" class="form-control" id="title" name="title" placeholder="Title" value="${stage.title}">
                                    </div>
                                    <div class="form-group">
                                        <label for="order">Sort Order</label>
                                        <g:field type="number" class="form-control" name="sortOrder" placeholder="Sort Order" value="${stage.sortOrder}" />
                                    </div>
                                    <div class="form-group">
                                        <label for="title">Latitude</label>
                                        <input type="text" class="form-control" id="latitude" name="latitude" placeholder="Latitude" value="${stage.latitude}">
                                    </div>
                                    <div class="form-group">
                                        <label for="title">Longitude</label>
                                        <input type="text" class="form-control" id="longitude" name="longitude" placeholder="Longitude" value="${stage.longitude}">
                                    </div>
                                    <div class="form-group">
                                        <label for="title">Zoom Level</label>
                                        <g:field type="number" class="form-control" name="zoom" min="1" max="20" required="" value="${stage?.zoom}"/>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div id="locationPicker" style="height: 400px;" />
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12">
                                    <g:field type="submit" class="btn btn-primary center-block" name="submit" value="Update" />
                                </div>
                            </div>

                        </g:form>
                    </div>


                </div>

                <div role="tabpanel" class="tab-pane fade ${tab == "photos" ? 'in active' : ''}" id="photosTab">
                    <g:uploadForm controller="Photo" action="save" name="photoUpload" class="form-inline">
                        <input type="hidden" name="stageId" value="${stage.id}" />
                        <div class="form-group">
                            <label for="photo">Add Photo</label>
                            <g:field type="file" name="photo" id="photo" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <g:field type="text" name="description" id="description" class="form-control" />
                        </div>
                        <g:field class="btn btn-default" type="submit" name="photo" value="Upload" />
                    </g:uploadForm>

                    <br />

                    <table class="table table-striped table-bordered">
                        <thead>
                        <th>Preview</th>
                        <th>Photo</th>
                        <th>Description</th>
                        <th>Type</th>
                        <th>Size</th>
                        <th></th>
                        </thead>
                        <tbody>
                        <g:each in="${stage.photos}" var="photo">
                            <tr>
                                <td><g:link controller="photo" action="getWebPhoto" id="${photo.id}"><img src="/photo/getThumbnail/${photo.id}" height="50" /></g:link></td>
                                <td><g:link controller="photo" action="getWebPhoto" id="${photo.id}">${photo.filename}</g:link></td>
                                <td>${photo.description}</td>
                                <td>${photo.contentType}</td>
                                <td><g:formatNumber number="${photo.size / 1024}" type="number" maxFractionDigits="0" /> kB</td>
                                <td>
                                    <g:link class="btn btn-warning" controller="photo" action="delete" id="${photo.id}">Delete</g:link>
                                    <g:link class="btn btn-info" controller="stage" action="setMapPhoto" id="${stage.id}" params="${[photoId: photo.id]}">Make Map Default</g:link>
                                </td>
                            </tr>
                        </g:each>
                        </tbody>
                    </table>
                </div>

                <div role="tabpanel" class="tab-pane fade ${tab == "content" ? 'in active' : ''}" id="contentTab">
                    <g:form resource="${this.stage}" method="PUT">
                        <div class="form-group">
                            <label for="content">Content</label>
                            <ckeditor:editor id="content" name="content" height="300px" width="100%" toolbar="Basic">
                                ${stage.content}
                            </ckeditor:editor>
                        </div>
                        <g:field type="submit" class="btn btn-primary" name="submit" value="Update" />
                    </g:form>
                </div>

            </div>

        </div>

    <g:javascript>

        var locationPicker = L.map('locationPicker').setView([${stage.latitude}, ${stage.longitude}], ${stage.zoom});
        var marker = L.marker([${stage.latitude}, ${stage.longitude}]).addTo(locationPicker);

        //Add tileLayer
        <g:if test="${stage.map.layer}">
            L.tileLayer('${stage.map.layer.url}', {
            attribution: '${stage.map.layer.attribution}'
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
            /*popup
            .setLatLng(e.latlng)
            .setContent("You clicked the map at " + e.latlng.toString())
            .openOn(locationPicker);*/
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
