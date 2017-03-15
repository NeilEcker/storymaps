<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'layer.label', default: 'Layer')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div id="list-layer" class="container">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

            <table class="table">
                <thead>
                    <th>Name</th>
                    <th>Type</th>
                    <th>Attribution</th>
                </thead>
                <tbody>
                    <g:each in="${layerList}" var="${layer}">
                        <tr>
                            <td><!--<g:link action="show" id="${layer.id}">${layer.name}</g:link>-->${layer.name}</td>
                            <td>${layer.type}</td>
                            <td>${raw(layer.attribution)}</td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
        </div>
    </body>
</html>