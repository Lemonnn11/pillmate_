import { useState } from "react";
import { CreateAccount } from "./components/CreateAccount";
import { AddressInfo } from "./components/AddressInfo";
import { PharmacyInfo } from "./components/PharmacyInfo";
import PharmacyModel from "../../models/Pharmacy";

export const SignUp = () => {

    const [step, setStep] = useState(0);
    const [ pharmacy, setPharmacy ] = useState<PharmacyModel>();

    const handleStep = (value: number) => {
        setStep(value);
    }

    const handlePharmacy = (value: PharmacyModel) => {
        setPharmacy(value);
    }

    return(
        <div className="d-flex">
            <div className="d-flex">
                {step == 0 ? <CreateAccount handleStep={handleStep} />: step == 1 ? <AddressInfo handlePharmacy={handlePharmacy} handleStep={handleStep}/>: <PharmacyInfo pharmacy={pharmacy}/>}
                <div >
                    <img src={process.env.PUBLIC_URL + '/images/Right.png'} style={{width: '70VW', height: '100vh'}}/>
                </div>
            </div>
        </div>
    );
}