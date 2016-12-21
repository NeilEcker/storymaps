<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'stage.label', default: 'Stage')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div id="show-stage" class="container">

            <ol class="breadcrumb">
                <li><g:link controller="map" action="show" id="${stage.map.id}">${stage.map.title}</g:link></li>
                <li><g:link controller="map" action="stages" id="${stage.map.id}">Stages</g:link></li>
                <li>${stage.title}</li>
            </ol>

            <g:if test="${flash.message}">
                <div class="alert" role="alert">${flash.message}</div>
            </g:if>

            <div class="row">${raw(stage.content)}</div>

            <div class="row">
                <g:link action="addPhotos" id="${stage.id}">Add Photos</g:link>
            </div>

            <br />

            <div class="row">
                <g:each in="${stage.photos}" var="photo">
                    <g:link controller="photo" action="getPhoto" id="${photo.id}">
                        <img src="/photo/getThumbnail/${photo.id}" height="50" />
                    </g:link>
                </g:each>
            </div>

            <br />

            <div class="row">
                <g:form resource="${this.stage}" method="DELETE">
                        <g:link class="btn btn-primary" action="edit" resource="${this.stage}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
                        <input class="btn btn-warning" type="submit" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
                </g:form>
            </div>
        </div>
    </body>
</html>
