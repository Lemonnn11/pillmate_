import { FormEvent, useEffect, useState } from 'react';
import { getAuth, signInWithEmailAndPassword} from 'firebase/auth';
import { useHistory } from 'react-router-dom';
import { IoCloseCircleOutline } from 'react-icons/io5';

export const Login = () => {
    const auth = getAuth();
    const history = useHistory();
    const [ email, setEmail ] = useState('');
    const [ password, setPassword ] = useState('');
    const [ showIncorrect, setShowIncorrect ] = useState(false);
    const [ showTooManyAttemps, setShowTooManyAttemps] = useState(false);

    const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
        event.preventDefault()
  
        try {
          const userCredential = await signInWithEmailAndPassword(auth, email, password);
  
          if (userCredential) {
            history.push("/")
          }
        } catch (error:any) {
            console.log(error.message);
            if(error.message === 'Firebase: Error (auth/invalid-credential).'){
                console.log(error.message);
                setShowIncorrect(true);
                setShowTooManyAttemps(false);
            }
            else if(error.message === 'Firebase: Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later. (auth/too-many-requests).'){
                setShowTooManyAttemps(true);
                setShowIncorrect(false);
            }
        }
    };

    const handleClick = () => {
        history.push('/signup');
    }

    return(
        <div className='d-flex justify-content-between' style={{height:'90vh', width: '100vw'}}>
            <div style={{marginLeft:'10%', marginRight:'4%', marginTop:'5%', height:'100%'}}>
                <div>
                <img src={process.env.PUBLIC_URL + '/images/Logo.png'} style={{width:'186px', height:'32px'}}/>
                </div>
                <div className='mt-5' style={{fontSize: '24px', fontFamily: "LINESeedSansTHBold"}}>
                    Hi there!
                </div>
                <div className='mt-3' style={{fontSize: '14px', fontFamily: "LINESeedSansTHRegular"}}>
                    Please login to continue to your account
                </div>
                <form onSubmit={handleSubmit}>
                    <div className='mt-3'>
                        <label className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    Email
                                </div>
                                <div>
                                    *
                                </div>
                            </div>
                        </label>
                        <input type="email" className="form-control"  name="email" required onChange={e => setEmail(e.target.value)} value={email}  style={{width: '25vw', height: '49px'}}/>
                    </div >
                    <div className='mt-3'>
                        <label  className="form-label" style={{fontFamily: 'LINESeedSansENRegular'}}>
                            <div className='d-flex'>
                                <div style={{fontSize: '16px', color: '#000000'}}>
                                    Password
                                </div>
                                <div>
                                    *
                                </div>
                            </div>
                        </label>
                        <input type="password" className="form-control" name="password" required onChange={e => setPassword(e.target.value)} value={password}  style={{width: '25vw', height: '49px'}}/>
                    </div>
                    <div className='mt-3'>
                        { showIncorrect ? (<div className='d-flex gap-1 align-items-center mt-2'><div className='d-flex align-items-center'><IoCloseCircleOutline color='red'/></div><div style={{color: 'red', fontSize: '14px',fontFamily:'LINESeedSansENRegular'}}>Incorrect Email or Password</div></div>): showTooManyAttemps ? (<div style={{color: 'red'}}>
                            You've made too many recent attempts. Please try again later.
                        </div>): (<div></div>)}
                    </div>
                    <div className="mt-2"style={{marginLeft:'-2%'}}>
                        <button type="button" className="btn btn-link" style={{color:'black'}}>Forgot my password</button>
                    </div>
                    <button className="btn mt-2" type="submit" style={{ width: '25vw', backgroundColor: '#059E78', height: '49px'}}>
                        <div className='d-flex justify-content-center' style={{fontFamily: "LINESeedSansENBold", color: "white"}}>
                            Log in
                        </div>
                    </button>
                </form>
                <div className="d-flex align-items-end gap-2" style={{height:'5%'}}>
                    <div style={{fontFamily: 'LINESeedSansENRegular', fontSize: '16px'}}>
                        Don’t have an account?
                    </div>
                    <div onClick={handleClick} style={{color:'#059E78', fontSize:'16px', fontFamily: 'LINESeedSansENBold', textDecoration:'underline', cursor:'pointer'}}> 
                        Sign up
                    </div>
                </div>
            </div>
            <div className='d-flex justify-content-end align-items-end' style={{backgroundColor: '#059E78', height: '100vh', width: '50vw'}}>
                <img src={process.env.PUBLIC_URL + '/images/login_right.png'} style={{width: '42VW', height: '90vh'}}/>
            </div>
        </div>
    );
}