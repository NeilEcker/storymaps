package storymap

import org.apache.tomcat.util.http.fileupload.ByteArrayOutputStream
import org.imgscalr.Scalr
import javax.imageio.ImageIO
import java.awt.image.BufferedImage

import grails.transaction.Transactional

@Transactional
class ThumbnailService {

    def createThumbnail(byte[] imageBytes, String format) {
        resizeImage(imageBytes, format, 240, 160)
    }

    def createWebPhoto(byte[] imageBytes, String format) {
        resizeImage(imageBytes, format, 1600, 1200)
    }

    def resizeImage(byte[] imageBytes, String format, Integer targetWidth, Integer targetHeight) {
        String imageFormat = format

        InputStream input = new ByteArrayInputStream(imageBytes);
        BufferedImage image = ImageIO.read(input);

        BufferedImage scaledImg = Scalr.resize(image, Scalr.Method.QUALITY, Scalr.Mode.FIT_TO_WIDTH,
                targetWidth, targetHeight, Scalr.OP_ANTIALIAS)

        ByteArrayOutputStream baos = new ByteArrayOutputStream()
        ImageIO.write(scaledImg, imageFormat, baos)
        baos.flush()
        byte[] scaledImageInByte = baos.toByteArray()
        baos.close()
        return scaledImageInByte
    }

}
