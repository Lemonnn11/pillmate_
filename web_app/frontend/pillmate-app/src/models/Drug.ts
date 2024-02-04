class DrugModel {
    id: string;
    tradeName: string;
    genericName: string;
    dosageForm: string;
    category: string;
    protectedFromLight: boolean; 
    imgSource: string; 

    constructor(id: string, tradeName: string, genericName: string, dosageForm: string, category: string, protectedFromLight: boolean, imgSource: string) {
        this.id = id;
        this.tradeName = tradeName;
        this.genericName = genericName;
        this.dosageForm = dosageForm;
        this.category = category;
        this.protectedFromLight = protectedFromLight;
        this.imgSource = imgSource;
    }
}

export default DrugModel;
