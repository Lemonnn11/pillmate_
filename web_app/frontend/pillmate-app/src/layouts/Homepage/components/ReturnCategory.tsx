export interface ReturnCategoryProps {
    category: string;
    handleCategory: (value: string) => void; 
}

export const ReturnCategory: React.FC<ReturnCategoryProps> = (props) => {
    return (
        <li key={props.category} onClick={() => props.handleCategory(`${props.category}`)}>
            <a className="dropdown-item col" href="#">{props.category}</a>
        </li>
    );
}