import { FormEvent, useEffect, useState } from "react";
import PharmacyModel from "../../../models/Pharmacy";
import { getAuth } from "firebase/auth";
import _thailand from "../../../data/thailand.json";
import { District } from "../../../types/District";
import { IoIosArrowDown } from "react-icons/io";
import { ReturnProvince } from "../../SignUp/components/ReturnProvince";
import { ReturnDistrict } from "../../SignUp/components/ReturnDistrict";
import { ReturnSubdistrict } from "../../SignUp/components/ReturnSubdistrict";

export interface AddressInfoProps {
    handleStep: (value: number) => void;
    handlePharmacy: (pharmacy: PharmacyModel) => void;
}

export const EditAddress: React.FC<AddressInfoProps> = (props) => {

    const auth = getAuth();
    const [ pharmacyName, setPharmacyName ] = useState('');
    const [ addressLine1, setAddressLine1 ] = useState('');
    const [ addressLine2, setAddressLine2 ] = useState('');
    const [ subDistrict, setSubDistrict ] = useState('ตำบล/แขวง');
    const [ district, setDistrict ] = useState('อำเภอ/เขต');
    const [ province, setProvince ] = useState('จังหวัด');
    const [ zipcode, setZipcode ] = useState('');
    const [ districtList, setDistrictList ] = useState<string[]>([]);
    const [ subdistrictList, setSubdistrictList ] = useState<string[]>([]);
    const districts = _thailand as District[];
    const [email, setEmail] = useState('');
    const [httpError, setHttpError] = useState(null);
    const [ phoneNumber, setPhoneNumber ] = useState('');
    const [ date, setDate ] = useState('');
    const [ time, setTime ] = useState('');
    const [ pharID, setPharID] = useState('');
    

    useEffect(() => {
        const fetchPharmacy = async () => {
                const user = auth.currentUser;

                if(user !== null){
                    setEmail(user.email!);
                } 

                
                if(email !== ''){
                const url = `http://localhost:8080/api/pharmacy/get-pharmacy?email=${email}`;
    
                console.log(url)

                const response = await fetch(url);

                
                if(!response.ok){
                    throw new Error('Error found');
                }
    
                const responseJson = await response.json();
    

                setPharmacyName(responseJson.storeName);

                const tmp: string[] = responseJson.address.split(', ');
                const tmp2: string[] = tmp[tmp.length - 1].split(' ');
                setZipcode(tmp2[1]);
                setProvince(tmp2[0]);
                setDistrict( tmp[tmp.length - 2]);
                setSubDistrict(tmp[tmp.length - 3]);
                setAddressLine1(tmp[0]);
                setPhoneNumber(responseJson.phoneNumber);
                setDate(responseJson.serviceDate);
                setTime(responseJson.serviceTime);
                setPharID(responseJson.pharID);
                }
    };
        fetchPharmacy().catch((error: any)=> {
            setHttpError(error.message);
        });
    
}, [email]);


if(httpError){
    return(
        <div className="container m-5">
            <p>{httpError}</p>
        </div>
    )
}

const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()

    if(pharmacyName !== '' && addressLine1 !== '' && zipcode !== ''){
        // const pharmacy: PharmacyModel = new PharmacyModel("", pharmacyName, addressLine1+addressLine2+", "+subDistrict+", " + district + ", " + province + " " + zipcode, );
        const pharmacy1: PharmacyModel = new PharmacyModel();
        pharmacy1.setEmail(email);
        pharmacy1.setStoreName(pharmacyName);
        pharmacy1.setAddress(addressLine1+addressLine2+", "+subDistrict+", " + district + ", " + province + " " + zipcode);
        pharmacy1.setProvince(district);
        pharmacy1.setCity(province);
        pharmacy1.setPhoneNumber(phoneNumber);
        pharmacy1.setServiceDate(date);
        pharmacy1.setServiceTime(time);
        pharmacy1.setPharID(pharID);
        console.log(pharID);
        
        const pharmacy = await getLatLngFromGoogleAPI(pharmacy1);
        props.handlePharmacy(pharmacy);
    }

    props.handleStep(1);
};

async function getLatLngFromGoogleAPI(pharmacy: PharmacyModel)  {
    const baseUrl = `https://maps.googleapis.com/maps/api/geocode/json?address=`;
    const api = '&key=AIzaSyDBq1_J47STSxQY5RsV9X4sWHS6R2NC7gM';

    let url: string = ''

    if(pharmacy.address !== ''){
        const query = pharmacy.address.replaceAll(' ', '+');

        url = baseUrl + query + api;
    }

    const response = await fetch(url);

    if(!response.ok){
        throw new Error('Error found');
    }

    const responseJson = await response.json();

    pharmacy.setLatitude(responseJson.results[0].geometry.location.lat.toString());
    pharmacy.setLongitude(responseJson.results[0].geometry.location.lng.toString());

    return pharmacy;
}

const handleDistrict = (value: string) => {
    setDistrict(value);
    let tmpList: string[] = [];
    for(let i = 0; i < districts.length;i++){
        if(value === districts[i].amphoe && !tmpList.includes(districts[i].district!)){
            tmpList.push(districts[i].district!);
        }
    }
    setSubdistrictList(tmpList);
}

const handleSubdistrict = (value: string) => {
    setSubDistrict(value);
    for(let i = 0; i < districts.length;i++){
        if(province === districts[i].province && district === districts[i].amphoe && value === districts[i].district){
            setZipcode(districts[i].zipcode!.toString());
        }
    }
}

const handleProvince = (value: string) => {
    setProvince(value);
    let tmpList: string[] = [];
    for(let i = 0; i < districts.length;i++){
        if(value === districts[i].province && !tmpList.includes(districts[i].amphoe!)){
            tmpList.push(districts[i].amphoe!);
        }
    }
    setDistrictList(tmpList);
    console.log(districtList);
}
return(
    <div>
        <div style={{marginLeft:'4%', marginTop:'3%'}}>
            <div>
            <img src={process.env.PUBLIC_URL + '/images/Logo.png'} style={{width:'186px', height:'32px'}}/>
            </div>
            <div className='mt-5' style={{fontSize: '24px', fontFamily: "LINESeedSansTHBold"}}>
                Address Information
            </div>
            <div className='mt-3' style={{fontSize: '14px', fontFamily: "LINESeedSansTHRegular"}}>
                Please signup to continue to Pillmate
            </div>
            <div className='d-flex mt-3 gap-1'>
                <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                    <path d="M2 2H146" stroke="#059E78" stroke-width="4" stroke-linecap="round"/>
                </svg>
                <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                    <path d="M2 2H146" stroke="#059E78" stroke-width="4" stroke-linecap="round"/>
                </svg>
                <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                    <path d="M2 2H146" stroke="#D0D0D0" stroke-width="4" stroke-linecap="round"/>
                </svg>
            </div>
            <form onSubmit={handleSubmit} style={{width: '25vw'}}>
                <div className='mt-3'>
                    <label className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                        <div className='d-flex'>
                            <div style={{fontSize: '16px', color: '#000000'}}>
                                Pharmacy name
                            </div>
                        </div>
                    </label>
                    <input type="text" className="form-control"  name="pharmacyName" required onChange={e => setPharmacyName(e.target.value)} value={pharmacyName}  style={{width: '100%', height: '49px'}}/>
                </div >
                <div className='mt-3'>
                    <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                        <div className='d-flex'>
                            <div style={{fontSize: '16px', color: '#000000'}}>
                                Address Line 1
                            </div>
                        </div>
                    </label>
                    <input type="text"  className="form-control" name="address1" required onChange={e => setAddressLine1(e.target.value)} value={addressLine1}  style={{width: '100%', height: '49px'}}/>
                </div>
                <div className='mt-3'>
                    <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                        <div className='d-flex'>
                            <div style={{fontSize: '16px', color: '#000000'}}>
                                Address Line 2
                            </div>
                        </div>
                    </label>
                    <input type="text"  className="form-control" name="address2" onChange={e => setAddressLine2(e.target.value)} value={addressLine2}  style={{width: '100%', height: '49px'}}/>
                </div>
                <div className='d-flex justify-content-between'>
                    <div className='mt-3'>
                        <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    Province 
                                </div>
                            </div>
                        </label>
                        <div className='dropdown'>
                            <button className='btn' type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={{backgroundColor: 'white', width: '11vw', height:'49px', border: '1px solid #DFDFDF'}}>
                                    <div className='d-flex justify-content-between'>
                                   {province}
                                    <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                   </div>
                            </button>
                            <ReturnProvince handleProvince={handleProvince}/>
                        </div>
                    </div>
                    <div className='mt-3'>
                        <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    District
                                </div>
                            </div>
                        </label>
                        <div className='dropdown'>
                            <button className='btn' type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={{backgroundColor: 'white', width: '11vw', height:'49px', border: '1px solid #DFDFDF'}}>
                                    <div className='d-flex justify-content-between'>
                                    {district}
                                    <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                   </div>
                            </button>
                            <ReturnDistrict districts={districtList} handleDistrict={handleDistrict}/>
                        </div>
                    </div>
                </div>
                <div className='d-flex justify-content-between'>
                    <div className='mt-3'>
                        <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                     
                                    Subdistrict 
                                </div>
                            </div>
                        </label>
                        <div className='dropdown'>
                            <button className='btn' type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={{backgroundColor: 'white', width: '11vw', height:'49px', border: '1px solid #DFDFDF'}}>
                                    <div className='d-flex justify-content-between'>
                                    {subDistrict}
                                    <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                   </div>
                            </button>
                            <ReturnSubdistrict subdistricts={subdistrictList} handleSubdistrict={handleSubdistrict}/>
                        </div>
                    </div>
                    <div className='mt-3'>
                        <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    Zipcode
                                </div>
                            </div>
                        </label>
                        <input type="text"  className="form-control" name="cpassword" required onChange={e => setZipcode(e.target.value)} value={zipcode}  style={{width: '11vw', height: '49px'}}/>
                    </div>
                </div>
                <button className="btn mt-4" type="submit" style={{ width: '100%', backgroundColor: '#059E78', height: '49px'}}>
                    <div className='d-flex justify-content-center' style={{fontFamily: "LINESeedSansENBold", color: "white"}}>
                        Next
                    </div>
                </button>
            </form>
        </div>
    </div>
);
}