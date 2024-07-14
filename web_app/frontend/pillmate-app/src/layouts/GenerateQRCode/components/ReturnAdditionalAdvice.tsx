import React from "react";

export interface ReturnAdditionalAdviceProps {
    handleAdditionalAdvice: (value: string) => void;
}

export const ReturnAdditionalAdvice: React.FC<ReturnAdditionalAdviceProps> = (props) => {
    const advices = [
        'ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที',
        'ยานี้อาจทำให้เกิดอาการง่วงซึมจึงไม่ควรขับขี่ยานยนต์ หรือทำงานเกี่ยวกับเครื่องจักรกล',
        'กินยานี้แล้วดื่มน้ำตามมากๆ',
        'ยาฆ่าเชื้อควรรับประทานติดต่อกันให้หมด',
        '-'
      ];
    return (
        <ul className="dropdown-menu">
        {advices.map((advice, index) => (
        <li key={index} onClick={() => props.handleAdditionalAdvice(advice)}>
          <div className="dropdown-item col">{advice}</div>
        </li>
      ))}
    </ul>
    );
}