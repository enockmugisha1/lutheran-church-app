importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBg-y23QscE4b_P2d4jHTDOXjdMxSYQ85E",
  appId: "1:185206347788:web:9e50ff9855fd45376b3629",
  messagingSenderId: "185206347788",
  projectId: "lutheran-church-app-b6da5",
  authDomain: "lutheran-church-app-b6da5.firebaseapp.com",
  storageBucket: "lutheran-church-app-b6da5.firebasestorage.app",
  measurementId: "G-F0TQGKDENH",
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((message) => {
  console.log("[firebase-messaging-sw.js] Background message:", message);
});
