package storymap

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

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
                flash.message = message(code: 'default.created.message', args: [message(code: 'stage.label', default: 'Stage'), stage.id])
                redirect stage
            }
            '*' { respond stage, [status: CREATED] }
        }
    }

    def edit(Stage stage) {
        respond stage, model: [layers: Layer.list()]
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
                flash.message = message(code: 'default.updated.message', args: [message(code: 'stage.label', default: 'Stage'), stage.id])
                redirect stage
            }
            '*'{ respond stage, [status: OK] }
        }
    }

    @Transactional
    def delete(Stage stage) {

        if (stage == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        stage.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'stage.label', default: 'Stage'), stage.id])
                redirect action:"index", method:"GET"
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
