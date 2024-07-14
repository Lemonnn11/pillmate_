package com.example.pillmate.repository;

import com.example.pillmate.model.Pharmacy;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Repository;

import java.util.*;
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

    public String updatePharmacy(Pharmacy pharmacy) throws ExecutionException, InterruptedException{
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection("pharmacies").document(pharmacy.getPharID());

        Map<String, Object> updatedData = new HashMap<>();
        updatedData.put("address", pharmacy.getAddress());
        updatedData.put("city", pharmacy.getCity());
        updatedData.put("latitude", pharmacy.getLatitude());
        updatedData.put("longitude", pharmacy.getLongitude());
        updatedData.put("phoneNumber", pharmacy.getPhoneNumber());
        updatedData.put("province", pharmacy.getProvince());
        updatedData.put("serviceDate", pharmacy.getServiceDate());
        updatedData.put("serviceTime", pharmacy.getServiceTime());
        updatedData.put("storeName", pharmacy.getStoreName());
        updatedData.put("email", pharmacy.getEmail());

        ApiFuture<WriteResult> future = docRef.update(updatedData);
        return future.get().getUpdateTime().toString();
    }

    public Pharmacy getPharmacyByAccount(String email) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        List<Pharmacy> pharmacies = new ArrayList<>();
        CollectionReference  docRef  = db.collection("pharmacies");
        Query query = docRef.whereEqualTo("email", email);
        ApiFuture<QuerySnapshot> future = query.get();
        List<QueryDocumentSnapshot> documents = future.get().getDocuments();
        return new Pharmacy(
                documents.get(0).getString("pharID"),
                documents.get(0).getString("storeName"),
                documents.get(0).getString("address"),
                documents.get(0).getString("latitude"),
                documents.get(0).getString("longitude"),
                documents.get(0).getString("phoneNumber"),
                documents.get(0).getString("serviceTime"),
                documents.get(0).getString("serviceDate"),
                documents.get(0).getString("province"),
                documents.get(0).getString("city"),
                documents.get(0).getString("email")
        );
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
