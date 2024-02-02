export interface ReturnDistrictProps {
    handleDistrict: (value: string) => void;
    districts: string[];
}

export const ReturnDistrict: React.FC<ReturnDistrictProps> = (props) => {
    return(
        <ul className="dropdown-menu"  style={{ maxHeight: '300px', overflowY: 'auto' }}>
            {props.districts.map((district, index) => (
              <li key={index} onClick={() => props.handleDistrict(district)}>
                <div className="dropdown-item col">{district}</div>
              </li>
            ))}
        </ul>
    );
}