package com.example.pillmate.unit.service;

import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.service.PharmacyService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;
import org.mockito.Mock;

import java.util.concurrent.ExecutionException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

@SpringBootTest
public class PharmacyServiceTest {

    @Mock
    private PharmacyService pharmacyServiceMock;

    @Nested
    class TestAddPharmacy {

        @Test
        public void testServiceReturnTrue() throws ExecutionException, InterruptedException {
            Pharmacy pharmacy = new Pharmacy(
                    "",
                    "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                    "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                    "ราชเทวี",
                    "กรุงเทพมหานคร",
                    "13.77765254802144",
                    "100.52532826905029",
                    "0968123561",
                    "8:00 - 17:00",
                    "Mon - Fri"
            );

            when(pharmacyServiceMock.addPharmacy(pharmacy)).thenReturn("59THxHDqc5i6tBIKWQ5p");

            assertEquals("59THxHDqc5i6tBIKWQ5p", pharmacyServiceMock.addPharmacy(pharmacy));
        }

        @Test
        public void testServiceReturnFalse() throws ExecutionException, InterruptedException {
            Pharmacy pharmacy = null;
            when(pharmacyServiceMock.addPharmacy(pharmacy)).thenReturn(null);

            assertEquals(null, pharmacyServiceMock.addPharmacy(pharmacy));
        }

        @Test
        public void testServiceThrowsException() throws ExecutionException, InterruptedException {
            Pharmacy pharmacy = new Pharmacy(
                    "",
                    "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                    "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                    "ราชเทวี",
                    "กรุงเทพมหานคร",
                    "13.77765254802144",
                    "100.52532826905029",
                    "0968123561",
                    "8:00 - 17:00",
                    "Mon - Fri"
            );

            when(pharmacyServiceMock.addPharmacy(pharmacy)).thenThrow(InterruptedException.class);

            assertThrows(InterruptedException.class, () -> {
               pharmacyServiceMock.addPharmacy(pharmacy);
            });
        }

        @AfterEach
        public void teardown() {
            Mockito.reset(pharmacyServiceMock);
        }
    }
}
