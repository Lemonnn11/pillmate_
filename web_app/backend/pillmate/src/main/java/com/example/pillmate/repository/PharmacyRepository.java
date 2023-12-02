package com.example.pillmate.repository;

import com.example.pillmate.model.Pharmacy;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Repository;

import java.util.concurrent.ExecutionException;

@Repository
public class PharmacyRepository {

    public String createPharmacy(Pharmacy pharmacy) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        ApiFuture<DocumentReference> addedDocRef = db.collection("pharmacies").add(pharmacy);
        DocumentReference docRef = db.collection("pharmacies").document(addedDocRef.get().getId());
        ApiFuture<WriteResult> future = docRef.update("pharID", addedDocRef.get().getId());
        return addedDocRef.get().getId();
    }

}
