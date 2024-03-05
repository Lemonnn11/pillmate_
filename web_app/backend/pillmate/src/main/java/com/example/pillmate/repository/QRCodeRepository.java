package com.example.pillmate.repository;

import com.example.pillmate.PillmateApplication;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import org.springframework.stereotype.Repository;
import com.google.cloud.storage.*;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;

import java.nio.file.Path;
import java.nio.file.Paths;

@Repository
public class QRCodeRepository {

    public void saveQRCode(BitMatrix matrix, String id) throws IOException {
//        String currentWorkingDirectory = System.getProperty("user.dir");
//        Path currentPath = Paths.get(currentWorkingDirectory);
//        Path newPath = currentPath.getParent().getParent();
//        System.out.println("Current Project Path: " + newPath);
//
//        String path = newPath+ "\\frontend\\pillmate-app\\public\\images\\" + id +".png";
//        System.out.println("Absolute Path: " + new File(path).getAbsolutePath());
//        MatrixToImageWriter.writeToFile(matrix, path.substring(path.lastIndexOf('.') + 1), new File(path));
        try {

            BufferedImage image = MatrixToImageWriter.toBufferedImage(matrix);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "png", baos);
            byte[] imageData = baos.toByteArray();

            ClassLoader classLoader = PillmateApplication.class.getClassLoader();
            InputStream serviceAccountStream = classLoader.getResourceAsStream("serviceAccountKey.json");
            if (serviceAccountStream == null) {
                throw new FileNotFoundException("serviceAccountKey.json not found in resources");
            }
            GoogleCredentials credentials = GoogleCredentials.fromStream(serviceAccountStream);
            Storage storage = StorageOptions.newBuilder().setCredentials(credentials).setProjectId("pillmate-18ac0").build().getService();

            String bucketName = "pillmate-18ac0.appspot.com";

            BlobId blobId = BlobId.of(bucketName, id+ ".png");
            BlobInfo blobInfo = BlobInfo.newBuilder(blobId).build();
            Blob blob = storage.create(blobInfo, imageData);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

}
