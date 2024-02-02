class DrugModel {
    tradeName: string;
    genericName: string;
    containers: string;
    dosageForm: string;
    category: string;

    constructor(tradeName: string, genericName: string, containers: string, dosageForm: string, category: string) {
        this.tradeName = tradeName;
        this.genericName = genericName;
        this.containers = containers;
        this.dosageForm = dosageForm;
        this.category = category
    }
}

export default DrugModel;
