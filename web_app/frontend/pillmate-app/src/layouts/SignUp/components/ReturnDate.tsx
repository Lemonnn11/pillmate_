import React from "react";

export interface ReturnDateProps {
    handleDate: (value: string) => void;
}

export const ReturnDate: React.FC<ReturnDateProps> = (props) => {
    const dates = [
         'จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์' ,'เสาร์','อาทิตย์'
      ];
    return (
        <ul className="dropdown-menu">
        {dates.map((date, index) => (
        <li key={index} onClick={() => props.handleDate(date)}>
          <div className="dropdown-item col">{date}</div>
        </li>
      ))}
    </ul>
    );
}