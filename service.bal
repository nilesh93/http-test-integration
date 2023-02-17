import ballerina/io;
import ballerina/http;

configurable string proxyURL = ?;
configurable string proxyURLPath = ?;
configurable string token = ?;

public function main() {
    do {
        http:Client proxyEndpoint = check new (proxyURL,
        httpVersion = http:HTTP_1_1,
        secureSocket = {
            enable: false
        });

        json res = check proxyEndpoint->get(proxyURLPath, {
            "Authorization": "Basic " + token
        });

        io:println("success invocation: ", res);
    } on fail var e {
        io:println("failed invocation: ", e);
    }
}

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + return - string name with hello message or error
    resource function get test() returns json|error {
        http:Client proxyEndpoint = check new (proxyURL);
        json res = check proxyEndpoint->get(proxyURLPath);
        return res;
    }
}

