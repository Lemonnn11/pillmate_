import React from 'react';
import './App.css';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import { GenerateQRCode } from './layouts/GenerateQRCode/GenerateQRCode';
import { initializeApp } from 'firebase/app';
import { config } from './config/config';
import { Login } from './layouts/login/login';
import { SignUp } from './layouts/SignUp/SignUp';
import { Homepage } from './layouts/Homepage/Homepage';
import { EditPharmacy } from './layouts/EditPharmacyInfo/EditPharmacy';


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
          <Route path={"/edit-pharmacy"}>
            <EditPharmacy/>
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
