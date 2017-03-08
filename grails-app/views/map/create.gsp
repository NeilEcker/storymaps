<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'map.label', default: 'Map')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
        <ckeditor:resources/>
    </head>
    <body>
        <div id="create-map" class="container">
            <ol class="breadcrumb">
                <li><g:link controller="map" action="index">Map List</g:link></li>
                <li>Create New Map</li>
            </ol>

            <g:if test="${flash.message}">
            <div class="message" role="status">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${this.map}">
            <ul class="errors" role="alert">
                <g:eachError bean="${this.map}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
                </g:eachError>
            </ul>
            </g:hasErrors>
            <g:form action="save">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" class="form-control" id="title" name="title" placeholder="Title">
                        </div>
                        <div class="form-group">
                            <label for="layer">Map Layer</label>
                            <g:select id="layer" name='layer'
                                      noSelection="${['null':'Select One...']}"
                                      from='${layers}'
                                      optionKey="id" optionValue="name" class="form-control" ></g:select>
                        </div>
                        <div class="form-group">
                            <label for="isPublic">Public</label>
                            <g:checkBox id="isPublic" name="isPublic" value="false" />
                        </div>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="form-group">
                        <label for="content">Overview</label>
                        <ckeditor:editor id="overview" name="overview" height="300px" width="100%" toolbar="Basic">
                            ${map.overview}
                        </ckeditor:editor>
                    </div>
                    <fieldset class="buttons">
                        <g:submitButton name="create" class="btn btn-primary" value="${message(code: 'default.button.create.label', default: 'Create')}" />
                    </fieldset>
                </div>
            </g:form>
        </div>

    </body>
</html>
