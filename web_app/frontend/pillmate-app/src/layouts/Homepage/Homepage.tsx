import { useEffect, useState } from "react";
import { IoIosArrowDown } from "react-icons/io";
import { ReturnDrug } from "./components/ReturnDrug";
import DrugModel from "../../models/Drug";
import { getAuth, onAuthStateChanged } from "firebase/auth";
import { useHistory } from "react-router-dom";

export const Homepage = () => {

    const [query, setQuery] = useState('');
    const history = useHistory();
    const drugs = [
        new DrugModel('Paracap Tab. 500 mg', 'Paracetamol', 'Container N/A, Storage N/A', 'TAB','Analgesics (Non-opioid) & antipyretics'),
        new DrugModel('Moximo Cap. 500 mg', 'Amoxicillin', 'Container N/A, Storage N/A', 'CAP', 'Penicillins'),
    ];
    const auth = getAuth();

    useEffect(() => {
        authCheck();
        return () => authCheck();
    }, [auth]);

    const authCheck = onAuthStateChanged(auth, (user) => {
        if(!user){
            history.push('/login');
        }
    });

    return(
        <div className="d-flex">
            <div style={{width: '20vw', height: '100vw', paddingTop: '3%', background: 'white'}}>
                <div className="d-flex align-items-center justify-content-between">
                    <img src={process.env.PUBLIC_URL + '/images/pillmatew.png'} style={{width:'129px', height:'58px', marginLeft: '10%'}}/>
                    <img src={process.env.PUBLIC_URL + '/images/hamburgermenu.png'} style={{width:'40px', height:'40px',marginRight: '10%',}}/>
                </div>
                <div className="mt-4"style={{fontFamily: 'LINESeedSansENRegular', fontSize: '16px', color: '#757575', marginLeft: '10%'}}>
                    Main menu
                </div>
                <div className="d-flex justify-content-start mt-3 align-items-end">
                    <img src={process.env.PUBLIC_URL + '/images/solar_document-medicine-outline.png'} style={{width:'24px', height:'24px', marginLeft: '10%'}}/>
                    <div className="mt-4"style={{fontFamily: 'LINESeedSansENBold', fontSize: '16px', color: '#1AB48D', marginLeft: '5%'}}>
                        Drug list
                    </div>
                </div>
            </div>
            <div style={{width: '80vw', height: '100vw', paddingTop: '3.1%',background: '#F6F6F6', paddingLeft: '5%', paddingRight: '5%'}}>
                <div className="d-flex align-items-center justify-content-between">
                    <div>
                        <div style={{fontFamily: 'LINESeedSansENBold', fontSize: '32px'}}>
                            Drug list
                        </div>
                        <div className="mt-1"style={{fontFamily: 'LINESeedSansENRegular', fontSize: '14px', color:'#2C2C2C'}}>
                            100 drugs found
                        </div>
                    </div>
                    <img src={process.env.PUBLIC_URL + '/images/hamburgermenu.png'} style={{width:'40px', height:'40px'}}/>
                </div>
                <div className="d-flex mt-4">
                <div className="dropdown">
                    <button className="btn" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown"  style={{backgroundColor: 'white', width: '8vw', height: '53px', borderTopRightRadius: '0px', borderBottomRightRadius: '0px'}}>
                        <div className='d-flex justify-content-around'>
                            <div style={{fontFamily: 'LINESeedSansENRegular', fontSize: '14px', color:'#8A8A8A'}}>
                                Add filter
                            </div>
                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                        </div>
                    </button>        
                </div>
                <input type="text" className="form-control" placeholder='Search for a teachers by name or email' name="dosagePerTake" required onChange={e => setQuery(e.target.value)} value={query} style={{width: '90vw', height: '53px', border: 'none', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px', backgroundColor: '#EEEEEE', paddingLeft: '2%'}}/>
            </div>
            <div className="mt-4">
            <table className='table'>
                    <thead className="text-start" style={{backgroundColor: 'white'}}>
                        <tr style={{fontFamily: 'LINESeedSansENBold'}}>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%', paddingLeft: '1.5%'}}>id</th>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%'}}>Trade name</th>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%'}}>Generic name</th>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%'}}>Containers</th>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%'}}></th>
                    
                        </tr>
                    </thead>
                    <tbody className="text-start">
                        {drugs.slice(0, drugs.length).map(drug => (
                            <ReturnDrug drug={drug}/>
                        ))}
                    </tbody>
                </table>
            </div>
            </div>
            
        </div>
    );
}