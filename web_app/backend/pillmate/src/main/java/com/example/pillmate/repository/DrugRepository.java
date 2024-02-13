package com.example.pillmate.repository;

import com.example.pillmate.model.Drug;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Repository;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;
import java.io.File;

@Repository
public class DrugRepository {

    public List<Drug> getAllDrugs() {
        File file = new File("C:\\Users\\USER\\Downloads\\drug_data.xlsx");   //creating a new file instance

//        ClassLoader classLoader = DrugRepository.class.getClassLoader();

//        File file = new File(Objects.requireNonNull(classLoader.getResource("drug_data.xlsx")).getFile());

        try{
            FileInputStream fis = new FileInputStream(file);
//            FileInputStream mediletData =
//                    new FileInputStream(file.getAbsolutePath());

            XSSFWorkbook wb = new XSSFWorkbook(fis);
            XSSFSheet sheet = wb.getSheetAt(0);
            Iterator<Row> itr = sheet.iterator();

            List<Drug> list = new ArrayList<Drug>();
            int count = 0;
            while (itr.hasNext()){
                Row row = itr.next();
                Iterator<Cell> cellIterator = row.cellIterator();
                int cellNum = 0;
                Drug drug = new Drug();
                while (cellIterator.hasNext()){
                    Cell cell = cellIterator.next();
                    switch (cellNum) {
                        case 0 ->
                        {
                            if (cell.getCellType() == CellType.BOOLEAN) {
                                drug.setId(String.valueOf(cell.getBooleanCellValue()));
                            } else if (cell.getCellType() == CellType.NUMERIC) {
                                drug.setId(String.valueOf(cell.getNumericCellValue()));
                            } else {
                                drug.setId(cell.getStringCellValue());
                            }
                        }
                        case 1 ->
                        {
                            if (cell.getCellType() == CellType.BOOLEAN) {
                                drug.setTradeName(String.valueOf(cell.getBooleanCellValue()));
                            } else if (cell.getCellType() == CellType.NUMERIC) {
                                drug.setTradeName(String.valueOf(cell.getNumericCellValue()));
                            } else {
                                drug.setTradeName(cell.getStringCellValue());
                            }
                        }
                        case 2 ->
                        {
                            if (cell.getCellType() == CellType.BOOLEAN) {
                                drug.setGenericName(String.valueOf(cell.getBooleanCellValue()));
                            } else if (cell.getCellType() == CellType.NUMERIC) {
                                drug.setGenericName(String.valueOf(cell.getNumericCellValue()));
                            } else {
                                drug.setGenericName(cell.getStringCellValue());
                            }
                        }
                        case 3 ->
                        {
                            if (cell.getCellType() == CellType.BOOLEAN) {
                                drug.setDosageForm(String.valueOf(cell.getBooleanCellValue()));
                            } else if (cell.getCellType() == CellType.NUMERIC) {
                                drug.setDosageForm(String.valueOf(cell.getNumericCellValue()));
                            } else {
                                drug.setDosageForm(cell.getStringCellValue());
                            }
                        }
                        case 4 -> {
                            if (cell.getCellType() == CellType.BOOLEAN) {
                                drug.setCategory(String.valueOf(cell.getBooleanCellValue()));
                            } else if (cell.getCellType() == CellType.NUMERIC) {
                                drug.setCategory(String.valueOf(cell.getNumericCellValue()));
                            } else {
                                drug.setCategory(cell.getStringCellValue());
                            }
                        }
                        case 5 -> {
                            if (cell.getCellType() == CellType.BOOLEAN) {
                                drug.setProtectedFromLight(String.valueOf(cell.getBooleanCellValue()));
                            } else if (cell.getCellType() == CellType.NUMERIC) {
                                drug.setProtectedFromLight(String.valueOf(cell.getNumericCellValue()));
                            } else {
                                drug.setProtectedFromLight(cell.getStringCellValue());
                            }
                        }
                        case 6 ->
                        {
                            if (cell.getCellType() == CellType.BOOLEAN) {
                                drug.setImgSource(String.valueOf(cell.getBooleanCellValue()));
                            } else if (cell.getCellType() == CellType.NUMERIC) {
                                drug.setImgSource(String.valueOf(cell.getNumericCellValue()));
                            } else {
                                drug.setImgSource(cell.getStringCellValue());
                            }
                        }
                    }
                    cellNum += 1;
                }
                list.add(drug);
            }

//            for(Row row: sheet){
//                int cellNum = 0;
//                Drug drug = new Drug();
//                for(Cell cell: row){
//                    switch(cellNum){
//                        case 0: drug.setId(cell.getStringCellValue()); break;
//                        case 1: drug.setTradeName(cell.getStringCellValue()); break;
//                        case 2: drug.setGenericName(cell.getStringCellValue()); break;
//                        case 3: drug.setDosageForm(cell.getStringCellValue()); break;
//                        case 4: drug.setCategory(cell.getStringCellValue()); break;
//                        case 5: drug.setProtectedFromLight(cell.getStringCellValue()); break;
//                        case 6: drug.setImgSource(cell.getStringCellValue()); break;
//                    }
//                    cellNum += 1;
//                }
//                list.add(drug);
//            }
            list.remove(0);
            return list;
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<String> getCategories() {
        List<Drug> drugs = this.getAllDrugs();
        List<String> categories = new ArrayList<>();
        for (Drug drug:drugs){
            drug.setCategory(drug.getCategory().toLowerCase());
            if(drug.getCategory().contains(", ") || drug.getCategory().contains(",")){
                String[] tmp = {};
                if(drug.getCategory().contains(", ")){
                    tmp = drug.getCategory().split(", ");
                }else{
                    tmp = drug.getCategory().split(",");
                }
                for(String i: tmp){
                    if(i.contains(",")){
                        String[] tmpp = i.split(",");
                        for(String j: tmpp){
                            if(!categories.contains(j) && !j.equals("")){
                                categories.add(j);
                            }
                        }
                    }
                    else if(!categories.contains(i) && !i.equals("")){
                        categories.add(i);
                    }
                }
            }else{
                if(!categories.contains(drug.getCategory()) && !drug.getCategory().equals("")){
                    categories.add(drug.getCategory());
                }
            }
        }
        Collections.sort(categories);
        return categories;
    }

}
