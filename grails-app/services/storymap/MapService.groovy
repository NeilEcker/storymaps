package storymap

import grails.transaction.Transactional

@Transactional
class MapService {

    def getPath(Map map) {

        def coordinates = []

        map.stages.sort{ it.sortOrder }.each { stage ->
            coordinates << [stage.latitude, stage.longitude]
        }

        return coordinates
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
