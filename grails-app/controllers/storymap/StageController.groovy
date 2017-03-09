package storymap

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
@Transactional(readOnly = true)
class StageController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Stage.list(params), model:[stageCount: Stage.count()]
    }

    def show(Stage stage) {
        respond stage
    }

    def addPhotos(Stage stage) {
        respond stage
    }

    def create() {
        def map = Map.get(params.mapId)
        respond new Stage(params), model: [layers: Layer.list(), map: map]
    }

    @Transactional
    def save(Stage stage) {
        if (stage == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (stage.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond stage.errors, view:'create'
            return
        }

        stage.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'stage.label', default: 'Stage'), stage.title])
                redirect stage
            }
            '*' { respond stage, [status: CREATED] }
        }
    }

    @Transactional
    def setMapPhoto(Stage stage) {
        if (params.photoId) {
            def map = stage.map
            map.photoId = params.int('photoId')
            map.save(flush: true)
        }

        flash.message = "Set Default Map Photo"
        //redirect action: "addPhotos", id: stage.id
        redirect action:"edit", id: stage.id, params: [tab: "photos"]
    }

    def edit(Stage stage) {
        respond stage, model: [layers: Layer.list(), tab: params.tab]
    }

    @Transactional
    def update(Stage stage) {
        if (stage == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (stage.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond stage.errors, view:'edit'
            return
        }

        stage.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = "${stage.title} Updated"
                //redirect stage
                redirect controller:"stage", action:"edit", id: stage.id, params: [tab: params.currentTab]
            }
            '*'{ respond stage, [status: OK] }
        }
    }

    @Transactional
    def delete(Stage stage) {

        Map map = stage.map

        if (stage == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        stage.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'stage.label', default: 'Stage'), stage.title])
                //redirect action:"index", method:"GET"
                redirect controller:"map", action:"stages", id:map.id
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'stage.label', default: 'Stage'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
