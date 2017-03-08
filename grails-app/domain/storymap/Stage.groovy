package storymap

class Stage {

    String title
    String content

    Float latitude
    Float longitude
    Integer zoom
    Layer layer

    Integer sortOrder

    static belongsTo = [map: Map]
    static hasMany = [photos: Photo]

    static constraints = {
        content type: 'text', nullable: true
        layer blank:true, nullable:true
    }

    String toString() { title }
}
