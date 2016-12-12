<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'map.label', default: 'Map')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>

        <div id="stages" class="container">

            <ol class="breadcrumb">
                <li><g:link controller="map" action="index">Map List</g:link></li>
                <li><g:link controller="map" action="show" id="${map.id}">${map.title}</g:link></li>
                <li>Stages</li>
            </ol>

            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <br />
            <div class="row">
                <div class="col-md-12">

                Stages <small><g:link controller="stage" action="create" params="${[mapId: map.id]}">New Stage</g:link></small>
                <ul class="sortable">
                    <g:each in="${map.stages.sort { it.sortOrder } }" var="stage">
                        <li class="list-group-item"><span class="glyphicon glyphicon-move" aria-hidden="true"></span> <g:link controller="stage" action="edit" id="${stage.id}">${stage}</g:link></li>
                    </g:each>
                </ul>

                </div>
            </div>
        </div>

        <g:javascript>
            $(function  () {
                $("ul.sortable").sortable({ });
            });
        </g:javascript>

    </body>
</html>
