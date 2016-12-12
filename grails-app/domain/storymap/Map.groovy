package storymap

class Map {

    String title
    String overview

    Layer layer
    Integer photoId

    static hasMany = [stages: Stage]

    static constraints = {
        overview type: 'text', nullable:true
        layer blank:true, nullable:true
        photoId blank:true, nullable: true
    }

    String toString() { title }
}
