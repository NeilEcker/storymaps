<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <title>Map Stages</title>
        <ckeditor:resources/>
    </head>
    <body>

        <div id="edit-map" class="container">

            <ol class="breadcrumb">
                <li><g:link controller="map" action="index">Map List</g:link></li>
                <li><g:link controller="map" action="show" id="${map.id}">${map.title}</g:link></li>
                <li>Edit</li>
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
            <br />
            <div class="row">
                <g:form resource="${this.map}" method="PUT">
                    <g:hiddenField name="version" value="${this.map?.version}" />
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="title">Title</label>
                                <input type="text" class="form-control" id="title" name="title" placeholder="Title" value="${map.title}">
                            </div>
                            <div class="form-group">
                                <label for="layer">Default Layer</label>
                                <g:select id="layer" name='layer' value="${map.layer?.id}"
                                          noSelection="${['null':'Select One...']}"
                                          from='${layers}'
                                          optionKey="id" optionValue="name" class="form-control" ></g:select>
                            </div>
                            <div class="form-group">
                                <label for="isPublic">Public</label>
                                <g:checkBox id="isPublic" name="isPublic" value="${map.isPublic}" />
                            </div>
                            <div class="form-group">
                                <label for="creator">Creator</label>
                                ${map.creator?.username}
                            </div>
                            <g:if test="${map.photoId}">
                                <div class="form-group">
                                    <label for="currentPhoto">Current photo</label>
                                    <img id="currentPhoto" src="/photo/getPhoto/${map.photoId}" height="50" />
                                </div>
                            </g:if>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <div class="form-group">
                            <label for="content">Overview</label>
                            <ckeditor:editor id="overview" name="overview" height="240px" width="100%" toolbar="Basic">
                                ${map.overview}
                            </ckeditor:editor>
                        </div>

                        <input class="btn btn-primary" type="submit" value="${message(code: 'default.button.update.label', default: 'Update')}" />
                        <g:link class="btn btn-default" controller="map" action="show" id="${map.id}">Cancel</g:link>
                    </div>
                </g:form>
            </div>
        </div>

    </body>
</html>
