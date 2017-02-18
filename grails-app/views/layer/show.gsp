<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'layer.label', default: 'Layer')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>

        <div id="show-layer" class="container">

            <ol class="breadcrumb">
                <li><g:link controller="layer" action="index">Layers</g:link></li>
                <li>${layer.name}</li>
            </ol>

            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <f:display bean="layer" />
            <g:form resource="${this.layer}" method="DELETE">
                <fieldset class="buttons">
                    <g:link class="btn btn-primary" action="edit" resource="${this.layer}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
                    <!--<input class="delete" type="submit" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />-->
                    <g:link class="btn btn-info" action="create">New Layer</g:link>
                </fieldset>
            </g:form>

        </div>
    </body>
</html>
