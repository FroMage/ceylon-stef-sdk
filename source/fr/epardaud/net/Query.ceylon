import java.util{ List, ArrayList }

doc "Represents a URI Query part"
by "Stéphane Épardaud"
shared class Query(Parameter... initialParameters) {
    
    doc "The list of query parameters"
    shared List<Parameter> parameters = ArrayList<Parameter>();
    
    for(Parameter p in initialParameters){
        parameters.add(p);
    }

    doc "Adds a query parameter"
    shared void add(Parameter param){
        parameters.add(param);
    }

    doc "Adds a single raw (percent-encoded) query parameter, where name and value have to be parsed"
    shared void addRaw(String part){
        add(parseParameter(part));
    }

    doc "Returns true if we have any query parameter"
    shared Boolean specified {
        return !parameters.empty;
    }

    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Query that){
            if(this === that){
                return true;
            }
            return parameters == that.parameters; 
        }
        return false;
    }
    
    String serialiseParameter(Parameter param, Boolean human) {
        if(human){
            return param.toRepresentation(true);
        }
        if(exists String val = param.val){
            return percentEncoder.encodeQueryPart(param.name) + "=" + percentEncoder.encodeQueryPart(val);
        }else{
            return percentEncoder.encodeQueryPart(param.name);
        }
    }

    doc "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"    
    shared String toRepresentation(Boolean human) { 
        if(parameters.empty){
            return "";
        }
        StringBuilder b = StringBuilder();
        for(Integer i in 0..parameters.size()-1){
            if(i > 0){
                b.appendCharacter(`&`);
            }
            b.append(serialiseParameter(parameters.get(i), human));
        }
        return b.string;
    }

    doc "Returns an externalisable (percent-encoded) representation of this part"    
    shared actual String string {
        return toRepresentation(false);
    }
    
    doc "Returns a human (non parseable) representation of this part"    
    shared String humanRepresentation {
        return toRepresentation(true);
    }
}
