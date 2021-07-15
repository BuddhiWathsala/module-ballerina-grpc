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

import ballerina/log;

listener Listener ep26 = new (9116);

@ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_26,
    descMap: getDescriptorMap26()
}
service "HelloWorld26" on ep26 {

    remote isolated function lotsOfGreetings(stream<string, error?> clientStream) returns string {
        log:printInfo("connected sucessfully.");
        error? e = clientStream.forEach(isolated function(string name) {
            log:printInfo("greet received: " + name);
        });
        if e is () {
            return "Ack";
        }
        return "";
    }
}
