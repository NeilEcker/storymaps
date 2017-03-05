<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'map.label', default: 'Map')}" />
        <title><g:message code="default.edit.label" args="[entityName]" /></title>
    </head>
    <body>

        <div id="stages" class="container-fluid">

            <ol class="breadcrumb">
                <li><g:link controller="map" action="index">Map List</g:link></li>
                <li><g:link controller="map" action="show" id="${map.id}">${map.title}</g:link></li>
                <li>Stages</li>
            </ol>

            <g:if test="${flash.message}">
                <div class="alert alert-danger" role="alert">${flash.message}</div>
            </g:if>

            <div class="row">
                <div class="col-md-12">

                <ul id="stagesList" class="sortable">
                    <g:each in="${map.stages.sort { it.sortOrder } }" var="stage">
                        <li id="${stage.id}" class="list-group-item">
                            <div class="row">
                                <div class="col-md-1">
                                    <span class="glyphicon glyphicon-move" aria-hidden="true"></span>
                                </div>
                                <div class="col-md-3">
                                    <g:link controller="stage" action="edit" id="${stage.id}">${stage}</g:link>
                                </div>
                                 <div class="col-md-3">
                                     <g:link class="btn btn-primary btn-sm" controller="stage" action="edit" id="${stage.id}">Edit</g:link>
                                     <g:form resource="${stage}" method="DELETE">
                                         <input class="btn btn-warning btn-sm" type="submit" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
                                     </g:form>
                                 </div>
                            </div>
                        </li>
                    </g:each>
                </ul>

                    <p>Drag rows to reorder</p>
                    <g:link class="btn btn-default" action="createStage" id="${map.id}">Create New Stage</g:link>
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
