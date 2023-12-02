package com.example.pillmate.repository;

import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import org.springframework.stereotype.Repository;

import java.io.File;
import java.io.IOException;

@Repository
public class QRCodeRepository {

    public void saveQRCode(BitMatrix matrix, String id) throws IOException {
        String path = "C:\\src\\" + id +".png";
        MatrixToImageWriter.writeToFile(matrix, path.substring(path.lastIndexOf('.') + 1), new File(path));
    }

}
