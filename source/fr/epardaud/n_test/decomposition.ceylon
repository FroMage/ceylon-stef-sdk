import fr.epardaud.net { Parameter, URI, percentEncoder, Path, PathSegment, ... }
import fr.epardaud.test { ... }

void testURL(String url, 
            String? scheme = null,
            String? user = null,
            String? pass = null,
            String? host = null,
            Boolean ipLiteral = false,
            Integer? port = null,
            String? path = null,
            Path? decomposedPath = null,
            String? query = null,
            Query? decomposedQuery = null,
            String? fragment = null){
    URI u = URI(url);
    assertEquals(scheme, u.scheme, "Scheme "+url);
    assertEquals(user, u.authority.user, "User "+url);
    assertEquals(pass, u.authority.password, "Password "+url);
    assertEquals(host, u.authority.host, "Host "+url);
    assertEquals(ipLiteral, u.authority.ipLiteral, "IP-Literal "+url);
    assertEquals(port, u.authority.port, "Port "+url);
    assertEquals(path else "", u.pathPart, "Path "+url);
    if(exists decomposedPath){
        assertEquals(decomposedPath, u.path, "Decomposed Path "+url);
    } 
    assertEquals(query, u.queryPart, "Query "+url);
    assertEquals(fragment, u.fragment, "Fragment "+url);
    if(exists decomposedQuery){
        assertEquals(decomposedQuery, u.query, "Decomposed Query "+url);
    } 
    
    assertEquals(url, u.string, "String "+url);
}

void testDecomposition(){
    testURL{ 
        url = "http://user:pass@www.foo.com:80/path/to;param1;param2=foo/file.html?foo=bar&foo=gee&bar#anchor";
        scheme = "http";
        user = "user";
        pass = "pass";
        host = "www.foo.com";
        port = 80;
        path = "/path/to;param1;param2=foo/file.html";
        query = "foo=bar&foo=gee&bar";
        fragment = "anchor";
    };
    testURL{ 
        url = "http://host";
        scheme = "http";
        host = "host";
    };
    testURL{ 
        url = "http://host/";
        scheme = "http";
        host = "host";
        path = "/";
    };
    testURL{ 
        url = "http://host?foo";
        scheme = "http";
        host = "host";
        query = "foo";
    };
    testURL{ 
        url = "http://host#foo";
        scheme = "http";
        host = "host";
        fragment = "foo";
    };
    testURL{ 
        url = "http://user@host";
        scheme = "http";
        user = "user";
        host = "host";
    };
    testURL{ 
        url = "http://host:80";
        scheme = "http";
        host = "host";
        port = 80;
    };
    testURL{ 
        url = "file:///no/host";
        scheme = "file";
        host = "";
        path = "/no/host";
    };
    testURL{ 
        url = "file:///";
        scheme = "file";
        host = "";
        path = "/";
    };
    testURL{ 
        url = "mailto:stef@epardaud.fr";
        scheme = "mailto";
        path = "stef@epardaud.fr";
    };
    testURL{ 
        url = "//host/file";
        host = "host";
        path = "/file";
    };
    testURL{ 
        url = "/path/somewhere";
        path = "/path/somewhere";
    };
    testURL{ 
        url = "someFile";
        path = "someFile";
    };
    testURL{ 
        url = "?query";
        query = "query";
    };
    testURL{ 
        url = "#anchor";
        fragment = "anchor";
    };
    testURL{ 
        url = "http://192.168.1.1:80";
        scheme = "http";
        host = "192.168.1.1";
        port = 80;
    };
    testURL{ 
        url = "http://[::1]:80";
        scheme = "http";
        host = "::1";
        port = 80;
        ipLiteral = true;
    };
    testURL{
        url = "http://[2001:5c0:1105:6d01:22cf:30ff:fe32:f8e2]:80";
        scheme = "http";
        host = "2001:5c0:1105:6d01:22cf:30ff:fe32:f8e2";
        port = 80;
        ipLiteral = true;
    };
}

void testComposition(){
    URI u = URI();
    u.scheme := "http";
    u.authority.host := "192.168.1.1";
    u.authority.port := 9000;
    u.authority.user := "stef";
    u.path.absolute := true;
    u.path.add("a");
    u.path.add("b", Parameter("c"), Parameter("d", "e"));
    u.query.add(Parameter("q"));
    u.query.add(Parameter("r","s"));
    testURL{
        url = u.string;
        scheme = "http";
        host = "192.168.1.1";
        port = 9000;
        user = "stef";
        path = "/a/b;c;d=e";
        query = "q&r=s";
    };
}

void testInvalidPort(){
    URI("http://foo:bar");
}

void testInvalidPort2(){
    URI("http://foo:-23");
}

void testDecoding(){
    /*
%3D%23ue/segment2?par%26%3D%23am3&par%26%3D%23am4=val%26%3D%23ue2#frag%26%3D%23ment
  =%23ue/segment2?par%26%3D%23am3&par%26%3D%23am4=val%26%3D%23ue2#frag&=%23ment
*/
    testURL{
        url = "http://us%3Aer:pa%3A%40ss@ho%3Ast:123/segm%2F%3F%3Bent1;par%2F%3F%3B%3Dam1;par%2F%3F%3B%3Dam2=val%2F%3F%3B=%23ue/segment2?par%26%3D%23am3&par%26%3D%23am4=val%26%3D%23ue2#frag&=%23ment";
        scheme = "http";
        user = "us:er";
        pass = "pa:@ss";
        host = "ho:st";
        port = 123;
//        path = "/segm/?;ent1;par/?;=am1;par/?;=am2=val/?;=#ue/segment2";
        path = "/segm%2F%3F%3Bent1;par%2F%3F%3B%3Dam1;par%2F%3F%3B%3Dam2=val%2F%3F%3B=%23ue/segment2";
        decomposedPath = Path {
            initialAbsolute = true;
            PathSegment {
                initialName = "segm/?;ent1";
                Parameter {
                    initialName = "par/?;=am1";
                },
                Parameter {
                    initialName = "par/?;=am2";
                    initialValue = "val/?;=#ue";
                }
            },
            PathSegment {
                initialName = "segment2";
            }
        };
//        query = "par&=#am3&par&=#am4=val&=#ue2";
        query = "par%26%3D%23am3&par%26%3D%23am4=val%26%3D%23ue2";
        decomposedQuery = Query {
            Parameter {
                initialName = "par&=#am3";
            },
            Parameter {
                initialName = "par&=#am4";
                initialValue = "val&=#ue2";
            }
        };
        fragment = "frag&=#ment";
    };
        
}

void testAll(){
    test(testDecomposition, "Decomposition test", null);
    test(testComposition, "Composition test", null);
    test(testInvalidPort, "Invalid port", "Invalid port number: bar");
    test(testInvalidPort2, "Invalid port2", "Invalid port number: -23");
    test(testDecoding, "Decoding test", null);
    
    printResults();
}
