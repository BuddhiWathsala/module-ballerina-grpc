import ballerina/test;
import ballerina/io;
import ballerina/time;

@test:Config{}
function testDurationUnary() returns Error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    time:Seconds msg = check ep->unaryCall1("call1");
    io:println(msg);
}

@test:Config{}
function testDurationServerStreaming() returns Error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    stream<time:Seconds, Error?> durationStream = check ep->serverStreaming("server streaming with duration");
    check durationStream.forEach(function(time:Seconds d) {
        io:println(d);
    });
}

@test:Config{}
function testDurationClientStreaming() returns Error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    time:Seconds[] durations = [1.11d, 2.22d, 3.33d, 4.44d];
    ClientStreamingStreamingClient sc = check ep->clientStreaming();
    foreach time:Seconds d in durations {
        check sc->sendDuration(d);
    }
    check sc->complete();
    string? ack = check sc->receiveString();
    if ack is string {
        io:println(ack);
    }

}

@test:Config{}
function testDurationBidirectionalStreaming() returns Error? {
    DurationHandlerClient ep = check new ("http://localhost:9149");
    DurationMsg[] durationMessages = [
        {name: "duration 01", duration: 1.11d},
        {name: "duration 02", duration: 2.22d},
        {name: "duration 03", duration: 3.33d},
        {name: "duration 04", duration: 4.44d}
    ];
    BidirectionalStreamingStreamingClient sc = check ep->bidirectionalStreaming();
    foreach DurationMsg dm in durationMessages {
        check sc->sendDurationMsg(dm);
    }
    check sc->complete();
    int i = 0;
    DurationMsg? response = check sc->receiveDurationMsg();
    if response is DurationMsg {
        test:assertEquals(response, durationMessages[i]);
        i += 1;
    }
    while !(response is ()) {
        response = check sc->receiveDurationMsg();
        if response is DurationMsg {
            test:assertEquals(response, durationMessages[i]);
            i += 1;
        }
    }
    test:assertEquals(i, 4);
}

