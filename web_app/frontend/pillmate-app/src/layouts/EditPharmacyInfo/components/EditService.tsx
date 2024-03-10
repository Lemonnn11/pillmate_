import { FormEvent, useEffect, useState } from 'react';
import { useHistory } from 'react-router-dom';
import _thailand from "../../../data/thailand.json";
import { IoIosArrowDown } from 'react-icons/io';
import PharmacyModel from '../../../models/Pharmacy';
import { ReturnDate } from '../../SignUp/components/ReturnDate';
import { ReturnTime } from '../../SignUp/components/ReturnTime';

export interface PharmacyInfoProps{
    pharmacy?: PharmacyModel;
}

export const EditService: React.FC<PharmacyInfoProps> = (props) => {
    const history = useHistory();
    const [ phoneNumber, setPhoneNumber ] = useState('');
    const [ openedDate, setOpenedDate ] = useState('วัน');
    const [ closedDate, setClosedDate ] = useState('วัน');
    const [ openedHour, setOpenedHour ] = useState('เวลา');
    const [ closedHour, setClosedHour ] = useState('เวลา');

    useEffect(() => {
        setPhoneNumber(props.pharmacy!.phoneNumber);
        const date: string[] = props.pharmacy!.serviceDate.split(' - ');
        const time: string[] = props.pharmacy!.serviceTime.split(' - ');
        setOpenedDate(date[0]);
        setClosedDate(date[1]);
        setOpenedHour(time[0]);
        setClosedHour(time[1]);
    }, [props.pharmacy])

    const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
        event.preventDefault()

        if(phoneNumber !== '' && openedDate !== 'วัน' && closedDate !== 'วัน'
        && openedHour !== 'เวลา' && closedHour !== 'เวลา'){
            props.pharmacy?.setPhoneNumber(phoneNumber);
            props.pharmacy?.setServiceDate(openedDate + ' - ' + closedDate);
            props.pharmacy?.setServiceTime(openedHour + ' - ' + closedHour);
            console.log(JSON.stringify(props.pharmacy));

            const request = {
                method: "PUT",
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(props.pharmacy)
            }
            const url = `https://lemonnn11.xyz/api/pharmacy/update`;

            const response = await fetch(url, request)

            if (!response.ok) {
                throw new Error('Error found');
            } else{
                history.push("/");
            }
        }

    };

    const handleOpenedDate = (value: string) => {
        setOpenedDate(value);
    }

    const handleClosedDate = (value: string) => {
        setClosedDate(value);
    }


    const handleOpenedHour = (value: string) => {
        setOpenedHour(value);
    }

    const handleClosedHour = (value: string) => {
        setClosedHour(value);
    }

    return(
        <div style={{height:'90vh', width: '30vw'}}>
            <div style={{marginLeft:'4%', marginTop:'3%', height:'100%'}}>
                <div>
                <img src={process.env.PUBLIC_URL + '/images/Logo.png'} style={{width:'186px', height:'32px'}}/>
                </div>
                <div className='mt-5' style={{fontSize: '24px', fontFamily: "LINESeedSansTHBold"}}>
                    Last Step!
                </div>
                <div className='mt-3' style={{fontSize: '14px', fontFamily: "LINESeedSansTHRegular"}}>
                    please fill the pharmacy information.
                </div>
                <div className='d-flex mt-3 gap-1'>
                    <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                        <path d="M2 2H146" stroke="#059E78" stroke-width="4" stroke-linecap="round"/>
                    </svg>
                    <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                        <path d="M2 2H146" stroke="#059E78" stroke-width="4" stroke-linecap="round"/>
                    </svg>
                    <svg xmlns="http://www.w3.org/2000/svg" width="148" height="4" viewBox="0 0 148 4" fill="none">
                        <path d="M2 2H146" stroke="#059E78" stroke-width="4" stroke-linecap="round"/>
                    </svg>
                </div>
                <form onSubmit={handleSubmit} style={{width: '25vw'}}>
                    <div className='mt-3'>
                        <label className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    Phone number
                                </div>
                            </div>
                        </label>
                        <input type="text" className="form-control"  name="phoneNumber" required onChange={e => setPhoneNumber(e.target.value)} value={phoneNumber}  style={{width: '100%', height: '49px'}}/>
                    </div >
                    <div className='d-flex mt-3'>
                        <div style={{fontSize: '16px', color: '#000000', fontFamily: 'LINESeedSansENRegular'}}>
                            Service Date
                        </div>
                    </div>
                    <div className='d-flex justify-content-between'>
                        <div className='mt-2'>
                            <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                                <div className='d-flex'>
                                    <div style={{fontSize: '14px', color: '#000000'}}>
                                        Opened date
                                    </div>
                                </div>
                            </label>
                            <div className='dropdown'>
                                <button className='btn' type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={{backgroundColor: 'white', width: '11vw', height:'49px', border: '1px solid #DFDFDF'}}>
                                        <div className='d-flex justify-content-between'>
                                       {openedDate}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                       </div>
                                </button>
                                <ReturnDate handleDate={handleOpenedDate}/>
                            </div>
                        </div>
                        <div className='mt-2'>
                            <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                                <div className='d-flex'>
                                    <div style={{fontSize: '14px', color: '#000000'}}>
                                        Closed date
                                    </div>
                                </div>
                            </label>
                            <div className='dropdown'>
                                <button className='btn' type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={{backgroundColor: 'white', width: '11vw', height:'49px', border: '1px solid #DFDFDF'}}>
                                        <div className='d-flex justify-content-between'>
                                        {closedDate}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                       </div>
                                </button>
                                <ReturnDate handleDate={handleClosedDate} />
                            </div>
                        </div>
                    </div>
                    <div className='d-flex mt-3'>
                        <div style={{fontSize: '16px', color: '#000000', fontFamily: 'LINESeedSansENRegular'}}>
                            Service time
                        </div>
                    </div>
                    <div className='d-flex justify-content-between'>
                        <div className='mt-2'>
                            <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                                <div className='d-flex'>
                                    <div style={{fontSize: '14px', color: '#000000'}}>
                                        Opened hour
                                    </div>
                                </div>
                            </label>
                            <div className='dropdown'>
                                <button className='btn' type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={{backgroundColor: 'white', width: '11vw', height:'49px', border: '1px solid #DFDFDF'}}>
                                        <div className='d-flex justify-content-between'>
                                       {openedHour}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                       </div>
                                </button>
                                <ReturnTime handleTime={handleOpenedHour}/>
                            </div>
                        </div>
                        <div className='mt-2'>
                            <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                                <div className='d-flex'>
                                    <div style={{fontSize: '14px', color: '#000000'}}>
                                        Closed hour
                                    </div>
                                </div>
                            </label>
                            <div className='dropdown'>
                                <button className='btn' type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={{backgroundColor: 'white', width: '11vw', height:'49px', border: '1px solid #DFDFDF'}}>
                                        <div className='d-flex justify-content-between'>
                                        {closedHour}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                       </div>
                                </button>
                                <ReturnTime handleTime={handleClosedHour}/>
                            </div>
                        </div>
                    </div>
                    <button className="btn mt-4" type="submit" style={{ width: '100%', backgroundColor: '#059E78', height: '49px'}}>
                        <div className='d-flex justify-content-center' style={{fontFamily: "LINESeedSansENBold", color: "white"}}>
                            Create account
                        </div>
                    </button>
                </form>
            </div>
        </div>
    );
}