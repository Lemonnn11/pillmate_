import React from "react";

export interface ReturnEveryProps {
    handleEvery: (value: string) => void;
}

export const ReturnEvery: React.FC<ReturnEveryProps> = (props) => {
    const whens = [
        '4 ชั่วโมง',
        '6 ชั่วโมง',
        '8 ชั่วโมง',
        '12 ชั่วโมง',
        '...'
      ];
    return (
        <ul className="dropdown-menu">
        {whens.map((when, index) => (
        <li key={index} onClick={() => props.handleEvery(when)}>
          <div className="dropdown-item col">{when}</div>
        </li>
      ))}
    </ul>
    );
}