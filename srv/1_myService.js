//nomeFileService.js deve essere uguale a nomeFileService.cds altrimenti il compilatore andrà in errore.

const myService = function(service)
{
    service.on("myFunction", (req, res) => {
        return "Welcome" + req.data.msg;
    });
}

//Serve per esportare la costante che ha al suo interno una funzione in altri file .js
module.exports = myService;