package storymap

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Transactional(readOnly = true)
class MapController {

    MapService mapService

    static allowedMethods = [save: "POST", saveStageOrder: "POST", update: "PUT", delete: "DELETE"]

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
        def coordinates = mapService.getCoordinates(map)
        def titles = mapService.getTitles(map)

        respond map, model: [layers: layers, coordinates: coordinates, titles: titles]
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

    @Transactional
    def saveStageOrder() {
        def order = Eval.me(params.order)
        order.eachWithIndex { stageId, idx ->
            def stage = Stage.get(stageId)
            stage.sortOrder = idx
            stage.save(failOnError: true)
        }
        render "Order Saved"
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
