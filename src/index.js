import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

Elm.Main.init({
  node: document.getElementById('root'),
  flags: {
    charBurnerIndex: getRandomInt(4)
  }
});
// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
