package com.example.pillmate.integration;

import com.example.pillmate.PillmateApplication;
import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.repository.PharmacyRepository;
import com.example.pillmate.service.PharmacyService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Objects;
import java.util.concurrent.ExecutionException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class CreatePharmacyIntegrationTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private PharmacyRepository pharmacyRepository;

    @Autowired
    private PharmacyService pharmacyService;

    private static HttpHeaders headers;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @BeforeAll
    public static void init() throws IOException {
        headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        ClassLoader classLoader = PillmateApplication.class.getClassLoader();

        File file = new File(Objects.requireNonNull(classLoader.getResource("serviceAccountKey.json")).getFile());

        FileInputStream serviceAccount =
                new FileInputStream(file.getAbsolutePath());

        FirebaseOptions options = null;
        try {
            options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        FirebaseApp.initializeApp(options); // initialize app with these options to authorize to use Firebase pj(connect)

    }

    @Test
    public void testCreatePharmacy() throws JsonProcessingException, ExecutionException, InterruptedException {
        Pharmacy pharmacy = new Pharmacy(
                "",
                "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                "13.77765254802144",
                "100.52532826905029",
                "0968123561",
                "8:00 - 17:00",
                "Mon - Sun",
                "ราชเทวี",
                "กรุงเทพมหานคร",
                "lemonn123@gmail.com"
        );

        HttpEntity<String> entity = new HttpEntity<>(objectMapper.writeValueAsString(pharmacy), headers);

        ResponseEntity<Pharmacy> response = restTemplate.exchange("http://localhost:" + port + "/api/pharmacy/create", HttpMethod.POST, entity, Pharmacy.class);


        assertEquals(response.getStatusCodeValue(), 201);

    }

}
