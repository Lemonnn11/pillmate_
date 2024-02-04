export const Pagination: React.FC<{currentPage: number, totalPages: number, paginate: any}> = (props) => {


    const pageNumbers: number[] = [];

    if(props.currentPage === 1){
        pageNumbers.push(props.currentPage);
        if(props.totalPages >= props.currentPage + 1){
            pageNumbers.push(props.currentPage + 1);
        }
        if(props.totalPages >= props.currentPage + 2){
            pageNumbers.push(props.currentPage + 2);
        }
    }else if(props.currentPage > 1){
        if(props.currentPage >= 3){
            pageNumbers.push(props.currentPage - 2);
            pageNumbers.push(props.currentPage - 1);
        }else{
            pageNumbers.push(props.currentPage - 1);
        }
        pageNumbers.push(props.currentPage);

        if(props.totalPages >= props.currentPage + 1){
            pageNumbers.push(props.currentPage + 1);
        }
        if(props.totalPages >= props.currentPage + 2){
            pageNumbers.push(props.currentPage + 2);
        }
    }


    return (
        <nav aria-label="...">
            <ul className="pagination">
                {props.currentPage === 1 ? <li className='page-item disabled'>
                <a className="page-link">Previous</a>
                </li>: <li className='page-item' onClick={() => props.paginate(props.currentPage - 1)}>
                <a className="page-link">Previous</a>
                </li>}
                {pageNumbers.map(number => (
                    <li key={number} onClick={() => props.paginate(number)} className={'page-item ' + (props.currentPage === number? 'active': '')}>
                        <button className="page-link">
                            {number}
                        </button>
                    </li>
                ))}
                {props.currentPage === props.totalPages  ? <li className='page-item disabled'>
                <a className="page-link">Next</a>
                </li>: <li className='page-item' onClick={() => props.paginate(props.currentPage + 1)}>
                <a className="page-link">Next</a>
                </li>}
            </ul>
        </nav>
        
    );

}