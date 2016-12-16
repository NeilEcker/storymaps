package storymap

class Photo {

    String description
    byte [] photo
    String contentType
    String filename
    Long size

    byte [] thumbnail
    byte [] webPhoto

    static constraints = {
        description type:'text', blank:true, nullable:true
        photo maxSize: 10000000
        thumbnail maxSize: 1000000
        webPhoto maxSize: 1000000
    }
}
