package storymap

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional
import grails.plugin.springsecurity.annotation.Secured

@Secured(['ROLE_USER'])
@Transactional(readOnly = true)
class MapController {

    MapService mapService
    def springSecurityService

    static allowedMethods = [save: "POST", saveStageOrder: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['permitAll'])
    def index() {
        def mapList = Map.where {
            isPublic == true || creator == springSecurityService.currentUser
        }

        model: [mapList: mapList]
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

    @Secured(['permitAll'])
    def show(Map map) {

        if (mapService.canView(map)) {
            def layers = Layer.list()
            def coordinates = mapService.getCoordinates(map)
            def titles = mapService.getTitles(map)

            def isCreator = mapService.canEdit(map)

            respond map, model: [layers: layers, coordinates: coordinates, titles: titles, isCreator: isCreator]
        } else {
            flash.message = "Map does not exist or you do not have permission to view."
            redirect action: "index"
        }

    }

    def create() {
        respond new Map(params), model: [layers: Layer.list()]
    }

    def createStage(Map map) {
        new Stage(title: "Untitled Stage", latitude: 0, longitude: 0, zoom: 4, sortOrder: 1, content: 'Enter content here', map: map).save(failOnError: true)
        redirect action: 'stages', id: map.id
    }

    @Transactional
    def save(Map map) {

        //map.creator = springSecurityService.authentication.principal
        map.creator = springSecurityService.currentUser

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
        if (mapService.canEdit(map)) {
            respond map, model: [layers: Layer.list()]
        } else {
            flash.message = "Map does not exist or you do not have permission to edit."
            redirect action: "index"
        }
    }

    @Transactional
    def update(Map map) {

        if (mapService.canEdit(map)) {
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
        } else {
            flash.message = "Map does not exist or you do not have permission to edit."
            redirect action: "index"
        }

    }

    @Transactional
    def delete(Map map) {

        if (mapService.canEdit(map)) {

            if (map == null) {
                transactionStatus.setRollbackOnly()
                notFound()
                return
            }

            map.delete flush: true

            request.withFormat {
                form multipartForm {
                    flash.message = message(code: 'default.deleted.message', args: [message(code: 'map.label', default: 'Map'), map.id])
                    redirect action: "index", method: "GET"
                }
                '*' { render status: NO_CONTENT }
            }
        } else {
            flash.message = "Map does not exist or you do not have permission to edit."
            redirect action: "index"
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
