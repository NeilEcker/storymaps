package storymap

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class LayerController {

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond Layer.list(params), model:[layerCount: Layer.count()]
    }

    def show(Layer layer) {
        respond layer
    }

    def create() {
        respond new Layer(params)
    }

    @Transactional
    def save(Layer layer) {
        if (layer == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (layer.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond layer.errors, view:'create'
            return
        }

        layer.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'layer.label', default: 'Layer'), layer.id])
                redirect layer
            }
            '*' { respond layer, [status: CREATED] }
        }
    }

    def edit(Layer layer) {
        respond layer
    }

    @Transactional
    def update(Layer layer) {
        if (layer == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (layer.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond layer.errors, view:'edit'
            return
        }

        layer.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'layer.label', default: 'Layer'), layer.id])
                redirect layer
            }
            '*'{ respond layer, [status: OK] }
        }
    }

    @Transactional
    def delete(Layer layer) {

        if (layer == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        layer.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'layer.label', default: 'Layer'), layer.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'layer.label', default: 'Layer'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
