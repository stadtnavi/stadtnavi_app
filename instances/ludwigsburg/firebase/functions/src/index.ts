import * as functions from "firebase-functions";

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const onStartNotifications = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    const notification: {
        id:string
        title: string
        body: string
    } = { 
        id:"001",
        title: `Herzlich willkommen in Ludwigsburg!`, 
        body: `Durch zahlreiche Veranstaltungen am Wochenende rechnen wir mit einem erhöhten Verkehrsaufkommen.

        Nutzen Sie nach Möglichkeit die öffentlichen Verkehrsmittel oder das Fahrrad. Am Sonntag zwischen 13:00 und 18:00 Uhr wird der Bus-Takt für Sie verdichtet.
        
        Falls Sie mit dem Auto anreisen, finden Sie in der App zahlreiche ausgewiesene Parkmöglichkeiten.
        
         
        
        Wir freuen uns auf Ihren Besuch!
        onStartTest
        `
     }
     const data={notifications:[notification]}
    response.send(data);
});
