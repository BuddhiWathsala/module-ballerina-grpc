import ballerina/io;
import ballerina/time;

listener Listener ep = new (9149);

@ServiceDescriptor {descriptor: ROOT_DESCRIPTOR_49, descMap: getDescriptorMap49()}
service "DurationHandler" on ep {

    remote function unaryCall1(string value) returns time:Seconds|error {
        io:println(value);
        return 12.34d;
    }
    remote function unaryCall2(DurationMsg value) returns DurationMsg|error {
        io:println(value);
        return value;
    }
    remote function clientStreaming(stream<time:Seconds, Error?> clientStream) returns string|error {
        check clientStream.forEach(function(time:Seconds d) {
            io:println(d);
        });
        return "Ack";
    }
    remote function serverStreaming(string value) returns stream<time:Seconds, error?>|error {
        io:println("Call");
        time:Seconds[] durations = [1.11d, 2.22d, 3.33d, 4.44d];
        return durations.toStream();
    }
    remote function bidirectionalStreaming(stream<DurationMsg, Error?> clientStream) returns stream<DurationMsg, error?>|error {
        return clientStream;
    }
}

