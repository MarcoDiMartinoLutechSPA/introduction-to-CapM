//keyword service nomeServizio senza estensione
service myService 
{
    //restituisce una stringa tramite una chiamata alla funzione myFunction
    //keyword function -> nomeFunzione(nomeParametro: tipoParametro) -> keyword retuns -> tipoRestituito
    function myFunction(msg: String) returns String
}