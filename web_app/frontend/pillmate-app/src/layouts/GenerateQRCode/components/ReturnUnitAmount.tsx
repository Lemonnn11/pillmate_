import React from "react";

export interface ReturnUnitProps {
    handleUnitAmount: (value: string) => void;
}

export const ReturnUnitAmount: React.FC<ReturnUnitProps> = (props) => {
    const units = [
        'แคปซูล',
        'เม็ด',
        'ml.',
      ];
    return (
        <ul className="dropdown-menu">
        {units.map((unit, index) => (
        <li key={index} onClick={() => props.handleUnitAmount(unit)}>
          <div className="dropdown-item col">{unit}</div>
        </li>
      ))}
    </ul>
    );
}