package storymap

import grails.transaction.Transactional

@Transactional
class MapService {

    def springSecurityService

    def canView(Map map) {
        map.creator == springSecurityService.currentUser || map.isPublic == true
    }

    def canEdit(Map map) {
        map.creator == springSecurityService.currentUser
    }

    def getCoordinates(Map map) {

        def coordinates = []

        map.stages.sort{ it.sortOrder }.each { stage ->
            coordinates << [stage.latitude, stage.longitude]
        }

        return coordinates
    }

    def getTitles(Map map) {

        //def titles = []

        def titles = map.stages.sort{ it.sortOrder }.collect { stage ->
            stage.title.replaceAll('\\s','')
        }.join(',')

        return titles
    }

    Photo getPhoto(Map map) {

        if (map.photoId) {
            Photo.get(map.photoId)
        } else {
            //Try to pick one from stages
            map.stages.each { stage ->
                if (stage.photos) {
                    return stage.photos.first()
                }
            }
        }
    }
}
