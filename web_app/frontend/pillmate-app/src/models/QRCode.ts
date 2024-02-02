class QRCodeModel {
    qrCodeID: string;
    pharID: string;
    dosagePerTake: number;
    timePerDay: number;
    timeOfMed: string;
    timePeriodForMed: string;
    takeMedWhen: string;
    expiredDate: string;
    date: string;
    conditionOfUse : string;
    additionalAdvice: string;
    amountOfMeds: number;
    quantity: number;
    adverseDrugReaction: string;
    typeOfMedicine: string;
    genericName: string;
    tradeName: string;
    constructor(
        qrCodeID: string,
        pharID: string,
        dosagePerTake: number,
        timePerDay: number,
        timeOfMed: string,
        timePeriodForMed: string,
        takeMedWhen: string,
        expiredDate: string,
        date: string,
        conditionOfUse: string,
        additionalAdvice: string,
        amountOfMeds: number,
        quantity: number,
        adverseDrugReaction: string,
        typeOfMedicine: string,
        genericName: string,
        tradeName: string
    ) {
        this.qrCodeID = qrCodeID;
        this.pharID = pharID;
        this.dosagePerTake = dosagePerTake;
        this.timePerDay = timePerDay;
        this.timeOfMed = timeOfMed;
        this.timePeriodForMed = timePeriodForMed;
        this.takeMedWhen = takeMedWhen;
        this.expiredDate = expiredDate;
        this.date = date;
        this.conditionOfUse = conditionOfUse;
        this.additionalAdvice = additionalAdvice;
        this.amountOfMeds = amountOfMeds;
        this.quantity = quantity;
        this.adverseDrugReaction = adverseDrugReaction;
        this.typeOfMedicine = typeOfMedicine;
        this.genericName = genericName;
        this.tradeName = tradeName;
    }
}

export default QRCodeModel;