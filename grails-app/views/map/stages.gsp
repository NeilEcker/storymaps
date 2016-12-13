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
            <div class="row">
                <div class="col-md-12">

                <h3>Stages <small><g:link controller="stage" action="create" params="${[mapId: map.id]}">New Stage</g:link></small></h3>

                <ul id="stagesList" class="sortable">
                    <g:each in="${map.stages.sort { it.sortOrder } }" var="stage">
                        <li id="${stage.id}" class="list-group-item"><span class="glyphicon glyphicon-move" aria-hidden="true"></span> <g:link controller="stage" action="edit" id="${stage.id}">${stage}</g:link></li>
                    </g:each>
                </ul>

                    <button id="saveSortButton" class="btn btn-primary">Save Order</button>
                    <br />
                    <div id="saveMessage" class="text-success"></div>

                </div>
            </div>
        </div>

        <g:javascript>
            $(function  () {
                $("#stagesList").sortable({ });
            });

            $('#saveSortButton').click(function() {
                var order = [];
                $('#stagesList').children('li').each(function(idx, elm) {
                    order.push(elm.id)
                });

                //$.get('ajax.php', {action: 'updateOrder', 'order[]': order});
                //var order = $('#stagesList').sortable('serialize');

                console.log(order);

                $.ajax({
                    type: "POST",
                    data: {order: JSON.stringify(order)},
                    url: "/map/saveStageOrder",
                    success: function(msg){
                        $('#saveMessage').text(msg);
                    },
                    error: function(error){
                        console.log(msg);
                        $('#saveMessage').html("Something went wrong");
                    }
                });

            });
        </g:javascript>

    </body>
</html>
