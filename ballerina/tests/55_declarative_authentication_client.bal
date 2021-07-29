// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithCaller() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "write" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendString("Hello");
    check strClient->complete();
    string? s = check strClient->receiveString();
    if s is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(s, "Hello");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithCallerUnauthenticated() returns error? {
    map<string|string[]> requestHeaders = {
        "x-id": "0987654321",
        "authorization": "bearer "
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendContextString({
        content: "Hello",
        headers: requestHeaders
    });
    check strClient->complete();
    string|Error? s = strClient->receiveString();
    if s is UnauthenticatedError {
        test:assertEquals(s.message(), "Failed to authenticate client");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithCallerInvalidPermission() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "read" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithCallerStreamingClient strClient = check hClient->hello55BiDiWithCaller();
    check strClient->sendString("Hello");
    check strClient->complete();
    string|Error? s = strClient->receiveString();
    if s is PermissionDeniedError {
        test:assertEquals(s.message(), "Permission denied");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthBiDiWithReturn() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "write" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };
    ClientSelfSignedJwtAuthHandler handler = new(config);
    map<string|string[]> requestHeaders = {};
    requestHeaders = check handler.enrich(requestHeaders);

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55BiDiWithReturnStreamingClient strClient = check hClient->hello55BiDiWithReturn();
    check strClient->sendString("Hello");
    check strClient->complete();
    string? s = check strClient->receiveString();
    if s is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(s, "Hello");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthUnary() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "write" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error result = hClient->hello55UnaryWithCaller("Hello");
    if result is Error {
        test:assertFail(result.message());
    } else {
        test:assertEquals(result, "Hello");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthUnaryUnauthenticated() returns error? {
    map<string|string[]> requestHeaders = {
        "authorization": "bearer "
    };
    ContextString ctxString = {
        headers: requestHeaders,
        content: "Hello"
    };

    helloWorld55Client hClient = check new ("http://localhost:9155");
    string|Error result = hClient->hello55UnaryWithCaller(ctxString);
    if result is Error {
        test:assertEquals(result.message(), "Failed to authenticate client");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthUnaryInvalidPermission() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        customClaims: { "scope": "read" },
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error result = hClient->hello55UnaryWithCaller("Hello");
    if result is Error {
        test:assertEquals(result.message(), "Permission denied");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testHello55LdapAuth() returns error? {
    CredentialsConfig config = {
        username: "alice",
        password: "alice@123"
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error response = hClient->hello55UnaryWithReturn("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55BasicAuth() returns error? {
    CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error response = hClient->hello55UnaryWithReturn("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55OAuth2Auth() returns error? {
    OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        scopes: ["write"],
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    string|Error response = hClient->hello55UnaryWithReturn("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55JWTAuthWithEmptyScope() returns error? {
    JwtIssuerConfig config = {
        username: "admin",
        issuer: "wso2",
        audience: ["ballerina"],
        signatureConfig: {
            config: {
                keyStore: {
                    path: KEYSTORE_PATH,
                    password: "ballerina"
                },
                keyAlias: "ballerina",
                keyPassword: "ballerina"
            }
        }
    };

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string|Error? result = check hClient->hello55EmptyScope("Hello");
    if result is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(result, "Hello");
    }
}

@test:Config {enable: true}
function testHello55LdapAuthWithEmptyScope() returns error? {
    CredentialsConfig config = {
        username: "alice",
        password: "alice@123"
    };

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string|Error response = hClient->hello55EmptyScope("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55BasicAuthWithEmptyScope() returns error? {
    CredentialsConfig config = {
        username: "admin",
        password: "123"
    };

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string|Error response = hClient->hello55EmptyScope("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55OAuth2AuthWithEmptyScope() returns error? {
    OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };

    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255", {auth: config});
    string|Error response = hClient->hello55EmptyScope("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        test:assertEquals(response, "Hello");
    }
}

@test:Config {enable: true}
function testHello55ServerStreamingOAuth2Auth() returns error? {
    OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    stream<string, Error?>|Error response = hClient->hello55ServerStreaming("Hello");
    if response is Error {
        test:assertFail(response.message());
    } else {
        var value1 = response.next();
        var value2 = response.next();
        if value1 is Error || value2 is Error {
            test:assertFail("Error occured");
        } else if value1 is () || value2 is () {
            test:assertFail("Expected a non null response");
        } else {
            test:assertEquals(value1["value"], "Hello 1");
            test:assertEquals(value2["value"], "Hello 2");
        }
    }
}

@test:Config {enable: true}
function testHello55ClientStreamingOAuth2Auth() returns error? {
    OAuth2ClientCredentialsGrantConfig config = {
        tokenUrl: "https://localhost:" + oauth2AuthorizationServerPort.toString() + "/oauth2/token",
        clientId: "3MVG9YDQS5WtC11paU2WcQjBB3L5w4gz52uriT8ksZ3nUVjKvrfQMrU4uvZohTftxStwNEW4cfStBEGRxRL68",
        clientSecret: "9205371918321623741",
        clientConfig: {
            secureSocket: {
               cert: {
                   path: TRUSTSTORE_PATH,
                   password: "ballerina"
               }
            }
        }
    };

    helloWorld55Client hClient = check new ("http://localhost:9155", {auth: config});
    Hello55ClientStreamingStreamingClient sClient = check hClient->hello55ClientStreaming();
    check sClient->sendString("Hello");
    check sClient->sendString("World");
    check sClient->complete();

    string|Error? response = sClient->receiveString();
    if response is Error {
        test:assertFail(response.message());
    } else if response is () {
        test:assertFail("Expected a response");
    } else {
        test:assertEquals(response, "Hello World");
    }
}

@test:Config {enable: true}
function testHello55EmptyAuthHeader() returns error? {
    helloWorld55EmptyScopeClient hClient = check new ("http://localhost:9255");
    string|Error response = hClient->hello55EmptyScope("Hello");
    if response is Error {
        test:assertEquals(response.message(), "Authorization header does not exist");
    } else {
        test:assertFail("Expected an error");
    }
}
