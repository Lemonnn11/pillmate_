import React from "react";

export interface ReturnTakemedWhenProps {
    handleTakeMedWhen: (value: string) => void;
}

export const ReturnTakemedWhen: React.FC<ReturnTakemedWhenProps> = (props) => {
    const whens = [
        'ทานเมื่อมีอาการ',
        'หลังอาหาร',
        'ก่อนอาหาร',
        'หลังอาหารทันที',
        'เวลา',
        'พร้อมอาหาร',
        '...'
      ];
    return (
        <ul className="dropdown-menu">
        {whens.map((when, index) => (
        <li key={index} onClick={() => props.handleTakeMedWhen(when)}>
          <div className="dropdown-item col">{when}</div>
        </li>
      ))}
    </ul>
    );
}