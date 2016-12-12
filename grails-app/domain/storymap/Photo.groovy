package storymap

class Photo {

    byte [] photo
    String contentType
    String filename
    Long size

    byte [] thumbnail
    byte [] webPhoto

    static constraints = {
        photo maxSize: 10000000
        thumbnail maxSize: 1000000
        webPhoto maxSize: 1000000
    }
}
