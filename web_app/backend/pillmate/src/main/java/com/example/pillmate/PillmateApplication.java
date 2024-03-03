package com.example.pillmate;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.*;
import java.util.Objects;

@SpringBootApplication
public class PillmateApplication {

    public static void main(String[] args) throws IOException {
        ClassLoader classLoader = PillmateApplication.class.getClassLoader();

        InputStream serviceAccountStream = classLoader.getResourceAsStream("serviceAccountKey.json");
        if (serviceAccountStream == null) {
            throw new FileNotFoundException("serviceAccountKey.json not found in resources");
        }

        FirebaseOptions options = new FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccountStream))
                .build();

        if (FirebaseApp.getApps().isEmpty()) {
            FirebaseApp.initializeApp(options);
        }

        SpringApplication.run(PillmateApplication.class, args);
    }

}
