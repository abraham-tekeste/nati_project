const { onRequest, onCall } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");

const { setGlobalOptions } = require("firebase-functions/v2");
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.callableFun = onCall((request) => {
  // logger.info("Hello logs!", { structuredData: true });
  return "Hello from Firebase!";
});

exports.onProductChange = functions.firestore
  .document("products/{productId}")
  .onWrite((change, context) => {
    console.log("Product has changed");

    console.log("Product ID: ", context.params.productId);
  });
