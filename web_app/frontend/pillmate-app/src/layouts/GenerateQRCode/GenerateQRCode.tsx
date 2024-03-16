import React, { useState, useEffect, useRef, ChangeEvent } from 'react';
import { IoIosArrowBack, IoIosArrowForward, IoIosArrowDown } from "react-icons/io";
import { ReturnTakemedWhen } from './components/ReturnTakeMedWhen';
import { ReturnEvery } from './components/ReturnEvery';
import { ReturnAdditionalAdvice } from './components/ReturnAdditionalAdvice';
import QRCodeModel from '../../models/QRCode';
import { SlPrinter } from "react-icons/sl";
import ReactToPrint from 'react-to-print';
import { ImageComponent } from './components/ImageComponen';
import { ReturnUnit } from './components/ReturnUnit';
import{getAuth, onAuthStateChanged} from 'firebase/auth';
import { useHistory, useLocation } from 'react-router-dom';
import { log, time } from 'console';
import { getStorage, ref, getDownloadURL } from "firebase/storage";
import { IoCloseCircleOutline } from 'react-icons/io5';
import { ReturnUnitAmount } from './components/ReturnUnitAmount';


export const GenerateQRCode = () => {

    const componentRef = useRef<HTMLDivElement>(null)
    const history = useHistory();
    const [ imageID, setImageID ] = useState('');
    const [ dosagePerTake, setDosagePerTake ]  = useState('');
    const [timePerDay, setTimePerDay ] = useState('');
    const [ expiredDate, setExpiredDate ] = useState('');
    const [ conditionOfUse, setConditionOfUse ] = useState('');
    const [ amountOfMeds, setAmountOfMeds] = useState('');
    const [ morning, setMorning ] = useState(false);
    const [ noon, setNoon ] = useState(false); 
    const [ evening, setEvening ] = useState(false); 
    const [ Bed, setBed ] = useState(false);  
    const [ takeMedWhen, setTakeMedWhen ] = useState("...");
    const [ every, setEvery ] = useState("...");
    const [ dosageClick, setDosageClick ] = useState(false)
    const [ unitAmountClick, setUnitAmountClick ] = useState(false)
    const [ takeMedWhenClick, setTakeMedWhenClick] = useState(false);
    const [ EveryClick, setEveryClick] = useState(false);
    const [ additionalAdviceClick, setAdditionalAdviceClick] = useState(false);
    const [ dosageClickDropdown, setDosageClickDropdown ] = useState(true); 
    const [ unit, setUnit] = useState("แคปซูล");
    const [ unitAmount, setUnitAmount] = useState("แคปซูล");
    const [ addtionalAdvice, setAdditionalAdvice ] = useState('ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที')
    const auth = getAuth();
    const [ tradeName, setTradeName] = useState('');
    const [ genericName, setGenericName] = useState('');
    const [ containers, setContainers ] = useState('');
    const [dosageForm , setDosageForm]  = useState('');
    const [ adverseDrugReaction, setAdverseDrugReaction ] = useState('หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที');
    const [category, setCategory] = useState('');
    const location = useLocation();
    const [ modalShow, setModalShow ] = useState(false);
    const [ pharID, setPharID] = useState('');
    const [ takeMedWhenDisabled, setTakeMedWhenDisabled ] = useState(false);
    const [ everyDisabled, setEveryDisabled ] = useState(false);
    const [ timesPerDayFocus, setTimePerDayFocus ] = useState(false);
    const [ wrongFormatDossagePerTake, setWrongFormatDossagePerTake ] = useState(false);
    const [ wrongFormatAmountOfMeds, setWrongFormatAmountOfMeds ] = useState(false);
    const [ wrongFormatTimesPerDay, setWrongFormatTimesPerDay ] = useState(false);
    const [ selectedEvery, setSeletedEvery ] = useState(false);
    const [ selectedTakeMedWhen, setSeletedTakeMedWhen ] = useState(false);
    const [ plsSelectedWhen, setPlsSelectedWhen] = useState(false);
    const [ wrongFormatExpiredDate, setWrongFormatExpiredDate ] = useState(false);
    const [ timeOfTakenn, setTimeOfTakenn] = useState('');
    const [ loadingModal, setLoadingModal ] = useState(false);
    const [ url, setUrl ] = useState('');

    const date = new Date()
    const result = date.toLocaleDateString('th-TH', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    }) 
    
    useEffect(() => {
        if (location.state) {
          setTradeName((location.state as any).tradeName);
          setGenericName((location.state as any).genericName);
        //   setContainers((location.state as any).containers);
          setDosageForm((location.state as any).dosageForm);
          setCategory((location.state as any).category);
        } else {
          console.error('Data is not available in location state.');
        }
      }, [location.state]);

    

    useEffect(() => {
        authCheck();
        return () => authCheck();
    }, [auth]);

    useEffect(() => {
        const storage = getStorage();
                    const sparkyRef = ref(storage, `${imageID}.png`);

                    getDownloadURL(sparkyRef).then((url) => {
                        const xhr = new XMLHttpRequest();
                        xhr.responseType = 'blob';
                        xhr.onload = (event) => {
                          const blob = xhr.response;
                        };
                        xhr.open('GET', url);
                        xhr.send();
                    
                        // Or inserted into an <img> element
                        // const img = document.getElementById('myimg');
                        // img!.setAttribute('src', url);
                        setUrl(url);
                      })
                      .catch((error) => {
                        // Handle any errors
                      });
    }, [imageID]);

    const authCheck = onAuthStateChanged(auth, (user) => {
        if(!user){
            history.push('/login');
        }
    });


    const handleTakeMedWhen = (value: string) => {
        setTakeMedWhen(value);
        if(value === 'ทานเมื่อมีอาการ'){
            setSeletedEvery(true);
        }
        else if(value !== '...'){
            setSeletedTakeMedWhen(true);
            setSeletedEvery(false);
            setEvery('...');
        }
    } 

    const handleEvery = (value: string) => {
        setEvery(value);
        if(value !== '...'){
            setSeletedEvery(true);
            setTakeMedWhen('...')
        }else{
            setSeletedEvery(false);
            
        }
    } 

    const handleAddtionalAdvice = (value: string) => {
        setAdditionalAdvice(value);
    }

    const handleUnit = (value: string) => {
        setUnit(value);
        handleDosageClickNotFocus();
    }

    const handleUnitAmount = (value: string) => {
        setUnitAmount(value);
        handleUnitAmountClickNotFocus();
    }

    const handleMorning = () => {
        setMorning(!morning);
    }

    const handleNoon = () => {
        setNoon(!noon);
    }

    const handleEvening = () => {
        setEvening(!evening);
    }

    const handleBed = () => {
        setBed(!Bed);
    }

    const handleDosageClick = () => {
        setDosageClick(true);
    } 

    const handleUnitAmountClick = () => {
        setUnitAmountClick(true);
    }

    const handleUnitAmountClickNotFocus = () => {
        setUnitAmountClick(false);
    }

    const handleDosageClickNotFocus = () => {
        setDosageClick(false);
    }
    
    const handleDosageClickDropdown = () => {
        setDosageClickDropdown(false)
    } 

    const handleTimesPerDayFocus = () => {
        setTimePerDayFocus(true);
    }


    const handleTimesPerDayNotFocus = () => {
        setTimePerDayFocus(false);
    }

    const handleTakeMedWhenFocus = () => {
        setTakeMedWhenClick(true);
    }

    const handleTakeMedWhenNotFocus = () => {
        setTakeMedWhenClick(false);
    }

    const handleEveryFocus = () => {
        setEveryClick(true);
    }

    const handleEveryNotFocus = () => {
        setEveryClick(false);
    }

    const handleAddtionalAdviceFocus = () => {
        setAdditionalAdviceClick(true);
    }

    const handleAddtionalAdviceNotFocus = () => {
        setAdditionalAdviceClick(false);
    }

    const handleDosagePerTake = (event: ChangeEvent<HTMLInputElement>) => {
        const { value } = event.target;
        const isValidInput = /^[0-9]$/.test(value);
        if (isValidInput || value === '') {
            setDosagePerTake(value);
            setWrongFormatDossagePerTake(false);
        }else{
            setWrongFormatDossagePerTake(true);
        }
    }

    const handleAmountOfMeds = (event: ChangeEvent<HTMLInputElement>) => {
        const { value } = event.target;
        const isValidInput = /^\d+$/.test(value);
        if (isValidInput || value === '') {
            setAmountOfMeds(value);
            setWrongFormatAmountOfMeds(false);
        }else{
            setWrongFormatAmountOfMeds(true);
        }
    }

    const handleTimesPerDay = (event: ChangeEvent<HTMLInputElement>) => {
        const { value } = event.target;
        const isValidInput = /^[0-9]$/.test(value);
        if (isValidInput || value === '') {
            setTimePerDay(value);
            setWrongFormatTimesPerDay(false);
        }else{
            setWrongFormatTimesPerDay(true);
        }
    }

    const handleExpiredDate = (event: ChangeEvent<HTMLInputElement>) => {
        const { value } = event.target;
        const isValidInput = /^^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$/.test(value);
        if (isValidInput || value === '') {
                setExpiredDate(value);
                setWrongFormatExpiredDate(false);
        }else{
            setExpiredDate(value);
            setWrongFormatExpiredDate(true);
        }
    }
    

    async function createQRCode(event: React.FormEvent<HTMLFormElement>){
        event.preventDefault();
        setLoadingModal(true);
        const url = `http://localhost:8080/api/qrCode/create`;
        if(takeMedWhen !== '...' && (!morning && !noon && !evening && !Bed)){
            setPlsSelectedWhen(true);
        }else {
            if(dosagePerTake !== '' && timePerDay !== '' && expiredDate !== '' && conditionOfUse !== '' && amountOfMeds !== '' && (takeMedWhen !== '...' || every !== '...')){
            
                const gmtOffset = +7 * 60; // GMT-5 time zone (5 hours behind UTC)
                const expDate = new Date(expiredDate);
                const gmtsDate = new Date(expDate.getTime() + gmtOffset * 60000);
    
                const localDate =  new Date();
                const gmtsLocalDate = new Date(localDate.getTime() + gmtOffset * 60000);
    
                let timeOfTaken: string = '';
                if(morning){
                    if(noon || evening || Bed){
                        timeOfTaken += 'เช้า ';
                    }else{
                        timeOfTaken += 'เช้า';
                    }
                }
                if(noon){
                    if(evening || Bed){
                        timeOfTaken += 'กลางวัน ';
                    }else{
                        timeOfTaken += 'กลางวัน';
                    }
                }
                if(evening){
                    if(Bed){
                        timeOfTaken += 'เย็น ';
                    }else{
                        timeOfTaken += 'เย็น';
                    }
                }
                if(Bed){
                    timeOfTaken += 'ก่อนนอน';
                }
                setTimeOfTakenn(timeOfTaken);
                if(every !== '...'){
                    const tmp = every.split(' ');
                    setEvery(tmp[0]);
                }
    
                const user = auth.currentUser;
    
                if (user !== null) {
                user.providerData.forEach(async (profile) => {
    
                    console.log('pharID: ' + profile.displayName!);
                
                    const qrCode: QRCodeModel = new QRCodeModel('', profile.displayName!, parseInt(dosagePerTake), parseInt(timePerDay), takeMedWhen, every, timeOfTaken, gmtsDate.toISOString(), gmtsLocalDate.toISOString(), conditionOfUse, addtionalAdvice, parseInt(amountOfMeds), 250, adverseDrugReaction, dosageForm, genericName, tradeName);
                    console.log(JSON.stringify(qrCode));
    
                    const request = {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify(qrCode)
                    };
    
                    const create = await fetch(url, request);
                    if (!create) {
                        throw new Error('Error found');
                    }else{
                        const response = await create.json()
                        console.log(response["id"])
                        setImageID(response["id"])
                        setLoadingModal(false);
                        setModalShow(true);
                    }
                });
                }
                
            }else{
                setLoadingModal(false);
                setModalShow(false);
            }
        }

        
    }

    return (
        <div className='d-flex' style={{height:'100vh', width: '100vw', marginRight:'1px'}}>
            {loadingModal ? (<div className="modal fade" id="exampleModalCenter"  role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true" style={{fontFamily: "LINESeedSansTHRegular"}}>
            <div className="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div className="modal-content">
                    <div className="modal-header d-flex justify-content-end">
                        <button type="button" className="close btn" data-bs-dismiss="modal" aria-label="Close">
                            ปิด
                        </button>
            </div>
            <div className="modal-body">
                <div className='d-flex' style={{marginLeft: '5.5%', marginRight: '8.5%', gap: '11%', marginBottom:'2%'}}>
                    <a>Loading...</a>
                </div>
            </div>
            </div>
            </div>
        </div>): modalShow ? (<div className="modal fade" id="exampleModalCenter"  role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true" style={{fontFamily: "LINESeedSansTHRegular"}}>
                <div className="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div className="modal-content">
                        <div className="modal-header d-flex justify-content-end">
                            <button type="button" className="close btn" data-bs-dismiss="modal" aria-label="Close">
                                ปิด
                            </button>
                </div>
                <div className="modal-body">
                    <div className='d-flex' style={{marginLeft: '5.5%', marginRight: '8.5%', gap: '11%', marginBottom:'2%'}}>
                        <div style={{width:'30%'}}>
                            <div  >
                                {url !== ''? <div ref={componentRef}>
                                    <img  src={url} id="myimg"/>
                                </div>: <div className='d-flex justify-content-center align-items-center' style={{height: '20vh'}}>
                                    Loading QR Code...
                                </div>}
                            
                            </div>
                            <div style={{marginLeft: '9.5%', width: '100%'}}>
                            <div className='d-flex gap-1'>
                                <div style={{fontFamily: "LINESeedSansTHBold"}}>
                                    วันที่จ่าย:
                                </div>
                                <div>
                                    {result}
                                </div>
                            </div>
                            <div className='gap-1'>
                                <div style={{fontFamily: "LINESeedSansTHBold"}}>
                                    ร้านยา:
                                </div>
                                <div>
                                    ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน
                                </div>
                            </div>
                            <div className='d-flex gap-1'>
                                <div style={{fontFamily: "LINESeedSansTHBold"}}>
                                    เบอร์โทร:
                                </div>
                                <div>
                                    091-806-2724
                                </div>
                            </div>
                            </div>
                        </div>

                        <div className='mt-2'>
                            <div style={{fontFamily: "LINESeedSansENBold", fontSize:'32px'}}>
                                Drug Summary
                            </div>
                            <div>
                                {genericName}
                            </div>
                            <div className="mt-2" style={{fontFamily: "LINESeedSansTHBold"}}>
                                รายละเอียด
                            </div>
                            <hr style={{width:'100%'}}/>
                            <div className='d-flex gap-1'>
                            <div style={{fontFamily: "LINESeedSansTHBold"}}>
                                {genericName}
                            </div>
                            <div>
                                จำนวน {amountOfMeds} {unitAmount}
                            </div>
                            </div>
                            <div>
                                รับประทานยา{takeMedWhen === '...' ? '': takeMedWhen} ครั้งละ {dosagePerTake} {unit}
                            </div>
                            <div>
                                วันละ {timePerDay} ครั้ง {takeMedWhen === '...' ? `ทุกๆ ${every} ชั่วโมง`: `${timeOfTakenn}`}
                            </div>
                            <div className='d-flex gap-1 mt-3'>
                                <div style={{fontFamily: "LINESeedSansTHBold"}}>
                                    วันหมดอายุ:
                                </div>
                                <div>
                                 {expiredDate}
                                </div>
                            </div>
                            <div >
                                <div className='mt-3' style={{fontFamily: "LINESeedSansTHBold"}}>
                                    ข้อบ่งใช้
                                </div>
                                <div>
                                    {conditionOfUse}
                                </div>
                            </div>
                            <div >
                                <div className='mt-3'style={{fontFamily: "LINESeedSansTHBold"}}>
                                    คำแนะนำเพิ่มเติม
                                </div>
                                <div>
                                    {addtionalAdvice}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="modal-footer">
                <ReactToPrint
                    trigger={() => <button type="button" className="btn btn-outline-dark">
                    <div className='d-flex gap-2'>
                        <SlPrinter style={{marginTop: '3%'}}/>
                        ปรินต์ QR Code
                    </div>
                    </button>}
                    content={() => {
                        if (componentRef && componentRef.current) {
                            return componentRef.current;
                        } else {
                            console.log('componentRef is not available right now.');
                        }
                        return null;
                    }}
                />
                    </div>
                </div>
                </div>
            </div>):
            (<div className="modal fade" id="exampleModalCenter"  role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true" style={{fontFamily: "LINESeedSansTHRegular"}}>
            <div className="modal-dialog modal-dialog-centered modal-lg" role="document">
                <div className="modal-content">
                    <div className="modal-header d-flex justify-content-end">
                        <button type="button" className="close btn" data-bs-dismiss="modal" aria-label="Close">
                            ปิด
                        </button>
            </div>
            <div className="modal-body">
                <div className='d-flex' style={{marginLeft: '5.5%', marginRight: '8.5%', gap: '11%', marginBottom:'2%'}}>
                    <a>Please Fill in all information</a>
                </div>
            </div>
            </div>
            </div>
        </div>)}

            <div style={{width: '38vw',background: '#FFFFFF', boxShadow: '2px 346px rgba(119, 119, 119, 0.25)', paddingTop: '3.5%'}}>       
                <div className='d-flex gap-3'>
                    <img src={process.env.PUBLIC_URL + '/images/para.png'} style={{width:'140px', height:'140px', marginLeft: '10%'}}/>
                    <div>
                        <div style={{fontSize: '24px', fontFamily: "LINESeedSansENBold"}}>
                            {genericName}
                        </div>
                        <div className='d-flex mt-3'>
                            <div style={{fontSize: '18px', fontFamily: "LINESeedSansENMd"}}>
                                ชื่อทางการค้า:
                            </div>
                            <div style={{fontSize: '18px', fontFamily: "LINESeedSansENRegular"}}>
                                {tradeName}
                            </div>
                        </div>
                        <div className='d-flex mt-2'>
                            <div style={{fontSize: '18px', fontFamily: "LINESeedSansENMd"}}>
                                ประเภทยา:
                            </div>
                            <div style={{fontSize: '18px', fontFamily: "LINESeedSansENRegular"}}>
                                {category === '' ? 'N/A': category}
                            </div>
                        </div>
                        {/* <div className='d-flex mt-2'>
                            <div style={{fontSize: '18px', fontFamily: "LINESeedSansENMd"}}>
                                บรรจุภัณฑ์:
                            </div>
                            <div style={{fontSize: '18px', fontFamily: "LINESeedSansENRegular"}}>
                                {containers}
                            </div>
                        </div> */}
                        <div className='d-flex mt-2'>
                            <div style={{fontSize: '18px', fontFamily: "LINESeedSansENMd"}}>
                                รูปแบบยาเตรียม:
                            </div>
                            <div style={{fontSize: '18px', fontFamily: "LINESeedSansENRegular"}}>
                                {dosageForm}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div  style={{width: '62vw',background: '#F6F6F6', paddingRight: '8%',  paddingTop: '3%', paddingLeft: '7%'}}>
                <div className='d-flex justify-content-start' style={{gap: '8px'}}>
                    <div onClick={history.goBack} className='d-flex align-items-center'>
                        <IoIosArrowBack size={32}/>
                    </div>
                    <div style={{fontSize: '32px', fontFamily: "LINESeedSansENBold"}}>
                        Generate QR
                    </div>
                </div>
                <div className='mt-1'style={{marginLeft: '1%', fontFamily: 'LINESeedSansTHRegular'}}>
                    <div className='d-flex justify-content-start' style={{gap: '8px', fontFamily: 'LINESeedSansENRegular', marginBottom: '3.5%'}}>
                        <div style={{fontSize: '14px', color: '#757575'}}>
                            Drug list
                        </div>
                        <div className='d-flex align-items-center'>
                            <IoIosArrowForward size={14} color='#757575'/>
                        </div>
                        <div style={{fontSize: '14px', color: '#757575'}}>
                            {genericName}
                        </div>
                    </div>
                    <form  onSubmit={createQRCode} style={{width: '39vw'}}>
                        <div className='d-flex justify-content-between' style={{gap: '25%'}}>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            รับประทานครั้งละ
                                        </div>
                                        <div>
                                            *
                                        </div>
                                    </div>
                                </label>
                                <div className='d-flex'>
                                    {dosageClick ? 
                                    <input type="text" onClick={handleDosageClick} onBlur={handleDosageClickNotFocus} className="form-control form-control-clicked" placeholder='จำนวน' name="dosagePerTake" required onChange={e => handleDosagePerTake(e)} value={dosagePerTake} style={{width: '9vw', height: '46px', borderRight: 'none', borderTopRightRadius: '0px', borderBottomRightRadius: '0px'}}/>:
                                    <input type="text" onClick={handleDosageClick} onBlur={handleDosageClickNotFocus} className="form-control" placeholder='จำนวน' name="dosagePerTake" required onChange={e => handleDosagePerTake(e)} value={dosagePerTake} style={{width: '9vw', height: '46px', borderRight: 'none', borderTopRightRadius: '0px', borderBottomRightRadius: '0px'}}/>}
                                    
                                    {/* <div className="dropdown">
                                        <button className="btn onclicked-button" onClick={handleDosageClick} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" style={{backgroundColor: 'white', width: '5vw', height: '46px', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}}>
                                        <div className='d-flex justify-content-between'>
                                        {unit}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                        </div>
                                        </button>
                                        <ReturnUnit handleUnit={handleUnit} />
                                    </div>: */}
                                    <div className="dropdown">
                                        <button className="btn" onClick={handleDosageClick} onBlur={handleDosageClickNotFocus} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" style={dosageClick ? {borderLeft: 'none', borderColor: '#1AB48D', boxShadow: '0 0 0 0.2rem rgba(213, 236, 230, 0.75)' ,backgroundColor: 'white', width: '5vw', height: '46px', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}: {borderLeft: '0', borderColor: '#e2e2e2',backgroundColor: 'white', width: '5vw', height: '46px', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}}>
                                        <div className='d-flex justify-content-between'>
                                        {unit}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                        </div>
                                        </button>
                                        <ReturnUnit handleUnit={handleUnit} />
                                    </div>
                                </div>
                                {wrongFormatDossagePerTake ? (<div className='d-flex gap-1 align-items-center mt-2'><div className='d-flex align-items-center'><IoCloseCircleOutline color='red'/></div><div style={{color: 'red', fontSize: '14px',fontFamily:'LINESeedSansENRegular'}}>กรุณาใส่ตัวเลข เช่น 0-9 </div></div>): (<div></div>)}
                            </div>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex justify-content-between'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            วันละ
                                        </div>
                                        <div>
                                            *
                                        </div>
                                    </div>
                                </label>
                                {timesPerDayFocus ? 
                                     <div className='d-flex'>
                                    <input type="text" onClick={handleTimesPerDayFocus} onBlur={handleTimesPerDayNotFocus} className="form-control form-control-clicked" placeholder='จำนวน' aria-label="Text input with dropdown button" name="dosagePerTake" required onChange={e => handleTimesPerDay(e)} value={timePerDay}  style={{width: '11vw', height: '46px', borderTopRightRadius: '0px', borderBottomRightRadius: '0px', borderRight: 'none'}}/>
                                    <div className= "d-flex align-items-center justify-content-center form-control form-control-clicked" style={ {backgroundColor: 'white', width: '3vw', borderTopRightRadius: '6px', borderBottomRightRadius: '6px', borderLeft: '0' , borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}}>
                                        ครั้ง
                                    </div>
                                    </div>:
                                    <div className='d-flex'>
                                    <input type="text" onClick={handleTimesPerDayFocus} onBlur={handleTimesPerDayNotFocus} className="form-control" placeholder='จำนวน' aria-label="Text input with dropdown button" name="dosagePerTake" required onChange={e => handleTimesPerDay(e)} value={timePerDay}  style={{width: '11vw', height: '46px', borderTopRightRadius: '0px', borderBottomRightRadius: '0px', borderRight: 'none'}}/>
                                    <div className= "d-flex align-items-center justify-content-center form-control" style={ {backgroundColor: 'white', width: '3vw', borderTopRightRadius: '6px', borderBottomRightRadius: '6px', borderLeft: '0', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}}>
                                        ครั้ง
                                    </div>
                                    </div>}
                                    
                                    
                                    {wrongFormatTimesPerDay ? (<div className='d-flex gap-1 align-items-center mt-2'><div className='d-flex align-items-center'><IoCloseCircleOutline color='red'/></div><div style={{color: 'red', fontSize: '14px',fontFamily:'LINESeedSansENRegular'}}>กรุณาใส่ตัวเลข เช่น 0-9 </div></div>): (<div></div>)}
                            </div>
                        </div>
                        <div className={wrongFormatDossagePerTake || wrongFormatTimesPerDay ?'d-flex justify-content-between align-self-end' :'d-flex justify-content-between align-self-end mt-4'}>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            เวลาการรับประทาน
                                        </div>
                                    </div>
                                </label>
                                <div className="dropdown">
                                    <button className="btn" onClick={handleTakeMedWhenFocus} onBlur={handleTakeMedWhenNotFocus} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown"  style={takeMedWhenClick ? {borderColor: '#1AB48D', boxShadow: '0 0 0 0.2rem rgba(213, 236, 230, 0.75)' ,backgroundColor: 'white', width: '14vw', height: '46px'}: {borderColor: '#e2e2e2',backgroundColor: 'white', width: '14vw', height: '46px'}}>
                                       <div className='d-flex justify-content-between'>
                                       {takeMedWhen}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                       </div>
                                    </button>
                                    <ReturnTakemedWhen handleTakeMedWhen={handleTakeMedWhen}/>
                                </div>
                            </div>
                            <div className='align-self-end'>
                                หรือ
                            </div>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            ทุกๆ
                                        </div>
                                    </div>
                                </label>
                                <div className="dropdown">
                                    <button className="btn" onClick={handleEveryFocus} onBlur={handleEveryNotFocus} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" style={EveryClick ? {borderColor: '#1AB48D', boxShadow: '0 0 0 0.2rem rgba(213, 236, 230, 0.75)' ,backgroundColor: 'white', width: '14vw', height: '46px'}: {borderColor: '#e2e2e2',backgroundColor: 'white', width: '14vw', height: '46px'}}>
                                       <div className='d-flex justify-content-between'>
                                       {every}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                       </div>
                                    </button>
                                    <ReturnEvery handleEvery={handleEvery}/>
                                </div>
                            </div>
                        </div>

                        <div className='d-flex justify-content-between align-self-end mt-4'>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            ช่วงเวลา
                                        </div>
                                        {!selectedTakeMedWhen ? 
                                        <div></div>
                                        :
                                        plsSelectedWhen ? 
                                        <div style={{color: 'red'}}>
                                            *
                                        </div>
                                        :
                                        <div>
                                            *
                                        </div>}
                                    </div>
                                </label>
                                <div className="d-flex gap-2" >
                        
                                    {morning ? selectedEvery ?  <button disabled className="btn" type="button" onClick={handleMorning} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                                        <div className='d-flex justify-content-center'>
                                                            เช้า
                                                         </div>
                                                </button>: 
                                                <button className="btn btn-selected" type="button" onClick={handleMorning} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                                    <div className='d-flex justify-content-center'>
                                                        เช้า
                                                    </div>
                                                </button>
                                        :
                                                selectedEvery ? 
                                                <button disabled className="btn" type="button" onClick={handleMorning} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                                        <div className='d-flex justify-content-center'>
                                                            เช้า
                                                         </div>
                                                </button>:
                                                <button  className="btn" type="button" onClick={handleMorning} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                                        <div className='d-flex justify-content-center'>
                                                            เช้า
                                                         </div>
                                                </button>
                                    }
                                    {noon ? selectedEvery ? <button disabled className="btn" type="button" onClick={handleNoon} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                    <div className='d-flex justify-content-center'>
                                      กลางวัน
                                    </div>
                                     </button>:<button className="btn btn-selected" type="button" onClick={handleNoon} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                       <div className='d-flex justify-content-center'>
                                         กลางวัน
                                       </div>
                                    </button>:
                                    selectedEvery ? <button disabled className="btn" type="button" onClick={handleNoon} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                    <div className='d-flex justify-content-center'>
                                      กลางวัน
                                    </div>
                                     </button>:
                                    <button className="btn" type="button" onClick={handleNoon} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                    <div className='d-flex justify-content-center'>
                                      กลางวัน
                                    </div>
                                 </button>}
                                    {evening ? selectedEvery ? <button disabled className="btn" type="button" onClick={handleEvening} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                       <div className='d-flex justify-content-center'>
                                         เย็น
                                       </div>
                                    </button>: <button className="btn btn-selected" type="button" onClick={handleEvening} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                       <div className='d-flex justify-content-center'>
                                         เย็น
                                       </div>
                                    </button>:
                                     selectedEvery ? 
                                     <button disabled className="btn" type="button" onClick={handleEvening} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                       <div className='d-flex justify-content-center'>
                                         เย็น
                                       </div>
                                    </button>
                                     :
                                    <button className="btn" type="button" onClick={handleEvening} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                       <div className='d-flex justify-content-center'>
                                         เย็น
                                       </div>
                                    </button>}
                                    {Bed ?  selectedEvery ? <button disabled className="btn" type="button" onClick={handleBed} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                       <div className='d-flex justify-content-center'>
                                         ก่อนนอน
                                       </div>
                                    </button>:<button className="btn btn-selected" type="button" onClick={handleBed} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                       <div className='d-flex justify-content-center'>
                                         ก่อนนอน
                                       </div>
                                    </button>:
                                    selectedEvery ? 
                                    <button disabled className="btn" type="button" onClick={handleBed} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                       <div className='d-flex justify-content-center'>
                                         ก่อนนอน
                                       </div>
                                    </button>
                                    :
                                    <button className="btn" type="button" onClick={handleBed} style={{backgroundColor: 'white', width: '4.5vw', height: '50px', borderColor: '#e2e2e2'}}>
                                       <div className='d-flex justify-content-center'>
                                         ก่อนนอน
                                       </div>
                                    </button>}
                                </div>
                            </div>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex justify-content-between'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            วันหมดอายุ
                                        </div>
                                        <div>
                                            *
                                        </div>
                                    </div>
                                </label>
                                <input type="text" className="form-control" placeholder='04/22/2024' aria-label="Text input with dropdown button" name="dosagePerTake" required onChange={e => handleExpiredDate(e)} value={expiredDate}  style={{width: '14vw', height: '46px'}}/>
                                {wrongFormatExpiredDate ? (<div className='d-flex gap-1 align-items-center mt-2'><div className='d-flex align-items-center'><IoCloseCircleOutline color='red'/></div><div style={{color: 'red', fontSize: '14px',fontFamily:'LINESeedSansENRegular'}}>กรุณาใส่ เดือน/วัน/ปี</div></div>): (<div></div>)}
                            </div>
                        </div>

                        <div className={wrongFormatExpiredDate ? 'd-flex justify-content-start align-self-end': 'd-flex justify-content-start align-self-end mt-4'}>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex justify-content-between'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            ข้อบ่งใช้
                                        </div>
                                        <div>
                                            *
                                        </div>
                                    </div>
                                </label>
                                <input type="text" className="form-control" placeholder='เช่น ลดคลื่นไส้อาเจียน' aria-label="Text input with dropdown button" name="dosagePerTake" required onChange={e => setConditionOfUse(e.target.value)} value={conditionOfUse}  style={{width: '39vw', height: '46px'}}/>
                            </div>
                        </div>

                        <div className='d-flex justify-content-start align-self-end mt-4'>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex justify-content-between'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            คำแนะนำเพิ่มเติม
                                        </div>
                                        <div>
                                            *
                                        </div>
                                    </div>
                                </label>
                                <div className="dropdown">
                                    <button className="btn" onClick={handleAddtionalAdviceFocus} onBlur={handleAddtionalAdviceNotFocus} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={additionalAdviceClick ? {borderColor: '#1AB48D', boxShadow: '0 0 0 0.2rem rgba(213, 236, 230, 0.75)' ,backgroundColor: 'white', width: '39vw', height: '46px'}: {borderColor: '#e2e2e2',backgroundColor: 'white', width: '39vw', height: '46px'}}>
                                       <div className='d-flex justify-content-between'>
                                       {addtionalAdvice}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                       </div>
                                    </button>
                                    <ReturnAdditionalAdvice handleAdditionalAdvice={handleAddtionalAdvice}/>
                                </div>
                            </div>
                        
                        </div>

                        <div className='d-flex justify-content-start align-self-end mt-4'>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex justify-content-between'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            อาการไม่พึ่งประสงค์
                                        </div>
                                    </div>
                                </label>
                                <input type="text" className="form-control" aria-label="Text input with dropdown button" name="adverseDrugReaction" required onChange={e => setAdverseDrugReaction(e.target.value)} value={adverseDrugReaction}  style={{width: '39vw', height: '46px'}}/>
                            </div>
                        </div>

                        <div className='d-flex justify-content-between mt-4' >
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex justify-content-between'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            จำนวน
                                        </div>
                                        <div>
                                            *
                                        </div>
                                    </div>
                                </label>
                                <div className='d-flex'>
                                    {unitAmountClick ? 
                                    <input type="text" onClick={handleUnitAmountClick} onBlur={handleUnitAmountClickNotFocus} className="form-control form-control-clicked" placeholder='จำนวน' name="dosagePerTake" required onChange={e => handleAmountOfMeds(e)} value={amountOfMeds} style={{width: '9vw', height: '46px', borderRight: 'none', borderTopRightRadius: '0px', borderBottomRightRadius: '0px'}}/>:
                                    <input type="text" onClick={handleUnitAmountClick} onBlur={handleUnitAmountClickNotFocus} className="form-control" placeholder='จำนวน' name="dosagePerTake" required onChange={e => handleAmountOfMeds(e)} value={amountOfMeds} style={{width: '9vw', height: '46px', borderRight: 'none', borderTopRightRadius: '0px', borderBottomRightRadius: '0px'}}/>}
                                    
                                    {/* <div className="dropdown">
                                        <button className="btn onclicked-button" onClick={handleDosageClick} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" style={{backgroundColor: 'white', width: '5vw', height: '46px', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}}>
                                        <div className='d-flex justify-content-between'>
                                        {unit}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                        </div>
                                        </button>
                                        <ReturnUnit handleUnit={handleUnit} />
                                    </div>: */}
                                    <div className="dropdown">
                                        <button className="btn" onClick={handleUnitAmountClick} onBlur={handleUnitAmountClickNotFocus} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" style={unitAmountClick ? {borderLeft: 'none', borderColor: '#1AB48D', boxShadow: '0 0 0 0.2rem rgba(213, 236, 230, 0.75)' ,backgroundColor: 'white', width: '5vw', height: '46px', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}: {borderLeft: '0', borderColor: '#e2e2e2',backgroundColor: 'white', width: '5vw', height: '46px', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}}>
                                        <div className='d-flex justify-content-between'>
                                        {unitAmount}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                        </div>
                                        </button>
                                        <ReturnUnitAmount handleUnitAmount={handleUnitAmount} />
                                    </div>
                                    
                                </div>
                                {wrongFormatAmountOfMeds ? (<div className='d-flex gap-1 align-items-center mt-2'><div className='d-flex align-items-center'><IoCloseCircleOutline color='red'/></div><div style={{color: 'red', fontSize: '14px',fontFamily:'LINESeedSansENRegular'}}>กรุณาใส่ตัวเลข</div></div>): (<div></div>)}
                            </div>
                            <div className='align-self-end'>
                                    <button className="btn" type="submit" data-bs-toggle="modal" data-bs-target="#exampleModalCenter" style={{ width: '10vw', backgroundColor: '#1AB48D', height: '46px'}}>
                                       <div className='d-flex justify-content-center' style={{fontFamily: "LINESeedSansENBold", color: "white"}}>
                                         Generate QR
                                       </div>
                                    </button>
                            </div>
                        </div>
                    </form> 
                </div>    
            </div>
        </div>
    );
}