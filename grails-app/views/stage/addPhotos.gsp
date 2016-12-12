<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <title>Add Photos</title>
    </head>
    <body>
        <div id="show-stage" class="container">


            <ol class="breadcrumb">
                <li><g:link controller="map" action="index">Map List</g:link></li>
                <li><g:link controller="map" action="show" id="${stage.map.id}">${stage.map.title}</g:link></li>
                <li><g:link controller="stage" action="show" id="${stage.id}">${stage.title}</g:link></li>
                <li>Add Photos</li>
            </ol>

            <g:if test="${flash.message}">
                <div class="alert alert-danger" role="alert">${flash.message}</div>
            </g:if>

            <br />

            <g:uploadForm controller="Photo" action="save" name="photoUpload" class="form-inline">
                <input type="hidden" name="stageId" value="${stage.id}" />
                <div class="form-group">
                    <label for="photo">Add Photo</label>
                    <g:field type="file" name="photo" id="photo" class="form-control" />
                </div>
                <g:field class="btn btn-default" type="submit" name="photo" value="Upload" />
            </g:uploadForm>

            <br />

            <table class="table table-striped table-bordered">
                <thead>
                    <th>Preview</th>
                    <th>Photo</th>
                    <th>Type</th>
                    <th>Size</th>
                    <th></th>
                </thead>
                <tbody>
                    <g:each in="${stage.photos}" var="photo">
                        <tr>
                            <td><g:link controller="photo" action="getWebPhoto" id="${photo.id}"><img src="/photo/getThumbnail/${photo.id}" height="50" /></g:link></td>
                            <td><g:link controller="photo" action="getWebPhoto" id="${photo.id}">${photo.filename}</g:link></td>
                            <td>${photo.contentType}</td>
                            <td><g:formatNumber number="${photo.size / 1024}" type="number" maxFractionDigits="0" /> kB</td>
                            <td><g:link class="btn btn-warning" controller="photo" action="delete" id="${photo.id}">Delete</g:link></td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>
    </body>
</html>
