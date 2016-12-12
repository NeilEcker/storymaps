package storymap

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class MapController {

    MapService mapService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index() {
        respond Map.list(params)
    }

    def stages(Map map) {
        respond map
    }

    Photo getPhoto(Map map) {
        Photo photo
        def photos = []
        map.stages.each { stage ->
            stage.photos.each {
                photos << it
            }
        }
        photo = photos.size() ? photos.first() : null
    }

    def show(Map map) {
        def layers = Layer.list()
        def coordinates = mapService.getPath(map)

        respond map, model: [layers: layers, coordinates: coordinates]
    }

    def create() {
        respond new Map(params), model: [layers: Layer.list()]
    }

    @Transactional
    def save(Map map) {

        if (map == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (map.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond map.errors, view:'create'
            return
        }

        map.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'map.label', default: 'Map'), map.id])
                redirect map
            }
            '*' { respond map, [status: CREATED] }
        }
    }

    def edit(Map map) {
        respond map, model: [layers: Layer.list()]
    }

    @Transactional
    def update(Map map) {
        if (map == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        if (map.hasErrors()) {
            transactionStatus.setRollbackOnly()
            respond map.errors, view:'edit'
            return
        }

        map.save flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'map.label', default: 'Map'), map.id])
                redirect map
            }
            '*'{ respond map, [status: OK] }
        }
    }

    @Transactional
    def delete(Map map) {

        if (map == null) {
            transactionStatus.setRollbackOnly()
            notFound()
            return
        }

        map.delete flush:true

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'map.label', default: 'Map'), map.id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'map.label', default: 'Map'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
