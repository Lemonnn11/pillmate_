export interface ReturnSubdistrictProps {
    handleSubdistrict: (value: string) => void;
    subdistricts: string[];
}

export const ReturnSubdistrict: React.FC<ReturnSubdistrictProps> = (props) => {
    return(
        <ul className="dropdown-menu"  style={{ maxHeight: '300px', overflowY: 'auto' }}>
            {props.subdistricts.map((subdistrict, index) => (
              <li key={index} onClick={() => props.handleSubdistrict(subdistrict)}>
                <div className="dropdown-item col">{subdistrict}</div>
              </li>
            ))}
        </ul>
    );
}