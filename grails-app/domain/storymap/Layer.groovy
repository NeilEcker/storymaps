package storymap

class Layer {

    String name
    String type
    String url
    String layer
    Boolean tiled
    String format
    Integer maxZoom
    Integer minZoom

    static constraints = {
        type inList:['Tile','WMS']
        layer blank: true, nullable:true
        format blank:true, nullable:true
        maxZoom blank:true, nullable:true
        minZoom blank:true, nullable:true
    }

    String toString() { layer }
}
