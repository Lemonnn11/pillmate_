import { useState } from "react";
import DrugModel from "../../../models/Drug";
import { useHistory } from "react-router-dom";

export interface ReturnDrugProps {
    drug: DrugModel;
}



export const ReturnDrug: React.FC<ReturnDrugProps> = (props) => {
    const history = useHistory();

    const handleClick = () => {
        history.push({ 
            pathname: "/generateQRCode", 
            state: {
            tradeName: props.drug.tradeName,
            genericName: props.drug.genericName,
            // containers: props.drug.containers,
            dosageForm: props.drug.dosageForm,
            category: props.drug.category,
        }});
    }

    return(
        <tr className='align-middle tablerow'>
            <td style={{paddingTop: '1.75%', paddingBottom: '1.75%',paddingLeft: '1.5%'}}>
                <div style={{fontFamily: 'LINESeedSansENBold', fontSize: '14px'}}>
                    {props.drug.id}
                </div>
            </td>
            <td style={{paddingTop: '1.5%', paddingBottom: '1.5%', width: '30%'}}>
                <div style={{fontFamily: 'LINESeedSansENRegular', fontSize: '14px'}}>
                    {props.drug.tradeName}
                </div>
            </td>
            <td style={{paddingTop: '1.5%', paddingBottom: '1.5%', width: '30%'}}>
                <div style={{fontFamily: 'LINESeedSansENRegular', fontSize: '14px'}}>
                    {props.drug.genericName}
                </div>
            </td>
            <td >
                <div className="d-flex gap-2">
                <div style={{fontFamily: 'LINESeedSansENRegular', fontSize: '14px', backgroundColor: '#DFDFDF', paddingLeft: '2.5%', paddingRight: '2.5%', paddingTop: '1.5%', paddingBottom: '1.5%', borderRadius: '24px'}}>
                    Container N/A
                </div>
                <div style={{fontFamily: 'LINESeedSansENRegular', fontSize: '14px', backgroundColor: '#DFDFDF',  paddingLeft: '2.5%', paddingRight: '2.5%', paddingTop: '1.5%', paddingBottom: '1.5%', borderRadius: '24px'}}>
                    Storage N/A
                </div>
                </div>
            </td>
            <td>
                <button className="btn" onClick={handleClick} style={{backgroundColor:'#1AB48D', height:'38px'}}>
                    <div style={{fontFamily: 'LINESeedSansENBold', fontSize: '14px', color:'white'}}>
                        Generate QR
                    </div>
                </button>
            </td>
        </tr>
    );
}