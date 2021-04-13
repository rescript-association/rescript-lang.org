// import App from 'next/app'


//function MyApp({ Component, pageProps }) {
  //console.log(pageProps);
  //return <Component {...pageProps} />
//}

import "styles/main.css";
import {make as ResApp} from "src/common/App.js";

export default function App(props) {
  return <ResApp {...props} />
};
