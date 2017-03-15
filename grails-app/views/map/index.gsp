<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'map.label', default: 'Map')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div id="list-map" class="container">

            <g:if test="${flash.message}">
                <div class="message" role="status">${flash.message}</div>
            </g:if>

            <g:each in="${mapList}" var="map">
                <div class="media">
                    <div class="media-left">
                        <g:link action="show" id="${map.id}" class="list-group-item">
                            <g:if test="${map.photoId}">
                                <img class="media-object" src="/photo/getThumbnail/${map.photoId}" alt="${map.title}" style="width: 100px;" />
                            </g:if>
                            <g:else>
                                ${map.title}
                            </g:else>
                        </g:link>
                    </div>
                    <div class="media-body">
                        <h4 class="media-heading">${map.title}</h4>
                        <g:if test="${map.isPublic}">
                            <span class="label label-primary">Public</span>
                        </g:if>
                        <g:else>
                            <span class="label label-info">Private</span>
                        </g:else><br /><br />
                        ${raw(map.overview)}
                    </div>
                </div>
            </g:each>

        </div>
    </body>
</html>