import ballerina/io;
import ballerina/http;

configurable string proxyURL = ?;
configurable string proxyURLPath = ?;
configurable string token = ?;

public function main() {
    do {
        json res = check callAPI();
        io:println("success invocation: ", res);
    } on fail var e {
        io:println("failed invocation: ", e);
    }
}

function callAPI() returns json|error {
    http:Client proxyEndpoint = check new (proxyURL,
        httpVersion = http:HTTP_1_1,
        secureSocket = {
        enable: false
    });

    json res = check proxyEndpoint->get(proxyURLPath, {
        "Authorization": "Basic " + token
    });
    return res;
}

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + return - string name with hello message or error
    resource function get test() returns json|error {
        json res = check callAPI();
        return res;
    }
}

