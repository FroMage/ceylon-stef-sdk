by "Stéphane Épardaud"
doc "Represents an HTTP Header"
shared class Header(String name, String contents){
    
    doc "Header name"
    shared String name = name;
    
    doc "Header value"
    shared String contents = contents;
}