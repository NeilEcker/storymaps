package storymap

import org.springframework.web.multipart.MultipartFile

import grails.plugin.springsecurity.annotation.Secured
import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured(['ROLE_USER'])
@Transactional(readOnly = true)
class PhotoController {

    ThumbnailService thumbnailService

    static allowedMethods = [save: "POST", update: "PUT", delete: "GET"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Photo.list(params), model:[photoCount: Photo.count()]
    }

    def show(Photo photo) {
        respond photo
    }

    def create() {
        respond new Photo(params)
    }

    @Transactional
    def save(Photo photo) {

        MultipartFile uploadedPhoto = request.getFile("photo")

        if (uploadedPhoto.size) {
            photo.photo = uploadedPhoto.bytes
            photo.contentType = uploadedPhoto.contentType
            photo.size = uploadedPhoto.size
            photo.filename = uploadedPhoto.originalFilename

            //Create thumbnail
            photo.thumbnail = thumbnailService.createThumbnail(photo.photo, "jpeg")

            //Create webImage
            photo.webPhoto = thumbnailService.createWebPhoto(photo.photo, "jpeg")
        }

        photo.validate()

        if (photo == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (photo.hasErrors()) {
            transactionStatus.setRollbackOnly()
            flash.message = "Error Uploading Photo"
            redirect controller:"stage", action:"show", id: params.stageId
            return
        }


        photo.save flush:true, failOnError: true

        if (params.stageId) {
            //Get Stage
            Stage stage = Stage.get(params.stageId)
            stage.photos.add(photo)
            stage.save(flush: true)
            flash.message = "Added Photo"
            redirect controller:"stage", action:"addPhotos", id: params.stageId
        }
        else if (params.mapId) {
            //Get Map
            Map map= Map.get(params.mapId)
            //photo.stage = stage
            map.photo = photo
            map.save(flush: true)
            flash.message = "Set Map Photo"
            redirect controller:"map", action:"edit", id: params.mapId
        }

        /*request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'photo.label', default: 'Photo'), photo.id])
                redirect photo
            }
            '*' { respond photo, [status: CREATED] }
        }*/
    }

    def edit(Photo photo) {
        respond photo
    }

    @Transactional
    def update(Photo photo) {
        if (photo == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (photo.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond photo.errors, view:'edit'
            return
        }

        photo.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'photo.label', default: 'Photo'), photo.id])
                redirect photo
            }
            '*'{ respond photo, [status: OK] }
        }
    }

    @Transactional
    def delete(Photo photo) {

        if (photo == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        //Find instances in Stage
        //def stage = Stage.findWhere { photos.contains(photo) }
        def stage
        Stage.list().each {
            if (it.photos.contains(photo)) {
                stage = it
                it.removeFromPhotos(photo)
            }
        }

        //photo.delete flush:true

        flash.message = message(code: 'default.deleted.message', args: [message(code: 'photo.label', default: 'Photo'), photo.filename])
        redirect controller:"stage", action:"addPhotos", id: stage.id
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'photo.label', default: 'Photo'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    @Secured(['permitAll'])
    def getPhoto() {
        def photo = Photo.get(params.id)
        render ( file: photo.photo, contentType: photo.contentType, fileName: photo.filename)

    }

    @Secured(['permitAll'])
    def getThumbnail() {
        def photo = Photo.get(params.id)
        render ( file: photo.thumbnail, contentType: photo.contentType, fileName: photo.filename)

    }

    @Secured(['permitAll'])
    def getWebPhoto() {
        def photo = Photo.get(params.id)
        render ( file: photo.webPhoto, contentType: photo.contentType, fileName: photo.filename)

    }
}
