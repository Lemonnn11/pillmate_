import React from "react";

export interface ReturnTimeProps {
    handleTime: (value: string) => void;
}

export const ReturnTime: React.FC<ReturnTimeProps> = (props) => {
    const times = [
        '00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00',
        '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00',
        '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00', '24:00'
      ];
    return (
        <ul className="dropdown-menu" style={{ maxHeight: '300px', overflowY: 'auto' }}>
        {times.map((time, index) => (
        <li key={index} onClick={() => props.handleTime(time)}>
          <div className="dropdown-item col">{time}</div>
        </li>
      ))}
    </ul>
    );
}