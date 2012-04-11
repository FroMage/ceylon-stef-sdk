import fr.epardaud.collections { ... }

by "Stéphane Épardaud"
doc "Represents a JSON Object"
shared class Object() satisfies Iterable<String> {
    
    MutableMap<String, String|Boolean|Number|Object|Array|NullInstance> contents = HashMap<String, String|Boolean|Number|Object|Array|NullInstance>();
    
    doc "Adds a new property mapping"
    shared void put(String key, String|Boolean|Number|Object|Array|Nothing val){
        if(exists val){
            contents.put(key, val);
        }else{
            contents.put(key, nullInstance);
        }
    }

    doc "Gets a property value by name"
    shared String|Boolean|Number|Object|Array|Nothing get(String key){
        value val = contents[key];
        if(is NullInstance val){
            return null;
        }
        switch(val)
        case (is String|Boolean|Number|Object|Array) {
            return val;
        }else{
            // key does not exist
            return null;
        }
    }
    
    doc "Returns the number of properties"
    shared Integer size {
        return contents.size;
    }

    doc "Returns true if the given property is defined, even if it's set to `null`"
    shared Boolean defines(String key){
        return contents.defines(key);
    }

    doc "Returns true if this object has no properties"
    shared actual Boolean empty {
        return contents.empty;
    }
    
    doc "Returns a iterator for the property names"
    shared actual Iterator<String> iterator {
        return contents.keys.iterator;
    }
    
    doc "Returns a serialised JSON representation"
    shared actual String string {
        StringBuilder b = StringBuilder();
        printObject(this, b);
        return b.string;
    }

    void printObject(Object o, StringBuilder b){
        b.append("{");
        variable Boolean once := true; 
        for(key in o){
            if(once){
                once := false;
            }else{
                b.append(",");
            }
            printString(key, b);
            b.append(":");
            printValue(o.get(key), b);
        }
        b.append("}");
    }

    void printArray(Array o, StringBuilder b){
        b.append("[");
        variable Boolean once := true; 
        for(elem in o){
            if(once){
                once := false;
            }else{
                b.append(",");
            }
            printValue(elem, b);
        }
        b.append("]");
    }

    void printValue(String|Boolean|Number|Object|Array|Nothing val, StringBuilder b){
        if(!exists val){
            printNull(b);
        }
        if(is String val){
            printString(val, b);
        }
        if(is Number val){
            printNumber(val, b);
        }
        if(is Boolean val){
            printBoolean(val, b);
        }
        if(is Object val){
            printObject(val, b);
        }
        if(is Array val){
            printArray(val, b);
        }
    }
            
    void printString(String s, StringBuilder b){
        b.append("\"");
        for(c in s){
            if(c == `"`){
                b.append("\\" + "\"");
            }else if(c == `\\`){
                b.append("\\\\");
            }else if(c == `/`){
                b.append("\\" + "/");
            }else if(c == 8.character){
                b.append("\\" + "b");
            }else if(c == 12.character){
                b.append("\\" + "f");
            }else if(c == 10.character){
                b.append("\\" + "n");
            }else if(c == 13.character){
                b.append("\\" + "r");
            }else if(c == 9.character){
                b.append("\\" + "t");
            }else{
                b.append(c.string);
            }
        }
        b.append("\"");
    }

    void printNumber(Number n, StringBuilder b){
        b.append(n.string);
    }

    void printBoolean(Boolean v, StringBuilder b){
        b.append(v.string);
    }

    void printNull(StringBuilder b){
        b.append("null");
    }
}