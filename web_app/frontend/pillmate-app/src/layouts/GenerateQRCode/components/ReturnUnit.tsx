import React from "react";

export interface ReturnUnitProps {
    handleUnit: (value: string) => void;
}

export const ReturnUnit: React.FC<ReturnUnitProps> = (props) => {
    const units = [
        'แคปซูล',
        'ช้อน',
        'เม็ด'
      ];
    return (
        <ul className="dropdown-menu">
        {units.map((unit, index) => (
        <li key={index} onClick={() => props.handleUnit(unit)}>
          <div className="dropdown-item col">{unit}</div>
        </li>
      ))}
    </ul>
    );
}

