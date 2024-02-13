import { FormEvent, useEffect, useState } from 'react';
import { createUserWithEmailAndPassword, getAuth, signInWithEmailAndPassword} from 'firebase/auth';
import { useHistory } from 'react-router-dom';
import { IoCloseCircleOutline } from "react-icons/io5";
import PharmacyModel from '../../../models/Pharmacy';

export interface CreateAccountProps {
    handleStep: (value: number) => void;
    handlePharmacy: (pharmacy: PharmacyModel) => void;
}

export const CreateAccount: React.FC<CreateAccountProps> = (props) => {
    const auth = getAuth();
    const history = useHistory();
    const [ email, setEmail ] = useState('');
    const [ password, setPassword ] = useState('');
    const [ cpassword, setCPassword ] = useState('');
    const [ pwEqual, setPwEqual] = useState(true);

    const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
        event.preventDefault()

        if(password !== cpassword){
            setPwEqual(false);
        }
        else{
            try {
                await createUserWithEmailAndPassword(auth, email, password);
                const pharmacy1: PharmacyModel = new PharmacyModel();
                pharmacy1.setEmail(email);
                props.handlePharmacy(pharmacy1);
                props.handleStep(1);
                
              } catch (error:any) {
                console.log( error.message);
              }
        }
        
    };

    return(
        <div style={{height:'90vh', width: '30vw'}}>
            <div style={{marginLeft:'4%', marginTop:'3%', height:'100%'}}>
                <div>
                <img src={process.env.PUBLIC_URL + '/images/Logo.png'} style={{width:'186px', height:'32px'}}/>
                </div>
                <div className='mt-5' style={{fontSize: '24px', fontFamily: "LINESeedSansTHBold"}}>
                    Create an account
                </div>
                <div className='mt-3' style={{fontSize: '14px', fontFamily: "LINESeedSansTHRegular"}}>
                    Please signup to continue to Pillmate
                </div>
                <div className='d-flex mt-3 gap-1'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                        <path d="M2 2H146" stroke="#059E78" stroke-width="4" stroke-linecap="round"/>
                    </svg>
                    <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                        <path d="M2 2H146" stroke="#D0D0D0" stroke-width="4" stroke-linecap="round"/>
                    </svg>
                    <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                        <path d="M2 2H146" stroke="#D0D0D0" stroke-width="4" stroke-linecap="round"/>
                    </svg>
                </div>
                <form onSubmit={handleSubmit}>
                    <div className='mt-3'>
                        <label className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    Email
                                </div>
                                <div>
                                    *
                                </div>
                            </div>
                        </label>
                        <input type="email" placeholder='pillmate@gmail.com'className="form-control"  name="email" required onChange={e => setEmail(e.target.value)} value={email}  style={{width: '25vw', height: '49px'}}/>
                    </div >
                    <div className='mt-3'>
                        <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    Password
                                </div>
                                <div>
                                    *
                                </div>
                            </div>
                        </label>
                        <input type="password" className="form-control" name="password" required onChange={e => setPassword(e.target.value)} value={password}  style={{width: '25vw', height: '49px'}}/>
                    </div>
                    <div className='mt-3'>
                        <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    Confirmed Password 
                                </div>
                                <div>
                                    *
                                </div>
                            </div>
                        </label>
                        <input type="password" className="form-control" name="cpassword" required onChange={e => setCPassword(e.target.value)} value={cpassword}  style={{width: '25vw', height: '49px'}}/>
                    </div>
                    {pwEqual ? <div className='mt-2'><div style={{height: '24px'}}></div></div>:<div className='d-flex gap-1 align-items-end mt-2'><div><IoCloseCircleOutline color='red'/></div><div style={{color: 'red', fontSize: '14px',fontFamily:'LINESeedSansENRegular'}}>Password not matching</div></div>}
                    <button className="btn mt-3" type="submit" style={{ width: '25vw', backgroundColor: '#059E78', height: '49px'}}>
                        <div className='d-flex justify-content-center' style={{fontFamily: "LINESeedSansENBold", color: "white"}}>
                            Next
                        </div>
                    </button>
                </form>
            </div>
        </div>
    );
}