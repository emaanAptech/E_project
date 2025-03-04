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
  apiKey: "AIzaSyCtaTc_7V0EmRFlLCbL4Sh4RGYl9M7pr7M",
  authDomain: "laptopharbor-9861c.firebaseapp.com",
  projectId: "laptopharbor-9861c",
  storageBucket: "laptopharbor-9861c.firebasestorage.app",
  messagingSenderId: "282887394151",
  appId: "1:282887394151:web:51633c1afa0004962e95c2",
  measurementId: "G-3WS3X13KSJ"
};
// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const db = getFirestore(app);

export {db};
export default app;