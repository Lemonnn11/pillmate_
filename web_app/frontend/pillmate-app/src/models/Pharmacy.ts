class PharmacyModel {
    pharID: string;
    storeName: string;
    address: string;
    province: string;
    city: string;
    latitude: string;
    longitude: string;
    phoneNumber: string;
    serviceTime: string;
    serviceDate: string;
    email: string;

    constructor() {
        this.pharID = '';
        this.storeName = '';
        this.address = '';
        this.province = '';
        this.city = '';
        this.latitude = '';
        this.longitude = '';
        this.phoneNumber = '';
        this.serviceTime = '';
        this.serviceDate = '';
        this.email ='';
    }

    setPharID(value: string){
        this.pharID = value;
    }

    setStoreName(value: string) {
        this.storeName = value;
    }

    setAddress(value: string) {
        this.address = value;
    }

    setProvince(value: string) {
        this.province = value;
    }

    setCity(value: string) {
        this.city = value;
    }

    setLatitude(value: string) {
        this.latitude = value;
    }

    setLongitude(value: string) {
        this.longitude = value;
    }

    setPhoneNumber(value: string) {
        this.phoneNumber = value;
    }

    setServiceTime(value: string) {
        this.serviceTime = value;
    }

    setServiceDate(value: string) {
        this.serviceDate = value;
    }

    setEmail(value:string){
        this.email = value;
    }
}

export default PharmacyModel;
