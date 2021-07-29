
import ballerina/test;

@test:Config {enable: true}
function testHello55LdapAuth() returns error? {
    if !isWindowsEnvironment() {
        CredentialsConfig config = {
            username: "alice",
            password: "alice@123"
        };
        check ep55WithLdapWithScopes.attach(helloWorld55, "helloWorld55");
        check ep55WithLdapWithScopes.'start();

        helloWorld55Client hClient = check new ("http://localhost:9256", {auth: config});
        string|Error response = hClient->hello55UnaryWithReturn("Hello");
        if response is Error {
            test:assertFail(response.message());
        } else {
            test:assertEquals(response, "Hello");
        }
    }
}