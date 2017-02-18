package storymap

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: 'map', action: 'index')
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
