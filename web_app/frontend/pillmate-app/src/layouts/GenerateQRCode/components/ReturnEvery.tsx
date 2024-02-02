import React from "react";

export interface ReturnEveryProps {
    handleEvery: (value: string) => void;
}

export const ReturnEvery: React.FC<ReturnEveryProps> = (props) => {
    const whens = [
        '4',
        '6',
        '8',
        '12'
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