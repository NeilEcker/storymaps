package storymap

class BootStrap {

    def init = { servletContext ->

        if (Role.list().size == 0) { createRoles() }

        if (Map.list().size == 0) {
            addDefaultLayers()
            addDemoData()
        }
    }

    def createRoles() {
        def adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
        def userRole = new Role(authority: 'ROLE_USER').save(flush: true)
    }

    def addDemoData() {
        def demoUser = new UserAccount(username: "demouser@storymaps.zapto.org", password: "sw!ssCh33se", enabled: true).save(flush:true)

        String testContent = '''
            <p>Etiam nec vulputate tellus. Mauris varius aliquam congue. Etiam ac dolor sed felis pellentesque iaculis. In hac habitasse platea dictumst. Vivamus bibendum, nisi id tempor fringilla, augue velit posuere eros, vel mollis massa nisl eget mi. In sit amet libero quis ipsum bibendum pulvinar. In hac habitasse platea dictumst. Vestibulum congue justo erat, a vulputate nibh aliquet vitae. Morbi accumsan lobortis diam, ut aliquet est venenatis sit amet.</p>
            <p>Vestibulum eleifend varius nisi vitae mattis. Proin egestas diam eu justo porta feugiat. Phasellus nec nisl congue elit mattis facilisis. Sed semper lorem in elementum facilisis. Mauris malesuada at felis sit amet commodo. Cras egestas nec metus nec aliquet. Suspendisse at feugiat elit, at tincidunt odio. Etiam ac magna justo. Nunc eget congue augue. Mauris eget arcu non purus rutrum accumsan vitae condimentum ligula. Sed blandit interdum neque, in adipiscing ligula placerat vel.</p>
            <p>In at molestie nulla, at molestie nulla. Donec ut vehicula velit, sed scelerisque sapien. Proin sodales laoreet dapibus. Phasellus in tristique orci. Morbi iaculis vestibulum magna, et fermentum lacus ornare non. Quisque malesuada et dolor ac mollis. Duis egestas ullamcorper dui, vel rhoncus nisl congue ut. Nunc feugiat velit at congue congue. Suspendisse sapien ligula, gravida non rhoncus ut, porta ut ipsum. In urna orci, scelerisque non sem et, condimentum feugiat lorem. Nam nec nunc nisl.</p>
        '''

        def map1 = new Map(title: "Demo Map", overview: testContent, isPublic: true, creator: demoUser).save(failOnError: true)
        new Stage(title: "First Stage", latitude: 44, longitude: -80.5, zoom: 12, content: testContent, sortOrder: 1, map: map1).save(failOnError: true)
        new Stage(title: "Second Stage", latitude: 44.2, longitude: -80.8, zoom: 12, content: testContent, sortOrder: 2, map: map1).save(failOnError: true)
        new Stage(title: "Third Stage", latitude: 44.5, longitude: -81, zoom: 12, content: testContent, sortOrder: 3, map: map1).save(failOnError: true)
        new Stage(title: "Fourth Stage", latitude: 44.7, longitude: -81.1, zoom: 12, content: testContent, sortOrder: 4, map: map1).save(failOnError: true)
    }

    def addDefaultLayers() {
        new Layer(name: "OpenStreetMap", type: 'Tile', url: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                maxZoom: 19, minZoom: 4, format: "image/png", tiled: true,
                attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
        ).save(failOnError: true)

        new Layer(name: "OSM HOT", type: 'Tile', url: "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                maxZoom: 19, minZoom: 4, format: "image/png", tiled: true,
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        ).save(failOnError: true)

        new Layer(name: "OSM Black and White", type: 'Tile', url: "https://{s}.tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png",
                maxZoom: 19, minZoom: 4, format: "image/png", tiled: true,
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        ).save(failOnError: true)

        new Layer(name: "Stamen Watercolor", type: 'Tile', url: "https://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.png",
                maxZoom: 16, minZoom: 1, format: "image/png", tiled: true,
                attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        ).save(failOnError: true)

        new Layer(name: "ESRI World Imagery", type: 'Tile', url: "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
                maxZoom: 16, minZoom: 1, format: "image/png", tiled: true,
                attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS UserAccount Community'
        ).save(failOnError: true)

        new Layer(name: "ESRI National Geographic", type: 'Tile', url: "https://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}",
                maxZoom: 16, minZoom: 1, format: "image/png", tiled: true,
                attribution: 'Tiles &copy; Esri &mdash; National Geographic, Esri, DeLorme, NAVTEQ, UNEP-WCMC, USGS, NASA, ESA, METI, NRCAN, GEBCO, NOAA, iPC'
        ).save(failOnError: true)

        String name
        String type
        String url
        String layer
        Boolean tiled
        String format
        Integer maxZoom
        Integer minZoom
    }

    def destroy = {
    }
}
