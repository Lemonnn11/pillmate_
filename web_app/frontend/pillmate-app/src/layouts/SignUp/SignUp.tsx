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
        // <div className="d-flex">
        //     <div className="d-flex justify-content-between">
        //         {step == 0 ? <CreateAccount handlePharmacy={handlePharmacy} handleStep={handleStep} />: step == 1 ? <AddressInfo handlePharmacy={handlePharmacy} handleStep={handleStep}  pharmacy={pharmacy}/>: <PharmacyInfo pharmacy={pharmacy} />}
        //         <div className='d-flex'>
        //             <img src={process.env.PUBLIC_URL + '/images/Right.png'} style={{width: '50VW', height: '100vh'}}/>
        //         </div>
        //     </div>
        // </div>
        <div className='d-flex justify-content-between' style={{height:'90vh', width: '100vw'}}>
            <div style={{marginLeft:'9%', marginRight:'4%', marginTop:'7%'}}>
            {step == 0 ? <CreateAccount handlePharmacy={handlePharmacy} handleStep={handleStep} />: step == 1 ? <AddressInfo handlePharmacy={handlePharmacy} handleStep={handleStep}  pharmacy={pharmacy}/>: <PharmacyInfo pharmacy={pharmacy} />}
            </div>
            <div className='d-flex justify-content-end align-items-end sign-up-bg' style={{ height: '100vh', width: '50vw'}}>
            <img src={process.env.PUBLIC_URL + '/images/Right.png'} style={{width: '50VW', height: '100vh'}}/>
            </div>
        </div>
    );
}