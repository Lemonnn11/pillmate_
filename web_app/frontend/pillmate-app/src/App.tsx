import React from 'react';
import './App.css';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import { GenerateQRCode } from './layouts/GenerateQRCode/GenerateQRCode';
import { RegisterPharmacy } from './layouts/RegisterPharmacy/RegisterPharmacy';
import { initializeApp } from 'firebase/app';
import { config } from './config/config';
import { Login } from './layouts/login/login';
import { SignUp } from './layouts/SignUp/SignUp';
import { Homepage } from './layouts/Homepage/Homepage';


initializeApp(config.firebaseConfig);

function App() {
  return (
    <Router>
      <div>
        <Switch>
          <Route path={"/"} exact>
            <Homepage />
          </Route>
          <Route path={"/generateQRCode"}>
            <GenerateQRCode/>
          </Route>
          <Route path={"/login"}>
            <Login/>
          </Route>
          <Route path={"/signup"}>
            <SignUp/>
          </Route>
          <Route path={"/registerPharmacy"}>
            <RegisterPharmacy/>
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
