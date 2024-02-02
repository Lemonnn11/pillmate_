package com.example.pillmate.repository;

import com.example.pillmate.model.Pharmacy;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
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

    public List<Pharmacy> getAllPharmacies() throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        List<Pharmacy> pharmacies = new ArrayList<>();
        ApiFuture<QuerySnapshot> future = db.collection("pharmacies").get();
        List<QueryDocumentSnapshot> documents = future.get().getDocuments();
        for(QueryDocumentSnapshot doc: documents){
            pharmacies.add(doc.toObject(Pharmacy.class));
        }
        return pharmacies;
    }

    public void deletePharmacy(String id){
        Firestore db = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> writeResult = db.collection("pharmacies").document(id).delete();
    }

}
