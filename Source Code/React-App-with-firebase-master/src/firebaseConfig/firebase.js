// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore } from 'firebase/firestore';

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyD3e0fFZnRzrILIgLvX5Z8U6_2mcUAK7QE",
  authDomain: "laptopharbor-97b44.firebaseapp.com",
  projectId: "laptopharbor-97b44",
  storageBucket: "laptopharbor-97b44.firebasestorage.app",
  messagingSenderId: "484062572276",
  appId: "1:484062572276:web:0da97ca9e0722d7ba6f8a1",
  measurementId: "G-8Z8BJDG8GQ"
};
// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const db = getFirestore(app);

export {db};
export default app;