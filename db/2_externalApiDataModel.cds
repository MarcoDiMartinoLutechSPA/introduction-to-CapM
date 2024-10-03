//Questo file conterrà i campi dell' Api esterna https://jsonplaceholder.typicode.com/posts

namespace italy.db;

//l' entity deve contenere gli stessi campi che possiede l' API esterna sottoforma di JSON

entity externalData 
{
    userId : Integer;
    key id : Integer;
    title : String(50);
    body : String(100);
}