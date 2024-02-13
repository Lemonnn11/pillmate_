import { useEffect, useState } from "react";
import { IoIosArrowDown } from "react-icons/io";
import { ReturnDrug } from "./components/ReturnDrug";
import DrugModel from "../../models/Drug";
import { getAuth, onAuthStateChanged, signOut } from "firebase/auth";
import { useHistory } from "react-router-dom";
import { error } from "console";
import { Pagination } from "../../Utils/Pagination";
import { ReturnCategory } from "./components/ReturnCategory";

export const Homepage = () => {

    const history = useHistory();
    const [drugs, setDrugs] = useState<DrugModel[]>([]) 
    const auth = getAuth();
    const [httpError, setHttpError] = useState(null);
    const [currentPage, setCurrentPage] = useState(1);
    const [drugsPerPage] = useState(20);
    const [totalDrugs, setTotalDrugs] = useState(0);
    const [totalPages, setTotalPages] = useState(0);
    const [query, setQuery] = useState('');
    const [queryUrl, setQueryUrl] = useState('');
    const [categories, setCategories] = useState<string[]>([]);
    const [categoryValue, setCategoryValue] = useState('Add filter');
    const [email, setEmail] = useState('');

    useEffect(() => {
        authCheck();
        return () => authCheck();
    }, [auth]);

    useEffect(() => {
        const fetchDrugs = async () => {
            
            let url: string = ''

            if(queryUrl === ''){
                url = `http://localhost:8080/api/drug/?page=${currentPage - 1}&size=${drugsPerPage}`;
            }else{
                url = `http://localhost:8080/api/drug/get-drugs?page=${currentPage - 1}&size=${drugsPerPage}` + queryUrl ;
            }

            const response = await fetch(url);

            if(!response.ok){
                throw new Error('Error found');
            }
            const responseJson = await response.json();

            setTotalDrugs(responseJson.totalDrugs);
            setTotalPages(responseJson.totalPages);

            const loadedDrug: DrugModel[] = [];

            for(let key in responseJson.drugs){
                const drug = new DrugModel(
                    responseJson.drugs[key].id,
                    responseJson.drugs[key].tradeName,
                    responseJson.drugs[key].genericName,
                    responseJson.drugs[key].dosageForm,
                    responseJson.drugs[key].category,
                    responseJson.drugs[key].protectedFromLight,
                    responseJson.drugs[key].imgSource,
                );

                loadedDrug.push(drug);
            }

            setDrugs(loadedDrug)
        };
        fetchDrugs().catch((error: any)=> {
            setHttpError(error.message);
        })
        // window.scrollTo(0,0); 
    }, [currentPage, queryUrl]);

    useEffect(() => {
        const fetchCategory = async () => {
            
            let url: string = `http://localhost:8080/api/drug/get-categories`;

            const response = await fetch(url);

            if(!response.ok){
                throw new Error('Error found');
            }
            const responseJson = await response.json();


            const loadedCategory: string[] = [];

            for(let key in responseJson.categories){

                loadedCategory.push(responseJson.categories[key]);
            }

            setCategories(loadedCategory)
        };
        fetchCategory().catch((error: any)=> {
            setHttpError(error.message);
        })
    });

    if(httpError){
        return(
            <div className="container m-5">
                <p>{httpError}</p>
            </div>
        )
    }

    const authCheck = onAuthStateChanged(auth, (user) => {
        if(!user){
            history.push('/login');
        }else{

        }
    });

    const paginate = (pageNumber: number) => setCurrentPage(pageNumber);

    const handleQuery = () => {
        if (query === '') {
          setQueryUrl('');
        } else {
          setQueryUrl(`&query=${query}&`);
        }
      };

    const handleCategory = (value: string) => {
        setCategoryValue(value);
        setQueryUrl(`&query=${value}&`);
    } 

      const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
        if (e.key === 'Enter') {
          handleQuery();
        }
      };

      const handleMyProfile = () => {
        history.push("/edit-pharmacy");
      }

      const handleLogout = () => {
        signOut(auth).then(() => {
            history.push("/login");
        })
      }

    return(
        <div className="d-flex">
            <div style={{width: '20vw', height: '100vw', paddingTop: '3%', background: 'white'}}>
                <div className="d-flex align-items-center justify-content-between">
                    <img src={process.env.PUBLIC_URL + '/images/pillmatew.png'} style={{width:'129px', height:'58px', marginLeft: '10%'}}/>
                    <img src={process.env.PUBLIC_URL + '/images/hamburgermenu.png'} style={{width:'40px', height:'40px',marginRight: '10%',}}/>
                </div>
                <div className="mt-4"style={{fontFamily: 'LINESeedSansENRegular', fontSize: '16px', color: '#757575', marginLeft: '10%'}}>
                    Main menu
                </div>
                <div className="d-flex justify-content-start mt-3 align-items-end">
                    <img src={process.env.PUBLIC_URL + '/images/solar_document-medicine-outline.png'} style={{width:'24px', height:'24px', marginLeft: '10%'}}/>
                    <div className="mt-4"style={{fontFamily: 'LINESeedSansENBold', fontSize: '16px', color: '#1AB48D', marginLeft: '5%'}}>
                        Drug list
                    </div>
                </div>
            </div>
            <div style={{width: '80vw', height: '100vw', paddingTop: '3.1%',background: '#F6F6F6', paddingLeft: '5%', paddingRight: '5%'}}>
                <div className="d-flex align-items-center justify-content-between">
                    <div>
                        <div style={{fontFamily: 'LINESeedSansENBold', fontSize: '32px'}}>
                            Drug list
                        </div>
                        <div className="mt-1"style={{fontFamily: 'LINESeedSansENRegular', fontSize: '14px', color:'#2C2C2C'}}>
                            100 drugs found
                        </div>
                    </div>
                    <div className="dropdown">
                        <button className="btn" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown">
                            <div className='d-flex justify-content-around align-items-center gap-2'>
                                <img src={process.env.PUBLIC_URL + '/images/lemon.jpg'} style={{width:'55px', height:'55px', borderRadius: '50%', verticalAlign: 'middle'}}/>
                                <IoIosArrowDown size={20} color='#8A8A8A' className='mt-1'/>
                            </div>
                        </button>
                        <ul className="dropdown-menu dropdown-menu-end">
                            <li key={"myprofile"}><a className="dropdown-item" href="#" onClick={handleMyProfile}>My profile</a></li>
                            <li key={"logout"}><a className="dropdown-item" href="#" onClick={handleLogout}>Logout</a></li>
                        </ul>
                    </div>
                </div>
                <div className="d-flex mt-4">
                <div className="dropdown">
                    <button className="btn" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown"  style={{backgroundColor: 'white', width: '8vw', height: '53px', borderTopRightRadius: '0px', borderBottomRightRadius: '0px'}}>
                        <div className='d-flex justify-content-around'>
                            <div style={{fontFamily: 'LINESeedSansENRegular', fontSize: '14px', color:'black',  whiteSpace: 'nowrap', overflow: 'hidden'}}>
                                {categoryValue}
                            </div>
                        <IoIosArrowDown size={14} color='#2C2C2C' className='mt-1'/>
                        </div>
                    </button>  
                    <ul className="dropdown-menu" style={{ maxHeight: '300px', overflowY: 'auto' }}>
                        {categories.slice(0, categories.length).map(category => (
                            <ReturnCategory category={category} handleCategory={handleCategory}/>
                        ))}
                    </ul>      
                </div>
                <input type="text" className="form-control" placeholder='Search...' name="dosagePerTake" required onChange={e => setQuery(e.target.value)} value={query} onKeyPress={handleKeyPress} style={{width: '90vw', height: '53px', border: 'none', borderTopLeftRadius: '0px', borderBottomLeftRadius: '0px', backgroundColor: '#EEEEEE', paddingLeft: '2%'}}/>
            </div>
            <div className="mt-4">
            <table className='table'>
                    <thead className="text-start" style={{backgroundColor: 'white'}}>
                        <tr style={{fontFamily: 'LINESeedSansENBold'}}>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%', paddingLeft: '1.5%'}}>id</th>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%'}}>Trade name</th>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%'}}>Generic name</th>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%'}}>Containers</th>
                            <th scope='col' style={{paddingTop: '1%', paddingBottom: '1%'}}></th>
                    
                        </tr>
                    </thead>
                    <tbody className="text-start">
                        {drugs.slice(0, drugs.length).map(drug => (
                            <ReturnDrug drug={drug}/>
                        ))}
                    </tbody>
                </table>
            </div>
                {totalPages > 1 && <Pagination currentPage={currentPage} totalPages={totalPages} paginate={paginate}/>}
            </div>
            
        </div>
    );
}