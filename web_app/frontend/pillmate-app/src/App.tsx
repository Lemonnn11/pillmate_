import React from 'react';
import './App.css';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import { GenerateQRCode } from './layouts/GenerateQRCode/GenerateQRCode';

function App() {
  return (
    <Router>
      <div>
        <Switch>
          <Route path={"/generateQRCode"}>
            <GenerateQRCode/>
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
