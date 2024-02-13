import { useState } from "react";
import PharmacyModel from "../../models/Pharmacy";
import { EditAddress } from "./components/EditAddress";
import { EditService } from "./components/EditService";

export const EditPharmacy = () => {
    const [step, setStep] = useState(0);
    const [ pharmacy, setPharmacy ] = useState<PharmacyModel>();

    const handleStep = (value: number) => {
        setStep(value);
    }

    const handlePharmacy = (value: PharmacyModel) => {
        setPharmacy(value);
    }

    return(
        <div >
            <div className="d-flex justify-content-center align-items-center" style={{width: '100vw', height: '100vh'}}>
            <div className="card shadow" style={{width: '80vw', height: '85vh', borderRadius: '0px'}}>
                <div>
                    <div className="d-flex justify-content-between" >
                        <div  style={{marginLeft: '7%', marginTop:'2.5%'}}>
                            {step == 0 ? <EditAddress handlePharmacy={handlePharmacy} handleStep={handleStep} />: <EditService pharmacy={pharmacy} />}
                        </div>
                        <div style={{ overflow: 'hidden'}} >
                            <img src={process.env.PUBLIC_URL + '/images/Right.png'} style={{width: '45VW', height: '84.8vh', objectFit: 'cover'}}/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </div>
    );
}