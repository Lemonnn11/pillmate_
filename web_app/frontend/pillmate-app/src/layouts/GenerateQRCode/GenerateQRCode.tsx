import React, { useState, useEffect, useRef } from 'react';
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
import { log } from 'console';


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
    const [ dosageClickDropdown, setDosageClickDropdown ] = useState(true); 
    const [ unit, setUnit] = useState("แคปซูล");
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

    const authCheck = onAuthStateChanged(auth, (user) => {
        if(!user){
            history.push('/login');
        }
    });


    const handleTakeMedWhen = (value: string) => {
        setTakeMedWhen(value);
    } 

    const handleEvery = (value: string) => {
        setEvery(value);
    } 

    const handleAddtionalAdvice = (value: string) => {
        setAdditionalAdvice(value);
    }

    const handleUnit = (value: string) => {
        setUnit(value);
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
        setDosageClick(!dosageClick);
    } 
    
    const handleDosageClickDropdown = () => {
        setDosageClickDropdown(false)
    } 

    

    async function createQRCode(event: React.FormEvent<HTMLFormElement>){
        event.preventDefault();
        const url = `http://localhost:8080/api/qrCode/create`;

        if(dosagePerTake !== '' && timePerDay !== '' && expiredDate !== '' && conditionOfUse !== '' && amountOfMeds !== ''){
            
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
                setModalShow(true);
            }
            });
            }
            
        }
    }

    return (
        <div className='d-flex' style={{height:'100vh', width: '100vw', marginRight:'1px'}}>
            {modalShow ? (<div className="modal fade" id="exampleModalCenter"  role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true" style={{fontFamily: "LINESeedSansTHRegular"}}>
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
                            <div ref={componentRef} >
                                <ImageComponent imageID={imageID}  />
                            </div>
                            <div style={{marginLeft: '9.5%'}}>
                            <div className='d-flex gap-1'>
                                <div style={{fontFamily: "LINESeedSansTHBold"}}>
                                    วันที่จ่าย:
                                </div>
                                <div>
                                    12 มกราคม 2566
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
                                Paracetamol
                            </div>
                            <div className="mt-2" style={{fontFamily: "LINESeedSansTHBold"}}>
                                รายละเอียด
                            </div>
                            <hr style={{width:'100%'}}/>
                            <div className='d-flex gap-1'>
                            <div style={{fontFamily: "LINESeedSansTHBold"}}>
                                Paracetamol
                            </div>
                            <div>
                                (จำนวน 10 เม็ด)
                            </div>
                            </div>
                            <div>
                                รับประทานยาหลังอาหารทันที ครั้งละ 1 เม็ด
                            </div>
                            <div>
                                วันละ 2 ครั้ง เช้า เย็น
                            </div>
                            <div className='d-flex gap-1 mt-3'>
                                <div style={{fontFamily: "LINESeedSansTHBold"}}>
                                    วันหมดอายุ:
                                </div>
                                <div>
                                24 เมษายน 2567
                                </div>
                            </div>
                            <div >
                                <div className='mt-3' style={{fontFamily: "LINESeedSansTHBold"}}>
                                    ข้อบ่งใช้
                                </div>
                                <div>
                                    ลดคลื่นไส้อาเจียน
                                </div>
                            </div>
                            <div >
                                <div className='mt-3'style={{fontFamily: "LINESeedSansTHBold"}}>
                                    คำแนะนำเพิ่มเติม
                                </div>
                                <div>
                                    ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที
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
                    content={() => componentRef.current}
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
                                {category}
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
                    <div className='d-flex align-items-center'>
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
                            Paracetamol
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
                                    {dosageClick ? <input type="text" onClick={handleDosageClick} onBlur={handleDosageClick} className="form-control form-control-clicked" placeholder='จำนวน' name="dosagePerTake" required onChange={e => setDosagePerTake(e.target.value)} value={dosagePerTake} style={{width: '9vw', height: '46px', borderRight: 'none', borderTopRightRadius: '0px', borderBottomRightRadius: '0px'}}/>:
                                    <input type="text" onClick={handleDosageClick} onBlur={handleDosageClick} className="form-control" placeholder='จำนวน' name="dosagePerTake" required onChange={e => setDosagePerTake(e.target.value)} value={dosagePerTake} style={{width: '9vw', height: '46px', borderRight: 'none', borderTopRightRadius: '0px', borderBottomRightRadius: '0px'}}/>}
                                    { dosageClick ? 
                                    <div className="dropdown">
                                        <button className="btn onclicked-button" onClick={handleDosageClick} onBlur={handleDosageClick} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" style={{backgroundColor: 'white', width: '5vw', height: '46px', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}}>
                                        <div className='d-flex justify-content-between'>
                                        {unit}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                        </div>
                                        </button>
                                        {dosageClickDropdown ? <ReturnUnit handleUnit={handleUnit} />: <div/>}
                                    </div>:<div className="dropdown">
                                        <button className="btn border border-start-0" onClick={handleDosageClick} onBlur={handleDosageClick} type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" style={{backgroundColor: 'white', width: '5vw', height: '46px', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px'}}>
                                        <div className='d-flex justify-content-between'>
                                        {unit}
                                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                                        </div>
                                        </button>
                                        <ReturnUnit handleUnit={handleUnit}/>
                                    </div>}
                                </div>
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
                                <input type="text" className="form-control" placeholder='จำนวน' aria-label="Text input with dropdown button" name="dosagePerTake" required onChange={e => setTimePerDay(e.target.value)} value={timePerDay}  style={{width: '14vw', height: '46px'}}/>
                            </div>
                        </div>
                        <div className='d-flex justify-content-between align-self-end mt-4'>
                            <div>
                                <label  className="form-label">
                                    <div className='d-flex'>
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            เวลาการรับประทาน
                                        </div>
                                        <div>
                                            *
                                        </div>
                                    </div>
                                </label>
                                <div className="dropdown">
                                    <button className="btn" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown"  style={{backgroundColor: 'white', width: '14vw', height: '46px'}}>
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
                                    <div >
                                        <div style={{fontSize: '16px', color: '#000000'}}>
                                            ทุกๆ
                                        </div>
                                    </div>
                                </label>
                                <div className="dropdown">
                                    <button className="btn" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" style={{backgroundColor: 'white', width: '14vw', height: '46px'}}>
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
                                        {/* <div>
                                            *
                                        </div> */}
                                    </div>
                                </label>
                                <div className="d-flex gap-2" >
                        
                                    {morning ? <button className="btn btn-selected" type="button" onClick={handleMorning} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                                        <div className='d-flex justify-content-center'>
                                                            เช้า
                                                         </div>
                                                </button>:
                                                <button className="btn" type="button" onClick={handleMorning} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                                        <div className='d-flex justify-content-center'>
                                                            เช้า
                                                         </div>
                                                </button>
                                    }
                                    {noon ? <button className="btn btn-selected" type="button" onClick={handleNoon} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                       <div className='d-flex justify-content-center'>
                                         กลางวัน
                                       </div>
                                    </button>:
                                    <button className="btn" type="button" onClick={handleNoon} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                    <div className='d-flex justify-content-center'>
                                      กลางวัน
                                    </div>
                                 </button>}
                                    {evening ? <button className="btn btn-selected" type="button" onClick={handleEvening} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                       <div className='d-flex justify-content-center'>
                                         เย็น
                                       </div>
                                    </button>:<button className="btn" type="button" onClick={handleEvening} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                       <div className='d-flex justify-content-center'>
                                         เย็น
                                       </div>
                                    </button>}
                                    {Bed ? <button className="btn btn-selected" type="button" onClick={handleBed} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
                                       <div className='d-flex justify-content-center'>
                                         ก่อนนอน
                                       </div>
                                    </button>:<button className="btn" type="button" onClick={handleBed} style={{backgroundColor: 'white', width: '4.5vw', height: '50px'}}>
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
                                <input type="text" className="form-control" placeholder='เดือน/วัน/ปี' aria-label="Text input with dropdown button" name="dosagePerTake" required onChange={e => setExpiredDate(e.target.value)} value={expiredDate}  style={{width: '14vw', height: '46px'}}/>
                            </div>
                        </div>

                        <div className='d-flex justify-content-start align-self-end mt-4'>
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
                                    <button className="btn" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false" style={{backgroundColor: 'white', width: '39vw', height:'46px'}}>
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
                                <input type="text" className="form-control" placeholder='จำนวนยา' aria-label="Text input with dropdown button" name="dosagePerTake" required onChange={e => setAmountOfMeds(e.target.value)} value={amountOfMeds}  style={{width: '14vw', height: '46px'}}/>
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