import fr.epardaud.net { URI }
import fr.epardaud.net.http { ... }
import fr.epardaud.test { ... }
import fr.epardaud.json { ... }

void testJSON(Object json){
    assertEquals(26, json.size, "Object size");
    assertEquals("http://ceylon-lang.org", json.get("homepage"), "Homepage");
    
    if(is Object owner = json.get("owner")){
        assertEquals("ceylon", owner.get("login"), "Owner name");
    }else{
        fail("owner is not Object");
    }
}

void testGET(){
    value request = URI("https://api.github.com/repos/ceylon/ceylon-compiler").get();
    value response = request.execute();
    assertTrue(nonempty response.contents, "Has contents");

    Object json = parse(response.contents);
    testJSON(json);    
}

void testGETJSON(){
    Object json = URI("https://api.github.com/repos/ceylon/ceylon-compiler").get().getJSON();
    testJSON(json);    
}

void testConnectionAll(){
    test(testGET, "GET test", null);
    test(testGETJSON, "GETJSON test", null);
    
    printResults();
}
