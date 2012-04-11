import java.util { List, LinkedList, JIterator = Iterator }
import java.lang { JIterable = Iterable }
import fr.epardaud.iop { toIterable }


List<Result> results = LinkedList<Result>();

class Result(String? title, String? message = null, Boolean passed = false, Exception? exception = null){
    shared String? title = title;
    shared String? message = message;
    shared Boolean passed = passed;
    shared Exception? exception = exception;
    shared void print() {
        if(exists title){
            process.write("[" title "] ");
        }
        process.write(passed then "PASSED" else "FAILED");
        if(exists message){
            process.write(": " message "");
        }
        process.write("\n");
        if(exists exception){
            exception.printStackTrace();
        }
    }
}

void success(String? title){
    results.add(Result{title = title; passed = true;});
}

void failure(String? title, String message, Exception? x = null){
    results.add(Result{title = title; message = message; exception = x;});
}

doc "Invokes the given test function, with optional title and expected exception"
shared void test(void f(), String? title = null, String? expectException = null){
    try{
        f();
        // no exception but we were expecting one
        if(exists expectException){
            failure(title, "Expected exception "+expectException+" but got no exception");
        }
    }catch(Exception x){
        if(exists expectException){
            if(x.message == expectException){
                success(title);
            }else{
                failure(title, "Expected exception "+expectException+" but got "+x.message, x);
            }
        }else{
            failure(title, x.message, x);
        }
    }
}

doc "Checks that two objects are equal, with optional title"
shared void assertEquals(Object? a, Object? b, String? title = null){
    if(exists a){
        if(exists b){
            if(a == b){
                success(title);
            }else{
                failure(title, "Expected " a.string " but got " b.string "");
            }
        }else{
            failure(title, "Expected " a.string " but got null");
        }
    }else{
        if(exists b){
            failure(title, "Expected null but got " b.string "");
        }else{
            success(title);
        }
    }
}

doc "Checks that a value is true, with optional title"
shared void assertTrue(Boolean test, String? title = null){
    if(test){
        success(title);
    }else{
        failure(title, "Expected true but got false");
    }
}

doc "Fail, with optional title"
shared void fail(String? title = null){
    failure(title, "Assertion failed");
}

doc "Print test results"
shared void printResults(){
    variable Integer success := 0;
    variable Integer failure := 0;
    for(Result res in toIterable(results)){
        if(res.passed){
            success++;
        }else{
            failure++;
            res.print();
        }
    }
    print("" (success + failure).string " tests run: " success " passed, " failure " failed");
}