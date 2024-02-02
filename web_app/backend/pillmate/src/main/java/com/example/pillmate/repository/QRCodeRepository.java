package com.example.pillmate.repository;

import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import org.springframework.stereotype.Repository;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;

@Repository
public class QRCodeRepository {

    public void saveQRCode(BitMatrix matrix, String id) throws IOException {
        String currentWorkingDirectory = System.getProperty("user.dir");
        Path currentPath = Paths.get(currentWorkingDirectory);
        Path newPath = currentPath.getParent().getParent();
        System.out.println("Current Project Path: " + newPath);

        String path = newPath+ "\\frontend\\pillmate-app\\public\\images\\" + id +".png";
        System.out.println("Absolute Path: " + new File(path).getAbsolutePath());
        MatrixToImageWriter.writeToFile(matrix, path.substring(path.lastIndexOf('.') + 1), new File(path));
    }

}
